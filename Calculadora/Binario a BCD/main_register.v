// --- CAJA 4: REGISTRO PRINCIPAL (Memoria) ---
// Este registro es especial: Puede cargar inicio, desplazar, o actualizarse con la corrección
module main_register (
    input wire clk, reset,
    input wire [15:0] bin_in,      // Entrada binaria original
    input wire [19:0] bcd_corrected, // Entrada que viene de los correctores
    input wire load_init,          // Señal para cargar binario
    input wire shift,              // Señal para desplazar
    input wire load_corr,          // Señal para guardar corrección
    output wire [35:0] data_out    // Salida de todo el registro (BCD + Bin)
);
    reg [35:0] reg_val;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_val <= 0;
        end else if (load_init) begin
            // Limpia la parte alta (BCD) y carga el binario en la baja
            reg_val <= {20'd0, bin_in}; 
        end else if (load_corr) begin
            // Solo actualiza la parte BCD con lo que sale de los sumadores
            // Mantiene la parte binaria (bits 0-15) igual
            reg_val[35:16] <= bcd_corrected; 
        end else if (shift) begin
            // Desplazamiento a la izquierda de todo el registro
            reg_val <= {reg_val[34:0], 1'b0};
        end
    end

    assign data_out = reg_val;
endmodule