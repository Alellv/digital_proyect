`timescale 1ns / 1ps

`define SIMULATION
module peripheral_multi_TB;
   reg clk;
   reg reset;
   reg [15:0] d_in;
   reg cs;
   reg [4:0] addr;
   reg rd;
   reg wr;
   wire [31:0] d_out;

   peripheral_multi uut (
      .clk(clk), 
      .reset(reset), 
      .d_in(d_in), 
      .cs(cs), 
      .addr(addr), 
      .rd(rd), 
      .wr(wr), 
      .d_out(d_out) 
   );

   parameter PERIOD = 20;
   
   initial begin  
      clk = 0; 
      reset = 1; 
      d_in = 0; 
      addr = 5'h00; 
      cs = 0; 
      rd = 0; 
      wr = 0;
      
      #(PERIOD*2);
      reset = 0;
   end
   
   always #(PERIOD/2) clk <= ~clk;

   initial begin 

      #(PERIOD*4);
      
      // Write A operand
      cs = 1; wr = 1;
      d_in = 16'h00F7;
      addr = 5'h04;
      #(PERIOD);
      
      // Write B operand  
      d_in = 16'h007F;
      addr = 5'h08;
      #(PERIOD);
      

      d_in = 16'h0001;
      addr = 5'h0C;
      #(PERIOD);
      
      cs = 0; wr = 0;
      
      // done
      wait(uut.done == 1);
      #(PERIOD*2);
      
      cs = 1; rd = 1;
      addr = 5'h10;
      #(PERIOD);
      
      #(PERIOD*10);
      $finish;
   end

   initial begin
      $dumpfile("perip_multi_TB.vcd");
      $dumpvars(0, peripheral_multi_TB);
   end

endmodule