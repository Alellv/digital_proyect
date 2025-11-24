module rsh(rst, clk, load, mr, sh, b_out);

input               rst;
input               clk;
input               load;
input [15:0]        mr;
input               sh;
output reg [15:0]   b_out;

always @(negedge clk)
    if(rst)
        b_out = 0 ;
    else
        if(load)
            b_out = mr ;
        else
            begin
                if(sh) 
                    b_out = b_out >> 1 ;
                else  
                    b_out = b_out;
            end


endmodule