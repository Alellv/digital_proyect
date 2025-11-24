module a (rst,clk,dv,r,lda,mbb,out_ca2,dv0,init,sh);

input rst;
input clk;
input init;
input [15:0]mbb;
input [15:0]dv;
input lda;
input dv0;
input sh;

output reg [15:0]out_ca2;
output reg [15:0]r;

reg [31:0]data;

always @(negedge clk ) begin

    if(rst) begin
        data<=0;
        out_ca2<=0;
        r=0;
    end
    else
        if(init) begin
            data[31:16] <= 16'h0000;
            data[15:0] <= dv;
        end
        else
            begin
                if(dv0)
                    data[0] <= 1;
                if(sh)
                    data[31:0] <= {data[30:0],1'b0};
                if(lda)
                    data[31:16] <= mbb;
                r <= data[15:0];
                out_ca2 <= data[31:16];
            end
        
    
end

endmodule
