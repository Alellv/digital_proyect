module control_fsm_b2b (
    input wire clk,
    input wire reset,
    input wire start,
    input wire z,          // Señal Z (Zero) del contador
    output reg shift,      // Shift enable (Derecha)
    output reg load_init,  // Cargar datos iniciales
    output reg load_sub,   // Cargar la resta (-3)
    output reg done        // Señal de finalización
);

    // --- Codificación de Estados (One-Hot) ---
    // Usamos 5 bits porque son 5 estados
    localparam START     = 5'b00001;
    localparam CHECK     = 5'b00010; // Estado para verificar si hay que restar
    localparam SUB       = 5'b00100; // Estado para aplicar la resta (-3)
    localparam SHIFT_DEC = 5'b01000; // Estado para desplazar y decrementar
    localparam END1      = 5'b10000; // Estado final

    reg [4:0] current_state, next_state;

    // --- Lógica Secuencial (Memoria de Estado) ---
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= START;
        else
            current_state <= next_state;
    end

    // --- Lógica Combinacional del Siguiente Estado ---
    always @(*) begin
        case (current_state)
            START: 
                if (start) next_state = CHECK;
                else       next_state = START;
            
            CHECK:        next_state = SUB; // Siempre vamos a intentar restar/corregir
            
            SUB:          next_state = SHIFT_DEC; // Después de corregir, desplazamos
            
            SHIFT_DEC: 
                if (z)    next_state = END1;  // Si contador=0, terminó
                else      next_state = CHECK; // Si no, vuelve a chequear
            
            END1:         next_state = END1;  // Se queda ahí hasta reset
            
            default:      next_state = START;
        endcase
    end

    // --- Lógica de Salidas (Separada y limpia) ---
    always @(*) begin
        // Valores por defecto (importante para evitar latches)
        shift = 0; load_init = 0; load_sub = 0; done = 0;

        case (current_state)
            START: begin
                // Si start está activo, cargamos (similar a tu diagrama anterior)
                if (start) load_init = 1;
            end

            CHECK: begin
                // En este estado solo preparamos, las señales siguen en 0
            end

            SUB: begin
                load_sub = 1; // "add=1" en tu otro código, aquí cargamos la resta
            end

            SHIFT_DEC: begin
                shift = 1;    // "sh=1", desplazamos y bajamos contador
            end

            END1: begin
                done = 1;     // "done=1"
            end
        endcase
    end

endmodule