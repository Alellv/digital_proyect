module main_register_right (
    input wire clk, reset,
    input wire [19:0] bcd_in,      
    input wire [19:0] bcd_corrected, 
    input wire load_init,        
    input wire shift,         
    input wire load_sub,          
    output wire [35:0] data_out    
);
    reg [35:0] reg_val;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_val <= 0;
        end else if (load_init) begin
            reg_val <= {bcd_in, 16'd0}; 
        end else if (load_sub) begin
            reg_val[35:16] <= bcd_corrected;
        end else if (shift) begin
            reg_val <= {1'b0, reg_val[35:1]};
        end
    end

    assign data_out = reg_val;
endmodule
