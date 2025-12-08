module count_wait(
    input                   clk,
    input                   rst,
    input                   RST_WT,
    input                   DEC_WT,
    output                  ZRD
);

reg [12:0]        count;

always @(negedge clk) begin
  if(rst)
    count <= 0;
  else if(RST_CONF)
    count <= 7441;
  else if(DEC_WT)
    count <= count - 1;
  end
assign ZWT = (count == 0) ? 1 : 0;
endmodule