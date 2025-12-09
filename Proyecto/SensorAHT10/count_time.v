module count_time(
    input                   clk,
    input                   rst,
    output reg [1:0]        cnt_tick,
    output                  i2c_tick
);

reg [5:0] count;

always @(negedge clk) begin
  if(rst) begin
    count <= 0;
    cnt_tick <= 0;
  end
  else if (count == 62) begin
      count <= 0;
      cnt_tick <= cnt_tick + 1;
  end
    else count <= count + 1;
    
  end

assign i2c_tick = (count == 62) ? 1'b1 : 1'b0;
endmodule
