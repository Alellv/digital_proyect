module multi(clk,rst,start,md,mr,pp,done);
  
input         rst;
input         clk;
input         start;
input [15:0]  md;
input [15:0]  mr;
output [31:0] pp;
output        done;

wire w_sh;
wire w_load;
wire w_add;
wire w_z;
  
wire [31:0] w_A;
wire [15:0] w_B;

ctrl ctrl       (.rst(rst), .clk(clk), .start(start), .load(w_load), .lsbb(w_B[0]), .z(w_z), .sh(w_sh), .add(w_add), .done(done));
lsh lsh         (.rst(rst), .clk(clk), .load(w_load), .md(md), .sh(w_sh), .a_out(w_A));
rsh rsh         (.rst(rst), .clk(clk), .load(w_load), .mr(mr), .sh(w_sh), .b_out(w_B));
ac ac           (.rst(rst), .clk(clk), .a_in(w_A), .add(w_add), .pp(pp));
comp comp       (.rst(rst), .b_in(w_B), .z(w_z));

endmodule