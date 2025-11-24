module lsh(rst, clk, load, md, sh, a_out);

input               rst;
input               clk;
input               load;
input [15:0]        md;
input               sh;
output reg [31:0]   a_out;

always @(negedge clk)
    if(rst)
        a_out = 0 ;
    else
        if(load)
            a_out = md ;
        else
            begin
                if(sh) 
                    a_out = a_out << 1 ;
                else  
                    a_out = a_out;
            end

endmodule