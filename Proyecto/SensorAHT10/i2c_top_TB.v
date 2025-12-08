`timescale 1ns / 1ps
`define SIMULATION
module i2c_top_TB;

    input           rst;
    input           clk;
    input           init;
    output          SCL;
    output          I1;
    output          I2;
    output          I3;
    inout           SDA;


i2c_top uut (.clk(clk), .rst(rst), .init(init), .SCL(SCL), .I1(I1), .I2(I2), .I3(I3), .SDA(SDA));
parameter PERIOD
= 20;
parameter real DUTY_CYCLE = 0.5;
parameter OFFSET
= 0;
reg [20:0] i;
event reset_trigger;
event reset_done_trigger;
initial begin
forever begin
@ (reset_trigger);
@ (negedge clk);
rst = 1;
@ (negedge clk);
rst = 0;
-> reset_done_trigger;
end
end
initial begin // Initialize Inputs
clk = 0; rst = 1; init = 0;
end
initial begin // Process for clk
#OFFSET;
forever
begin
clk = 1'b0;
#(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
#(PERIOD*DUTY_CYCLE);
end
end
initial begin // Reset the system, Start the image capture process
#10 -> reset_trigger;
@ (reset_done_trigger);
@ (posedge clk);
init = 0;
@ (posedge clk);
init = 1;
for(i=0; i<2; i=i+1) begin
@ (posedge clk);
end
init = 0;
for(i=0; i<17; i=i+1) begin
@ (posedge clk);
end
end
initial begin: TEST_CASE
$dumpfile("i2c_top_TB.vcd");
$dumpvars(-1, uut);
#((PERIOD*DUTY_CYCLE)*120) $finish;
end
endmodule