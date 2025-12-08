module comp_T1(
  input [19:0]   comp_T1,
  output  reg   ZT1
);

  always @(*) begin
    if(w_comp_t < 445645)   //Para la temperatura se requiere una conversión del valor del valor de los bits, 
      ZT1 = 1;              //para ahorrar este proceso, se comparan los bits con la temperatura como si no fuera
    else                    //convertida
      ZT1 = 0;
  end

endmodule