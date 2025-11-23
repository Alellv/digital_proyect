`timescale 1ns / 1ps
module tb_bcd2bin;
    reg clk, reset, start;
    reg [19:0] bcd_in;
    wire [15:0] bin_out;
    wire done;

    // Conectar al TOP
    bcd2bin_top uut (
        .clk(clk), .reset(reset), .start(start),
        .bcd_in(bcd_in), .bin_out(bin_out), .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sim_inversa.vcd");
        $dumpvars(0, tb_bcd2bin);
        
        clk=0; reset=1; start=0; bcd_in=0;
        #20; reset=0; #10;

        // PRUEBA: Convertir BCD 00255 -> Binario FF
        $display("Test: Convirtiendo 255...");
        bcd_in = 20'h00255; 
        start = 1; #10; start = 0;
        
        wait(done);
        $display("Resultado Hex: %h (Esperado: 00ff)", bin_out);
        #50;
        $finish;
    end
endmodule