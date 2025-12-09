module count_by(
    input                   clk,
    input                   rst,
    input                   RST_BYR,
    input                   RST_BYW,
    input                   DEC_BY,
    output reg [2:0]        cnt_by,
    output                  ZBY
);

always @(negedge clk) begin
  if(rst)
    cnt_by <= 3;
  else if(RST_BYW)
    cnt_by <= 3;
  else if(RST_BYR)
    cnt_by <= 6;
  else if(DEC_BY)
    cnt_by <= cnt_by - 1;
  end

assign ZBY = (cnt_by == 0) ? 1 : 0;
endmodule