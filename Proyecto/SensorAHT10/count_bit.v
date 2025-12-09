module count_bit(
    input                   clk,
    input                   rst,
    input                   RST_BC,
    input                   INC_BC,
    output                  ZBC
);

reg [3:0]        count;

always @(negedge clk) begin
  if(rst||RST_BC)
    count <= 0;
  else if(INC_BC)
    count <= count + 1;
  end
assign ZBC = (count == 8) ? 1 : 0;
endmodule