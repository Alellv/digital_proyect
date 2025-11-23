module main_register (
    input wire clk, reset,
    input wire [15:0] bin_in,     
    input wire [19:0] bcd_corrected, 
    input wire load_init,         
    input wire shift,              
    input wire load_corr,         
    output wire [35:0] data_out    
);
    reg [35:0] reg_val;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_val <= 0;
        end else if (load_init) begin
            reg_val <= {20'd0, bin_in}; 
        end else if (load_corr) begin
            reg_val[35:16] <= bcd_corrected; 
        end else if (shift) begin
            reg_val <= {reg_val[34:0], 1'b0};
        end
    end

    assign data_out = reg_val;
endmodule
