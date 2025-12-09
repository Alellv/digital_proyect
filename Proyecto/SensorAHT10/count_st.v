module count_st(
    input                   clk,
    input                   rst,
    input                   INC_ST,
    input                   DEC_ST,
    output reg [1:0]        cnt_st
);

always @(negedge clk) begin
  if(rst)
    cnt_st <= 1;
  else if(INC_ST)
    cnt_st <= cnt_st + 1;
  else if(DEC_ST)
    cnt_st <= cnt_st - 1;
  end

endmodule