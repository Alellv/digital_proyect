module perip_bin2bcd (
    input wire clk,
    input wire reset,
    
    input wire [4:0] addr,  
    input wire [31:0] din,  
    input wire cs,        
    input wire wr,       

    output reg [31:0] dout  
);

    reg [15:0] reg_bin_in; 
    reg reg_init;         

    wire [19:0] wire_bcd_out;
    wire wire_done;

    bin2bcd_top u_core (
        .clk(clk),
        .reset(reset),
        .init(reg_init),      
        .bin_in(reg_bin_in),   
        .bcd_out(wire_bcd_out),
        .done(wire_done)      
    );

    always @(posedge clk) begin
        if (reset) begin
            reg_bin_in <= 0;
            reg_init <= 0;
        end else if (cs && wr) begin
            case (addr[4:2]) 
                3'b001: reg_bin_in <= din[15:0]; 
                3'b010: reg_init   <= din[0];  
                default: begin
                    reg_init <= 0; 
                end
            endcase
        end else begin
            reg_init <= 0; 
        end
    end

    always @(*) begin
        dout = 32'd0; 
        if (cs && !wr) begin 
            case (addr[4:2])
                3'b100: dout = {12'b0, wire_bcd_out}; 
                
                3'b101: dout = {31'b0, wire_done};    
                
                default: dout = 32'd0;
            endcase
        end
    end

endmodule
