module comp (rst, b_in, z);

input           rst;
input [15:0]    b_in;
output reg      z;

always @(*) begin

    if(rst)
        z=0;
    else
        z= (b_in==0) ? 1'b1 :1'b0 ;

end

endmodule