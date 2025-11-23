module count (rst,clk,init,dec,out);

input rst;
input clk;
input init;
input dec;
output reg [4:0] out;

always @(negedge clk )begin
    
    if (rst)
        out=0;
    else
        if(init)
            out=5'd16;
        else
            if(dec) out=out-1;
            else out=out;

end

endmodule