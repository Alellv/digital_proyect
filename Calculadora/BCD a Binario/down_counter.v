module down_counter (
    input wire clk, reset, load, enable,
    output wire z
);
    reg [4:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) count <= 0;
        else if (load) count <= 16; // 16 iteraciones para 16 bits de salida
        else if (enable) count <= count - 1;
    end

    assign z = (count == 0);
endmodule