module bin2bcd_top (
    input wire clk,
    input wire reset,
    input wire init,
    input wire [15:0] bin_in,
    output wire [19:0] bcd_out,
    output wire done
);

    // --- CABLES INTERNOS ---
    wire w_load_init;
    wire w_shift;
    wire w_load_corr;
    wire w_z;
    wire [35:0] bus_registro;
    wire [19:0] bus_correccion;

    // ==========================================
    // 1. INSTANCIA DEL CONTROL (CEREBRO)
    // ==========================================
    control_fsm cerebro (
        .clk(clk), 
        .reset(reset), 
        .init(init), 
        .z(w_z), 
        
        // --- CONEXIONES CRÍTICAS (Izquierda: Nombre en modulo, Derecha: Cable) ---
        // En tu archivo control_fms.v, las salidas se llaman: ld, sh, add.
        .ld(w_load_init),    // Conectamos puerto 'ld' al cable w_load_init
        .sh(w_shift),        // Conectamos puerto 'sh' al cable w_shift
        .add(w_load_corr),   // Conectamos puerto 'add' al cable w_load_corr
        
        // Los puertos .sel y .ld_msb los dejamos sin conectar (Verilog lo permite)
        
        .done(done)          // ¡IMPORTANTE: Esta ultima linea NO lleva coma al final!
    );

    // ==========================================
    // 2. INSTANCIA DEL REGISTRO
    // ==========================================
    main_register registro_grande (
        .clk(clk),
        .reset(reset),
        .bin_in(bin_in),
        .bcd_corrected(bus_correccion),
        .load_init(w_load_init),
        .shift(w_shift),
        .load_corr(w_load_corr),
        .data_out(bus_registro)
    );

    // ==========================================
    // 3. INSTANCIA DEL CONTADOR
    // ==========================================
    down_counter contador (
        .clk(clk),
        .reset(reset),
        .load(w_load_init),
        .enable(w_shift), 
        .z(w_z)
    );

    // ==========================================
    // 4. INSTANCIAS DE LOS CORRECTORES (x5)
    // ==========================================
    
    // Unidades
    bcd_block box_unidades (
        .in_val(bus_registro[19:16]), 
        .out_val(bus_correccion[3:0])
    );

    // Decenas
    bcd_block box_decenas (
        .in_val(bus_registro[23:20]), 
        .out_val(bus_correccion[7:4])
    );

    // Centenas
    bcd_block box_centenas (
        .in_val(bus_registro[27:24]), 
        .out_val(bus_correccion[11:8])
    );

    // Miles
    bcd_block box_miles (
        .in_val(bus_registro[31:28]), 
        .out_val(bus_correccion[15:12])
    );

    // Diez Miles
    bcd_block box_dmiles (
        .in_val(bus_registro[35:32]), 
        .out_val(bus_correccion[19:16])
    );

    // SALIDA FINAL
    assign bcd_out = bus_registro[35:16];

endmodule