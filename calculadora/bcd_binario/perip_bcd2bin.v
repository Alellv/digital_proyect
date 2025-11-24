module peripheral_bcd2bin(clk , reset , d_in , cs , addr , rd , wr, d_out );
    input clk;
    input reset;
    input [15:0] d_in;
    input cs;
    input [4:0]  addr; // 4 LSB from j1_io_addr
    input rd;
    input wr;
    output reg [31:0] d_out;


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
                3'b001: reg_bcd_in <= d_in[19:0]; 
                
                3'b010: reg_start  <= d_in[0];    
                
                default: begin
                    reg_start <= 0; 
                end
            endcase
        end else begin
            reg_start <= 0; 
        end
    end

    always @(*) begin
        d_out = 32'd0;
        if (cs && !wr) begin 
            case (addr[4:2])
                3'b100: d_out = {16'b0, wire_bin_out}; 
                
                3'b101: d_out = {31'b0, wire_done};    
                
                default: d_out = 32'd0;
            endcase
        end
    end

endmodule
