module memory#(
    parameter size = 2047,
    parameter width = 11
)(
  input                 clk,
  input  [width:0]      address,
  input                 I1,
  input                 I2,
  input                 I3,
  input                 im,
  output reg [23:0]     rdata       
);


reg [11:0] MEM0 [0:size];
reg [11:0] MEM1 [0:size];
reg [11:0] MEM2 [0:size];
reg [11:0] MEM3 [0:size];
reg [11:0] MEM4 [0:size];
reg [11:0] MEM5 [0:size];

initial begin
    $readmemh("./image0.hex",MEM0);
    $readmemh("./image1.hex",MEM1);
    $readmemh("./image2.hex",MEM2);
    $readmemh("./image3.hex",MEM3);
    $readmemh("./pokebola64_top.hex",MEM4);
    $readmemh("./pokebola64_bottom.hex",MEM5);
end

  always @(negedge clk) begin

    
    if(I1) begin
        rdata[23:12] <= MEM0[address];     //{RGB0,RGB1}
        rdata[11:0] <= MEM1[address];     //{RGB0,RGB1}
    end 
  
    if(I2) begin
        rdata[23:12] <= MEM2[address];     //{RGB0,RGB1}
        rdata[11:0] <= MEM3[address];     //{RGB0,RGB1}
    end

    if(I3) begin
        rdata[23:12] <= MEM4[address];     //{RGB0,RGB1}
        rdata[11:0] <= MEM5[address];     //{RGB0,RGB1}
    end

    
  end

endmodule
