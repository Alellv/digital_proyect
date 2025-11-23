// --- CAJA 3: CONTADOR DESCENDENTE ---
module down_counter (
    input wire clk, reset, load, enable, // enable se conecta a 'shift'
    output wire z
);
    reg [4:0] count;
    always @(posedge clk or posedge reset) begin
        if (reset) count <= 0;
        else if (load) count <= 16; // 16 bits a procesar
        else if (enable) count <= count - 1;
    end
    assign z = (count == 0);
endmodule