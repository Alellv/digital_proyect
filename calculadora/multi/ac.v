module ac (rst, clk, a_in, add, pp);

input               rst;
input               clk;
input [31:0]        a_in;
input               add;
output reg [31:0]   pp;

always @(negedge clk or posedge rst) begin
    if(rst)
        pp <= 32'b0;
    else begin
        if (add) 
            pp <= pp + a_in;
        else 
            pp <= pp;
    end
end

endmodule