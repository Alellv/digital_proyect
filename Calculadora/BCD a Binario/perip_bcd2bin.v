module perip_bcd2bin (
    input wire clk,
    input wire reset,
    
    // BUS DEL SISTEMA (Señales estándar)
    input wire [4:0] addr,  // Dirección (Offset)
    input wire [31:0] din,  // Dato que entra (desde el CPU)
    input wire cs,          // Chip Select (Enable)
    input wire wr,          // Write Enable (1=Escribir, 0=Leer)
    
    // SALIDA AL SISTEMA
    output reg [31:0] dout  // Dato que sale (hacia el CPU)
);

    // 1. REGISTROS INTERNOS (Memoria del periférico)
    reg [19:0] reg_bcd_in; // Guardar el BCD de entrada (20 bits)
    reg reg_start;         // Guardar la señal de inicio

    // 2. CABLES DE SALIDA DEL NÚCLEO
    wire [15:0] wire_bin_out;
    wire wire_done;

    // ---------------------------------------------------------
    // 3. INSTANCIA DEL NÚCLEO (Tu diseño BCD2BIN)
    // ---------------------------------------------------------
    bcd2bin_top u_core (
        .clk(clk),
        .reset(reset),
        .start(reg_start),      // Conectado al registro controlado por CPU
        .bcd_in(reg_bcd_in),    // Conectado al registro controlado por CPU
        .bin_out(wire_bin_out), // Salida hacia el bus de lectura
        .done(wire_done)        // Salida hacia el bus de lectura
    );

    // ---------------------------------------------------------
    // 4. LÓGICA DE ESCRITURA (CPU -> Periférico)
    // ---------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            reg_bcd_in <= 0;
            reg_start <= 0;
        end else if (cs && wr) begin
            // El CPU quiere escribir. Miramos la dirección:
            case (addr[4:2]) 
                // Offset 0x04 -> Guardar dato BCD
                3'b001: reg_bcd_in <= din[19:0]; 
                
                // Offset 0x08 -> Activar Start
                3'b010: reg_start  <= din[0];    
                
                default: begin
                    // Autoclear del start si escribe en otro lado (opcional)
                    reg_start <= 0; 
                end
            endcase
        end else begin
            // Opcional: Bajar el start automáticamente después de un ciclo
            // para que funcione como un pulsador.
            reg_start <= 0; 
        end
    end

    // ---------------------------------------------------------
    // 5. LÓGICA DE LECTURA (Periférico -> CPU)
    // ---------------------------------------------------------
    always @(*) begin
        dout = 32'd0; // Limpiar bus
        if (cs && !wr) begin // Si es lectura
            case (addr[4:2])
                // Offset 0x10 -> Leer Resultado Binario
                3'b100: dout = {16'b0, wire_bin_out}; 
                
                // Offset 0x14 -> Leer Estado Done
                3'b101: dout = {31'b0, wire_done};    
                
                default: dout = 32'd0;
            endcase
        end
    end

endmodule