module control_fsm (
    input wire clk,
    input wire reset,
    input wire init,
    input wire z,          // Señal Z (Zero) del contador
    output reg sh,         // Shift enable
    output reg ld,         // Load initial data
    output reg add,        // Enable BCD correction addition
    // sel y ld_msb no son estrictamente necesarios para el algoritmo estándar 
    // pero los incluyo para seguir tu diagrama de estados.
    output reg sel,        
    output reg ld_msb,
    output reg done
);

    // --- Codificación de Estados (One-Hot para robustez) ---
    localparam START     = 6'b000001;
    localparam SHIFT_DEC = 6'b000010;
    localparam CHECK     = 6'b000100;
    localparam LOAD_A2   = 6'b001000;
    localparam ADD       = 6'b010000;
    localparam END1      = 6'b100000;

    reg [5:0] current_state, next_state;

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
                if (init) next_state = SHIFT_DEC;
                else      next_state = START;
            
            SHIFT_DEC: 
                if (z)    next_state = END1; // Si contador=0, terminó
                else      next_state = CHECK; // Si no, a corregir
            
            CHECK:        next_state = LOAD_A2;
            LOAD_A2:      next_state = ADD;
            ADD:          next_state = SHIFT_DEC; // Vuelve a desplazar
            
            END1:         next_state = END1; // Estado final, espera reset
            
            default:      next_state = START;
        endcase
    end

    // --- Lógica de Salidas (Basada en las burbujas del diagrama) ---
    always @(*) begin
        // Valores por defecto (importante para evitar latches)
        sh = 0; ld = 0; add = 0; sel = 0; ld_msb = 0; done = 0;

        case (current_state)
            START: begin
                ld = 1;      // "ld = 1" en el diagrama
            end

            SHIFT_DEC: begin
                sh = 1;      // "sh = 1", se usa para desplazar y decrementar contador
                sel = 1;
                ld_msb = 1;
            end

            CHECK: begin
                sel = 1;     // "sel = 1"
                ld_msb = 1;  // "ld_msb = 1"
            end

            LOAD_A2: begin
                add = 1;     // "add = 1", momento de cargar la corrección BCD
            end
            
            ADD: begin
                 // Estado de transición, salidas por defecto en 0
            end

            END1: begin
                done = 1;    // "done = 1"
            end
        endcase
    end

endmodule