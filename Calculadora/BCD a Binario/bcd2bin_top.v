module bcd2bin_top (
    input wire clk,
    input wire reset,
    input wire start,          // Botón de inicio
    input wire [19:0] bcd_in,  // Entrada BCD (5 dígitos)
    output wire [15:0] bin_out,// Salida Binaria
    output wire done
);

    // CABLES INTERNOS
    wire w_load_init, w_shift, w_load_sub, w_z;
    wire [35:0] bus_registro;
    wire [19:0] bus_correccion;

    // 1. INSTANCIA DEL CONTROL
    control_fsm_b2b cerebro (
        .clk(clk), .reset(reset), .start(start), .z(w_z),
        .load_init(w_load_init),
        .shift(w_shift),
        .load_sub(w_load_sub),
        .done(done)
    );

    // 2. INSTANCIA DEL REGISTRO (Derecha)
    main_register_right registro (
        .clk(clk), .reset(reset),
        .bcd_in(bcd_in),
        .bcd_corrected(bus_correccion),
        .load_init(w_load_init),
        .shift(w_shift),
        .load_sub(w_load_sub),
        .data_out(bus_registro)
    );

    // 3. INSTANCIA DEL CONTADOR
    down_counter contador (
        .clk(clk), .reset(reset),
        .load(w_load_init),
        .enable(w_shift),
        .z(w_z)
    );

    // 4. INSTANCIAS DE LOS RESTADORES (x5)
    // Conectados a la parte alta del registro (bits 35 a 16)
    
    // Unidades
    bcd_sub_block sub_uni (.in_val(bus_registro[19:16]), .out_val(bus_correccion[3:0]));
    // Decenas
    bcd_sub_block sub_dec (.in_val(bus_registro[23:20]), .out_val(bus_correccion[7:4]));
    // Centenas
    bcd_sub_block sub_cen (.in_val(bus_registro[27:24]), .out_val(bus_correccion[11:8]));
    // Miles
    bcd_sub_block sub_mil (.in_val(bus_registro[31:28]), .out_val(bus_correccion[15:12]));
    // Diez Miles
    bcd_sub_block sub_dmil (.in_val(bus_registro[35:32]), .out_val(bus_correccion[19:16]));

    // SALIDA FINAL (Los 16 bits bajos del registro)
    assign bin_out = bus_registro[15:0];

endmodule