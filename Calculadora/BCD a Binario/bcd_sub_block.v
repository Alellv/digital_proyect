module bcd_sub_block (
    input wire [3:0] in_val,
    output wire [3:0] out_val
);
    assign out_val = (in_val >= 8) ? (in_val - 4'd3) : in_val;
endmodule
