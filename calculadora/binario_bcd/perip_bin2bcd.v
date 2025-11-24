module peripheral_bin2bcd (clk , reset , d_in , cs , addr , rd , wr, d_out );   
    input clk;
    input reset;
    input [15:0] d_in;
    input cs;
    input [4:0]  addr; // 4 LSB from j1_io_addr
    input rd;
    input wr;
    output reg [31:0] d_out;


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
                3'b001: reg_bin_in <= d_in[15:0]; 
                3'b010: reg_init   <= d_in[0];  
                default: begin
                    reg_init <= 0; 
                end
            endcase
        end else begin
            reg_init <= 0; 
        end
    end

    always @(*) begin
        d_out = 32'd0; 
        if (cs && !wr) begin 
            case (addr[4:2])
                3'b100: d_out = {12'b0, wire_bcd_out}; 
                
                3'b101: d_out = {31'b0, wire_done};    
                
                default: d_out = 32'd0;
            endcase
        end
    end

endmodule
