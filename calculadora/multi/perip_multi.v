module peripheral_multi(clk , reset , d_in , cs , addr , rd , wr, d_out );
  
  input clk;
  input reset;
  input [15:0] d_in;
  input cs;
  input [4:0]  addr;
  input rd;
  input wr;
  output reg [31:0] d_out;

  reg [4:0]  s;
  reg [15:0] A;
  reg [15:0] B;
  reg init;
  wire [31:0] result;
  wire done;

  // Address decoder
  always @(*) begin
    if (cs) begin
      case (addr)
        5'h04: s = 5'b00001; // A 
        5'h08: s = 5'b00010; // B
        5'h0C: s = 5'b00100; // init
        5'h10: s = 5'b01000; // result
        5'h14: s = 5'b10000; // done
        default: s = 5'b00000;
      endcase
    end else 
      s = 5'b00000;
  end

  // Escritura de registros
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      init <= 1'b0;
      A    <= 16'b0;
      B    <= 16'b0;
    end else begin
      if (cs && wr) begin
        A    <= s[0] ? d_in : A;
        B    <= s[1] ? d_in : B;
        init <= s[2] ? d_in[0] : init;
      end
    end
  end

  // Multiplexor de salida
  always @(*) begin
    if (reset)
      d_out = 32'b0;
    else if (cs && rd) begin
      case (s[4:0])
        5'b01000: d_out = result;          
        5'b10000: d_out = {31'b0, done};
        default:  d_out = 32'b0;
      endcase
    end else
      d_out = 32'b0;
  end

  multi multi0 (
    .rst(reset),
    .clk(clk),
    .start(init),
    .md(A),
    .mr(B),
    .pp(result),
    .done(done)
  );

endmodule