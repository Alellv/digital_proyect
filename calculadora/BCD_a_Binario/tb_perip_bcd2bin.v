`timescale 1ns / 1ps

module tb_perip_bcd2bin;

    reg clk;
    reg reset;
    reg [4:0] addr;
    reg [31:0] din;
    reg cs;
    reg wr;
    wire [31:0] dout;
    
    reg [31:0] dato_leido_safe; 

    perip_bcd2bin uut (
        .clk(clk), .reset(reset), .addr(addr), .din(din), .cs(cs), .wr(wr), .dout(dout)
    );

    always #5 clk = ~clk;

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
            
            #1;

            dato_leido_safe = dout; 
            cs = 0;
            addr = 0;
        end
    endtask

    initial begin
        $dumpfile("sim_perip.vcd");
        $dumpvars(0, tb_perip_bcd2bin);

        clk = 0; reset = 1; addr = 0; din = 0; cs = 0; wr = 0;
        #20; reset = 0; #20;

        $display("--- INICIO TEST ---");

        escribir_bus(5'h04, 32'h00000255);
        escribir_bus(5'h08, 32'h00000001);

        leer_bus(5'h14);
        while (dato_leido_safe == 0) begin 
            #10;
            leer_bus(5'h14);
        end
        $display("Done recibido!");

        leer_bus(5'h10);
        
        $display("Resultado Final: %h (Esperado: 000000ff)", dato_leido_safe);

        #50;
        $finish;
    end
endmodule
