`timescale 1ns / 1ps

module tb_perip_bcd2bin;

    // Señales
    reg clk;
    reg reset;
    reg [4:0] addr;
    reg [31:0] din;
    reg cs;
    reg wr;
    wire [31:0] dout;
    
    // Variable temporal para guardar lo que leemos
    reg [31:0] dato_leido_safe; 

    perip_bcd2bin uut (
        .clk(clk), .reset(reset), .addr(addr), .din(din), .cs(cs), .wr(wr), .dout(dout)
    );

    always #5 clk = ~clk;

    // --- TAREAS ---
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

    // TAREA CORREGIDA: Captura el dato antes de apagar CS
    task leer_bus(input [4:0] direccion);
        begin
            @(posedge clk);
            addr = direccion;
            cs = 1;
            wr = 0;
            @(posedge clk);
            
            #1;

            dato_leido_safe = dout; 
            cs = 0;
            addr = 0;
        end
    endtask

    // --- TEST ---
    initial begin
        $dumpfile("sim_perip.vcd");
        $dumpvars(0, tb_perip_bcd2bin);

        clk = 0; reset = 1; addr = 0; din = 0; cs = 0; wr = 0;
        #20; reset = 0; #20;

        $display("--- INICIO TEST ---");

        // 1. Escribir 255
        escribir_bus(5'h04, 32'h00000255);
        // 2. Start
        escribir_bus(5'h08, 32'h00000001);

        // 3. Polling
        leer_bus(5'h14);
        // Usamos la variable guardada para chequear
        while (dato_leido_safe == 0) begin 
            #10;
            leer_bus(5'h14);
        end
        $display("Done recibido!");

        // 4. Leer Resultado
        leer_bus(5'h10);
        
        // Imprimimos la variable guardada, no el cable directo
        $display("Resultado Final: %h (Esperado: 000000ff)", dato_leido_safe);

        #50;
        $finish;
    end
endmodule