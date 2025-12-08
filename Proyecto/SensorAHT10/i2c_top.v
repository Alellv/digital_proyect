module i2c_top(clk , rst , init, SCL, I1, I2, I3, SDA );

    input           rst;
    input           clk;
    input           init;

    output          SCL;
    output          I1;
    output          I2;
    output          I3;

    inout           SDA;


// Cables control

//      Entradas

    wire            w_SH_ST;
    wire            w_ZBC;
    wire            w_ZBY;
    wire            w_ZT1;
    wire            w_ZT2;
    wire            w_ZACK;
    wire            w_ZWT;

    wire [1:0]      w_cnt_st;

//      Salidas 

    wire            w_SCL_EN;
    
    wire            w_INC_BC;
    wire            w_RST_BC;

    wire            w_DEC_BY;
    wire            w_RST_BYR;
    wire            w_RST_BYW;

    wire            w_DEC_WT;
    wire            w_RST_WT;

    wire            w_INC_ST;
    wire            w_DEC_ST;

    wire            w_LD_ADWR;
    wire            w_LD_ADRD;
    wire            w_LD_CONF;
    wire            w_LD_MD;
    wire            w_LD_START;
    wire            w_LD_STOP;

    wire            w_SH_WR;
    wire            w_SH_RD;
    wire            w_SDA_OE;


//  Cables configuracion reloj

    wire            w_i2c_tick;
    wire [1:0]      w_cnt_tick;
    wire            w_scl_out;

// Cables datos

    wire [19:0]       w_comp_t; 
    wire            w_ack;

// Cables contadores

    wire [2:0]      w_cnt_by;

//  Instanciacion de modulos

//      Modulo de control

ctrl_i2cs ctrl_i2cs (.clk(clk), .rst(rst), .init(1'b1), 
                    .SH_ST(w_SH_ST),
                    .ZBC(w_ZBC), .ZBY(w_ZBY), .ZT1(w_ZT1), .ZT2(w_ZT2), .ZACK(w_ZACK), .ZWT(w_ZWT),
                    .cnt_st(w_cnt_st), 
                    .SCL_EN(w_SCL_EN), 
                    .INC_BC(w_INC_BC), .RST_BC(w_RST_BC), 
                    .DEC_BY(w_DEC_BY), .RST_BYR(w_RST_BYR), .RST_BYW(w_RST_BYW),
                    .DEC_WT(w_DEC_WT), .RST_WT(w_RST_WT),
                    .INC_ST(w_INC_ST), .DEC_ST(w_DEC_ST),
                    .LD_ADWR(w_LD_ADWR), .LD_ADRD(w_LD_ADRD), .LD_CONF(w_LD_CONF), .LD_MD(w_LD_MD), 
                    .LD_START(w_LD_START), .LD_STOP(w_LD_STOP),
                    .SH_WR(w_SH_WR), .SH_RD(w_SH_RD), .SDA_OE(w_SDA_OE),
                    .I1(I1), .I2(I2), .I3(I3) ) ;

//      Modulo de manejo de datos

SDA_mng SDA_mng (.clk(clk), .rst(rst),
                    .cnt_by(w_cnt_by),
                    .LD_ADWR(w_LD_ADWR), .LD_ADRD(w_LD_ADRD), .LD_CONF(w_LD_CONF), .LD_MD(w_LD_MD), 
                    .LD_START(w_LD_START), .LD_STOP(w_LD_STOP),
                    .SH_WR(w_SH_WR), .SH_RD(w_SH_RD), .SDA_OE(w_SDA_OE),
                    .temp(w_comp_t), .ACK(w_ack),
                    .SDA(SDA)) ;

//      Modulos de conteo

//                  Conteo de bits
count_bit count_bit (.clk(clk), .rst(rst), .INC_BC(w_INC_BC), .RST_BC(w_RST_BC), .ZBC(w_ZBC));

//                  Conteo de byte enviado
count_by count_by (.clk(clk), .rst(rst), .DEC_BY(w_DEC_BY), .RST_BYR(w_RST_BYR), .RST_BYW(w_RST_BYW), .cnt_by(w_cnt_by), .ZBY(w_ZBY));

//                  Conteo de espera
count_wait count_wait (.clk(clk), .rst(rst), .DEC_WT(w_DEC_WT), .RST_WT(w_RST_WT), .ZWT(w_ZWT));

//                  Conteo de estado
count_st count_st (.clk(clk), .rst(rst), .INC_ST(w_INC_ST), .DEC_ST(w_DEC_ST), .cnt_st(w_cnt_st));

//                  Conteo de tiempo
count_time count_time (.clk(clk), .rst(rst), .i2c_tick(w_i2c_tick), .cnt_tick(w_cnt_tick));

//      Modulos de comparación

//                  Comparador tick
comp_tick comp_tick (.i2c_tick(w_i2c_tick), .cnt_tick(w_cnt_tick), .SH_ST(w_SH_ST));

//                  Comparador SCL interno
comp_SCL comp_SCL (.cnt_tick(w_cnt_tick), .scl_out(w_scl_out));

//                  Comparador SCL externo
compout_SCL compout_SCL (.scl_out(w_scl_out), .SCL_EN(w_SCL_EN), .SCL(SCL));

//                  Comparador T1
comp_T1 comp_T1 (.temp(w_comp_t), .ZT1(w_ZT1));

//                  Comparador T2
comp_T2 comp_T2 (.temp(w_comp_t), .ZT2(w_ZT2));

//                  Comparador ACK
comp_ACK comp_ACK (.ACK(w_ack), .ZACK(w_ZACK));


endmodule