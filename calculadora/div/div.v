module div (rst,clk,start,dv,dr,r,done);

input           rst;
input           clk;
input           start;
input [15:0]    dv;
input [15:0]    dr;
output [15:0]   r;
output          done;

wire w_z;
wire w_sh;
wire w_init;
wire w_lda;
wire w_dv0;
wire w_dec;

wire [15:0]     w_mbb;
wire [4:0]      w_comp;
wire [15:0]     w_out_a;

ctrl ctrl       (.rst(rst), .clk(clk), .start(start), .mbb(w_mbb), .z(w_z), .sh(w_sh), .init(w_init), .lda(w_lda), .dv0(w_dv0), .dec(w_dec), .done(done));
a a             (.rst(rst), .clk(clk), .dv(dv), .r(r), .lda(w_lda), .mbb(w_mbb), .out_ca2(w_out_a), .dv0(w_dv0), .init(w_init), .sh(w_sh));
sc_a2 sc_a2     (.rst(rst), .in_a(w_out_a), .dr(dr), .out_mbb(w_mbb));
count count     (.rst(rst), .clk(clk), .init(w_init), .dec(w_dec), .out(w_comp));
comp comp       (.rst(rst), .in(w_comp), .z(w_z));

endmodule