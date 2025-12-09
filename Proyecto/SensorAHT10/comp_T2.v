module comp_T2(
  input [19:0]   temp,
  output  reg   ZT2
);

  always @(*) begin
    if(temp < 393216)   //Para la temperatura se requiere una conversión del valor del valor de los bits, 
      ZT2 = 1;              //para ahorrar este proceso, se comparan los bits con la temperatura como si no fuera
    else                    //convertida
      ZT2 = 0;
  end

endmodule