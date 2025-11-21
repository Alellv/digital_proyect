module comp (rst,in,z);

input rst;
input [4:0]in;
output reg z;

always @(*) begin

    if(rst)
        z=0;
    else
        z= (in==0) ? 1'b1 :1'b0 ;

end

endmodule