module perip_bcd2bin (
    input wire clk,
    input wire reset,
    
    input wire [4:0] addr,  
    input wire [31:0] din, 
    input wire cs,          
    input wire wr,          
    
    output reg [31:0] dout  
);


    reg [19:0] reg_bcd_in; 
    reg reg_start;        

    // 2. CABLES DE SALIDA DEL NÚCLEO
    wire [15:0] wire_bin_out;
    wire wire_done;

    bcd2bin_top u_core (
        .clk(clk),
        .reset(reset),
        .start(reg_start),     
        .bcd_in(reg_bcd_in),   
        .bin_out(wire_bin_out), 
        .done(wire_done)        
    );

    always @(posedge clk) begin
        if (reset) begin
            reg_bcd_in <= 0;
            reg_start <= 0;
        end else if (cs && wr) begin
            case (addr[4:2]) 
                3'b001: reg_bcd_in <= din[19:0]; 
                
                3'b010: reg_start  <= din[0];    
                
                default: begin
                    reg_start <= 0; 
                end
            endcase
        end else begin
            reg_start <= 0; 
        end
    end

    always @(*) begin
        dout = 32'd0;
        if (cs && !wr) begin 
            case (addr[4:2])
                3'b100: dout = {16'b0, wire_bin_out}; 
                
                3'b101: dout = {31'b0, wire_done};    
                
                default: dout = 32'd0;
            endcase
        end
    end

endmodule
