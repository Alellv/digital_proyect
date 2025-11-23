// --- CAJA 2: CORRECTOR BCD (Combinacional) ---
// Esta caja mira 4 bits. Si son > 4, saca (entrada + 3). Si no, saca (entrada).
module bcd_block (
    input wire [3:0] in_val,
    output wire [3:0] out_val
);
    assign out_val = (in_val > 4) ? (in_val + 4'd3) : in_val;
endmodule



