`timescale 1ns / 1ps
`define SIMULATION
module div_TB;

reg           rst;
reg           clk;
reg           start;
reg [15:0]    in_dv;
reg [15:0]    in_dr;
wire [15:0]   r;
wire          done;

div uut (.clk(clk), .rst(rst), .start(start), .dv(in_dv), .dr(in_dr), .r(r), .done(done));
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
clk = 0; rst = 1; start = 0; in_dv = 16'h000A; in_dr = 16'h0002;
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
start = 0;
@ (posedge clk);
start = 1;
for(i=0; i<2; i=i+1) begin
@ (posedge clk);
end
start = 0;
for(i=0; i<17; i=i+1) begin
@ (posedge clk);
end
end
initial begin: TEST_CASE
$dumpfile("div_TB.vcd");
$dumpvars(-1, uut);
#((PERIOD*DUTY_CYCLE)*120) $finish;
end
endmodule