module perip_bin2bcd (
    input wire clk,
    input wire reset,
    
    // BUS DEL SISTEMA (Lo que viene del procesador/SOC)
    input wire [4:0] addr,  // Dirección local (offset)
    input wire [31:0] din,  // Datos que manda el CPU (Write Data)
    input wire cs,          // Chip Select (¿Me están hablando a mí?)
    input wire wr,          // Write Enable (1=Escribir, 0=Leer)
    
    // SALIDA AL SISTEMA
    output reg [31:0] dout  // Datos que devolvemos al CPU (Read Data)
);

    // 1. REGISTROS INTERNOS (Para guardar lo que manda el CPU)
    reg [15:0] reg_bin_in; // Guarda el número binario
    reg reg_init;          // Guarda la señal de inicio

    // 2. CABLES DE SALIDA DE TU MÓDULO
    wire [19:0] wire_bcd_out;
    wire wire_done;

    // ---------------------------------------------------------
    // 3. INSTANCIA DE TU MÓDULO (El núcleo que ya hiciste)
    // ---------------------------------------------------------
    bin2bcd_top u_core (
        .clk(clk),
        .reset(reset),
        .init(reg_init),       // Conectado al registro controlado por CPU
        .bin_in(reg_bin_in),   // Conectado al registro controlado por CPU
        .bcd_out(wire_bcd_out),// Salida hacia el multiplexor de lectura
        .done(wire_done)       // Salida hacia el multiplexor de lectura
    );

    // ---------------------------------------------------------
    // 4. LÓGICA DE ESCRITURA (CPU -> Periférico)
    // ---------------------------------------------------------
    // Miramos addr, cs y wr para saber dónde guardar el dato
    always @(posedge clk) begin
        if (reset) begin
            reg_bin_in <= 0;
            reg_init <= 0;
        end else if (cs && wr) begin
            // El CPU quiere escribir algo... ¿dónde?
            case (addr[4:2]) // Miramos los bits relevantes del offset
                3'b001: reg_bin_in <= din[15:0]; // Offset 0x04 -> Guardar Binario
                3'b010: reg_init   <= din[0];    // Offset 0x08 -> Activar Init
                default: begin
                    // Si escribe en otro lado, apagamos init (autoclear opcional)
                    reg_init <= 0; 
                end
            endcase
        end else begin
            // Opcional: Hacer que init sea solo un pulso de 1 ciclo
            // Si tu máquina de estados necesita que init baje, descomenta esto:
            reg_init <= 0; 
        end
    end

    // ---------------------------------------------------------
    // 5. LÓGICA DE LECTURA (Periférico -> CPU)
    // ---------------------------------------------------------
    // Un Mux gigante para decidir qué dato devolver al CPU
    always @(*) begin
        dout = 32'd0; // Por defecto 0
        if (cs && !wr) begin // Si está seleccionado y NO es escritura (es lectura)
            case (addr[4:2])
                // Offset 0x10 -> Leer Resultado (4 en binario es 100)
                3'b100: dout = {12'b0, wire_bcd_out}; 
                
                // Offset 0x14 -> Leer Done (5 en binario es 101)
                3'b101: dout = {31'b0, wire_done};    
                
                default: dout = 32'd0;
            endcase
        end
    end

endmodule