module comp_ACK(
  input         ACK,
  output  reg   ZACK
);

  always @(*) begin
    if(ACK == 0)
      ZACK = 1;
    else
      ZACK = 0;
  end

endmodule