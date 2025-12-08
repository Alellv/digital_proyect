module comp_SCL(
  input [1:0]   cnt_tick,  
  output  reg   scl_out
);

  always @(*) begin
    if(cnt_tick == 0 || cnt_tick == 3)
      scl_out = 0;
    else
      SH_ST = 1;
  end

endmodule