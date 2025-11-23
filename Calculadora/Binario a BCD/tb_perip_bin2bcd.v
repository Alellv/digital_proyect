`timescale 1ns / 1ps

module tb_perip_bin2bcd;

    // Señales del Bus
    reg clk;
    reg reset;
    reg [4:0] addr;
    reg [31:0] din;
    reg cs;
    reg wr;
    wire [31:0] dout;
    
    // Variable para lectura segura
    reg [31:0] dato_leido_safe;

    // Instancia del Periférico (Device Under Test)
    perip_bin2bcd uut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .din(din),
        .cs(cs),
        .wr(wr),
        .dout(dout)
    );

    // Reloj
    always #5 clk = ~clk;

    // --- TAREAS DEL BUS (Con el fix del #1 incluido) ---
    
    task escribir_bus(input [4:0] direccion, input [31:0] dato);
        begin
            @(posedge clk);
            addr = direccion;
            din = dato;
            cs = 1;
            wr = 1;
            @(posedge clk);
            cs = 0;
            wr = 0;
            addr = 0;
            din = 0;
        end
    endtask

    task leer_bus(input [4:0] direccion);
        begin
            @(posedge clk);
            addr = direccion;
            cs = 1;
            wr = 0;
            @(posedge clk);
            
            #1; // Retardo clave para evitar lectura de ceros
            
            dato_leido_safe = dout; 
            cs = 0;
            addr = 0;
        end
    endtask

    // --- PROCESO DE PRUEBA ---
    initial begin
        $dumpfile("sim_perip_bin.vcd");
        $dumpvars(0, tb_perip_bin2bcd);

        clk = 0; reset = 1; addr = 0; din = 0; cs = 0; wr = 0;
        #20; reset = 0; #20;

        $display("--- INICIO TEST PERIFERICO BIN2BCD ---");

        // 1. ESCRIBIR EL DATO BINARIO (255 = 0xFF)
        // Dirección 0x04
        $display("[CPU] Enviando Binario 255 (0xFF)...");
        escribir_bus(5'h04, 32'h000000FF);

        // 2. DAR START
        // Dirección 0x08
        $display("[CPU] Dando Start...");
        escribir_bus(5'h08, 32'h00000001);

        // 3. ESPERAR (POLLING DONE)
        // Dirección 0x14
        $display("[CPU] Esperando...");
        leer_bus(5'h14);
        while (dato_leido_safe == 0) begin
            #10;
            leer_bus(5'h14);
        end
        $display("[CPU] Done recibido!");

        // 4. LEER RESULTADO BCD
        // Dirección 0x10
        leer_bus(5'h10);
        
        // El resultado BCD de 255 debe verse como 0x255
        $display("Resultado BCD: %h (Esperado: 00000255)", dato_leido_safe);

        #50;
        $finish;
    end

endmodule