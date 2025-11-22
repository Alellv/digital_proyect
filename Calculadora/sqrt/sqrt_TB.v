`timescale 1ns/1ps

module sqrt_TB;

// señales
reg         clk;
reg         reset;
reg         init;
reg [15:0]  op_A;

wire        done;
wire [15:0] result; 

// instancia del DUT
sqrt uut(
    .reset(reset),
    .clk(clk),
    .init(init),
    .done(done),
    .op_A(op_A),
    .result(result)
);

// VCD
initial begin
    $dumpfile("sqrt_TB.vcd");
    $dumpvars(0, sqrt_TB);
end


// reloj
initial begin
    clk = 0;
    forever #5 clk = ~clk;   // periodo 10ns
end

// estímulos
initial begin

    // inicio
    reset = 1;
    init = 0;
    op_A = 0;

    #20;
    reset = 0;

    // TEST 1 : sqrt(144) = 12
    op_A = 16'd144;
    init = 1;
    #10 init = 0;

    wait(done == 1);

    #20;
    $finish;

end

endmodule
