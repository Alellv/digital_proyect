module comp_tick(
  input         i2c_tick,
  input [1:0]   cnt_tick,  
  output  reg   SH_ST
);

  always @(*) begin
    if(i2c_tick && cnt_tick == 3)
      SH_ST = 1;
    else
      SH_ST = 0;
  end

endmodule