`timescale 1ns / 1ps

module tb_bin2bcd;

    reg clk;
    reg reset;
    reg init;
    reg [15:0] bin_in;

    wire [19:0] bcd_out;
    wire done;

    bin2bcd_top uut (
        .clk(clk), 
        .reset(reset), 
        .init(init), 
        .bin_in(bin_in), 
        .bcd_out(bcd_out), 
        .done(done)
    );

    always #5 clk = ~clk; 

    initial begin
        $dumpfile("simulacion.vcd");
        $dumpvars(0, tb_bin2bcd);   

        clk = 0;
        reset = 1;
        init = 0;
        bin_in = 0;
        
        $display("--- Iniciando Simulacion ---");

        #20;           
        reset = 0;      
        #10;

        $display("Test 1: Enviando 255 (Espere...)");
        bin_in = 16'd255; 
        init = 1;     
        #10;           
        init = 0;      

        wait(done);     
        $display("Test 1 Terminado. Salida BCD (Hex): %h", bcd_out);
        #20;

        $display("Test 2: Enviando 65535 (Espere...)");
        reset = 1; #10; reset = 0; 
        bin_in = 16'd65535;
        init = 1;
        #10;
        init = 0;

        wait(done);
        $display("Test 2 Terminado. Salida BCD (Hex): %h", bcd_out);
        #50;

        $display("--- Fin de Simulacion ---");
        $finish; 
    end

endmodule
