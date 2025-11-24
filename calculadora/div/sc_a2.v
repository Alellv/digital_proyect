module sc_a2 (rst,in_a,dr,out_mbb);

input rst;
input [15:0]in_a;
input [15:0]dr;
output reg [15:0]out_mbb;

always @(*) begin
    
    if(rst)
        out_mbb <= 0;
    else
        out_mbb <= in_a + (~dr+16'd1);

end

endmodule
