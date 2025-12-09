module compout_SCL( 
  input         scl_out,
  input         SCL_EN,
  output reg    SCL
);

  always @(*) begin
    if(SCL_EN)
      SCL <= scl_out;
    else
      SCL <= 1;
  end

endmodule