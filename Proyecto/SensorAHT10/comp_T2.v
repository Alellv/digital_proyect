module comp_T2(
  input [19:0]   comp_T2,
  output  reg   ZT2
);

  always @(*) begin
    if(w_comp_t < 393216)   //Para la temperatura se requiere una conversión del valor del valor de los bits, 
      ZT2 = 1;              //para ahorrar este proceso, se comparan los bits con la temperatura como si no fuera
    else                    //convertida
      ZT2 = 0;
  end

endmodule