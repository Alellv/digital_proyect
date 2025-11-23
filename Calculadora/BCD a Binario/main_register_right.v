module main_register_right (
    input wire clk, reset,
    input wire [19:0] bcd_in,      // Entrada BCD
    input wire [19:0] bcd_corrected, // Entrada desde los restadores
    input wire load_init,          // Cargar inicial
    input wire shift,              // Desplazar Derecha
    input wire load_sub,           // Cargar Resta
    output wire [35:0] data_out    // Salida completa
);
    reg [35:0] reg_val;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_val <= 0;
        end else if (load_init) begin
            // Cargar BCD en la parte ALTA, ceros en la BAJA
            reg_val <= {bcd_in, 16'd0}; 
        end else if (load_sub) begin
            // Actualizar solo la parte ALTA (BCD) con la resta
            reg_val[35:16] <= bcd_corrected;
        end else if (shift) begin
            // Desplazamiento a la DERECHA (entra 0 por la izquierda)
            reg_val <= {1'b0, reg_val[35:1]};
        end
    end

    assign data_out = reg_val;
endmodule