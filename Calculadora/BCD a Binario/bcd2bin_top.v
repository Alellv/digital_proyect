module bcd2bin_top (
    input wire clk,
    input wire reset,
    input wire start,          
    input wire [19:0] bcd_in, 
    output wire [15:0] bin_out,
    output wire done
);

    wire w_load_init, w_shift, w_load_sub, w_z;
    wire [35:0] bus_registro;
    wire [19:0] bus_correccion;

    control_fsm_b2b cerebro (
        .clk(clk), .reset(reset), .start(start), .z(w_z),
        .load_init(w_load_init),
        .shift(w_shift),
        .load_sub(w_load_sub),
        .done(done)
    );

    main_register_right registro (
        .clk(clk), .reset(reset),
        .bcd_in(bcd_in),
        .bcd_corrected(bus_correccion),
        .load_init(w_load_init),
        .shift(w_shift),
        .load_sub(w_load_sub),
        .data_out(bus_registro)
    );

    down_counter contador (
        .clk(clk), .reset(reset),
        .load(w_load_init),
        .enable(w_shift),
        .z(w_z)
    );

    bcd_sub_block sub_uni (.in_val(bus_registro[19:16]), .out_val(bus_correccion[3:0]));
    bcd_sub_block sub_dec (.in_val(bus_registro[23:20]), .out_val(bus_correccion[7:4]));
    bcd_sub_block sub_cen (.in_val(bus_registro[27:24]), .out_val(bus_correccion[11:8]));
    bcd_sub_block sub_mil (.in_val(bus_registro[31:28]), .out_val(bus_correccion[15:12]));
    bcd_sub_block sub_dmil (.in_val(bus_registro[35:32]), .out_val(bus_correccion[19:16]));

    assign bin_out = bus_registro[15:0];

endmodule
