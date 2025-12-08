module ctrl_i2cs(

    input   clk,
    input   init,
    input   rst,
    input   ZBC,
    input   ZBY,
    input   ZT1,
    input   ZT2,
    input   ZACK,
    input   ZWT,
    input   SH_ST,

    input [1:0]  cnt_st, 
    output  reg   SCL_EN, 

    output  reg   INC_BC, 
    output  reg   RST_BC, 
    output  reg   DEC_BY,
    output  reg   RST_BYR, 
    output  reg   RST_BYW, 
    output  reg   DEC_WT, 
    output  reg   RST_WT, 
    output  reg   INC_ST, 
    output  reg   DEC_ST,
    output  reg   LD_ADWR, 
    output  reg   LD_ADRD, 
    output  reg   LD_CONF, 
    output  reg   LD_MD, 
    output  reg   LD_START, 
    output  reg   LD_STOP,
    output  reg   SH_WR, 
    output  reg   SH_RD, 
    output  reg   SDA_OE, 
    output  reg   I1, 
    output  reg   I2, 
    output  reg   I3 
);

 parameter IDLE             = 5'b00001;
 parameter START_1          = 5'b00010;
 parameter START_2          = 5'b00011;
 parameter ADDRESS          = 5'b00100;
 parameter READ_ACK         = 5'b00101;
 parameter WRITE_DATA       = 5'b00110;
 parameter READ_ACK2        = 5'b00111;
 parameter READ_DATA        = 5'b01000;
 parameter WRITE_ACK        = 5'b01001;
 parameter WRITE_NACK       = 5'b01010;
 parameter STOP_1           = 5'b01011;
 parameter STOP_2           = 5'b01100;
 parameter STOP_3           = 5'b01101;
 parameter WAIT             = 5'b01110;
 parameter CHECK_T1         = 5'b01111;
 parameter CHECK_T2         = 5'b10000;
 parameter SET_I1           = 5'b10001;
 parameter SET_I2           = 5'b10010;
 parameter SET_I3           = 5'b10011;
 parameter CH_CONF          = 5'b10100;

 reg [4:0] state;
 reg [4:0] next_state;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            I1 = 0;
            I2 = 0;
            I3 = 0;
        end else begin
            if (SH_ST) 
                state <= next_state;
        end
    end


 always @(posedge clk) begin

    case(state)
      IDLE: begin
        if(init)
          next_state = START_1;
        else
          next_state = IDLE;
      end

      START_1: begin
        next_state = START_2;
      end

      START_2: begin
        next_state = ADDRESS;
      end

      ADDRESS: begin
        if(ZBC)
          next_state = READ_ACK;
        else 
          next_state = ADDRESS;
      end


      READ_ACK: begin
        if(ZACK) begin
            case (cnt_st)
                2'b01: next_state = WRITE_DATA; 
                2'b10: next_state = WRITE_DATA; 
                2'b11: next_state = READ_DATA; 
                default: next_state = WRITE_DATA; 
            endcase
        end
        else 
          next_state = IDLE;
      end

      WRITE_DATA: begin
        if(ZBC)
          next_state = READ_ACK2;
        else
          next_state = WRITE_DATA;
      end

      READ_ACK2: begin
        if(ZACK) begin
            if(ZBY)
                next_state = STOP_1;
            else
                next_state = WRITE_DATA;
        end
        else 
          next_state = IDLE;
      end

      READ_DATA: begin
        if(ZBC) begin
            if(ZBY)
            next_state = WRITE_NACK;
            else
            next_state = WRITE_ACK;
        end
        else
          next_state = READ_DATA;
      end

      WRITE_ACK: begin
        next_state = READ_DATA;
      end

      WRITE_NACK: begin
        next_state = STOP_1;
      end

      STOP_1: begin
        next_state = STOP_2;
      end

      STOP_2: begin
        next_state = STOP_3;
      end

      STOP_3: begin
        next_state = WAIT;
      end

      WAIT: begin
        if(ZWT) begin
            case (cnt_st)
                2'b01: next_state = IDLE; 
                2'b10: next_state = IDLE; 
                2'b11: next_state = CHECK_T1; 
                default: next_state = IDLE; 
            endcase
        end
        else 
          next_state = WAIT;
      end

      CHECK_T1: begin
        if(ZT1)
          next_state = CHECK_2;
        else
          next_state = SET_I1;
      end

      CHECK_T2: begin
        if(ZT2)
          next_state = SET_I3;
        else
          next_state = SET_I2;
      end

      SET_I1: begin
        next_state = CH_CONF;
      end

      SET_I2: begin
        next_state = CH_CONF;
      end

      SET_I3: begin
        next_state = CH_CONF;
      end

      CH_CONF: begin
        next_state = IDLE;
      end

      default: next_state = IDLE;
    endcase
end

always @(*) begin
    case(state)

      IDLE: begin
        SCL_EN = 0; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 1; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 1; 
        DEC_WT = 0; RST_WT= 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0; 
      end

      START_1: begin
        SCL_EN = 0; SDA_OE = 1; 
        INC_BC = 0; RST_BC = 1; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT= 1;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 1; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
      end

      START_2: begin
        SCL_EN = 1; SDA_OE = 1; 
        INC_BC = 0; RST_BC = 1; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT= 1;
        INC_ST = 0; DEC_ST = 0;
        LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        case (cnt_st)
                2'b01: LD_ADWR = 1; 
                2'b10: LD_ADWR = 1;
                2'b11: LD_ADRD = 1;
                default: LD_ADWR = 1; 
        endcase
        SH_WR = 0; SH_RD = 0; 
      end

      ADDRESS: begin
        SCL_EN = 1; SDA_OE = 1; 
        INC_BC = SH_ST; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT= 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = SH_ST; SH_RD = 0;
      end

      READ_ACK: begin
        SCL_EN = 1; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 1; 
        DEC_BY = 0;
        case (cnt_st)
                2'b01: RST_BYR = 1; 
                2'b10: RST_BYR = 1;
                2'b11: RST_BYW = 1;
                default: RST_BYR = 1; 
        endcase
        case (cnt_st)
                2'b01: LD_CONF = 1; 
                2'b10: LD_MD = 1;
                default: LD_CONF = 1;
        endcase
        DEC_WT = 0; RST_WT= 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0;
        LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0; 
      end

      WRITE_DATA: begin
        SCL_EN = 1; SDA_OE = 1; 
        INC_BC = SH_ST; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = SH_ST; SH_RD = 0;
      end

      READ_ACK2: begin
        SCL_EN = 1; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 1; 
        DEC_BY = SH_ST; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0;
        INC_ST = 0; DEC_ST = 0;
        case (cnt_st)
                2'b01: LD_CONF = 1; 
                2'b10: LD_MD = 1;
                default: LD_CONF = 1;
        endcase
        LD_ADWR = 0; LD_ADRD = 0;
        LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
      end


      READ_DATA: begin
        SCL_EN = 1; SDA_OE = 0; 
        INC_BC = SH_ST; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT= 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = SH_ST;
      end


      WRITE_ACK: begin
        SCL_EN = 1; SDA_OE = 1; 
        INC_BC = 0; RST_BC = 1; 
        DEC_BY = SH_ST; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT= 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 1; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
      end


      WRITE_NACK: begin
        SCL_EN = 1; SDA_OE = 1; 
        INC_BC = 0; RST_BC = 1; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT= 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 1;
        SH_WR = 0; SH_RD = 0;
      end

      STOP_1: begin
        SCL_EN = 1; SDA_OE = 1; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 1; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0 ;
      end

      STOP_2: begin
        SCL_EN = 0; SDA_OE = 1; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0; 
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 1; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0 ;
      end

      STOP_3: begin
        SCL_EN = 0; SDA_OE = 1; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0; 
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 1;
        SH_WR = 0; SH_RD = 0 ;
      end

      WAIT: begin
        SCL_EN = 0; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = SH_ST; RST_WT = 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
      end

      CHECK_T1: begin
        SCL_EN = 0; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
      end

      CHECK_T2: begin
        SCL_EN = 0; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
      end

      SET_I1: begin
        SCL_EN = 0; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
        I1 = 1;
        I2 = 0;
        I3 = 0;
      end

      SET_I2: begin
        SCL_EN = 0; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
        I1 = 0;
        I2 = 1;
        I3 = 0;
      end

      SET_I3: begin
        SCL_EN = 0; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
        I1 = 0;
        I2 = 0;
        I3 = 1;
      end

      CH_CONF: begin
        SCL_EN = 0; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 0; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 0; 
        DEC_WT = 0; RST_WT = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0;
        case (cnt_st)
                2'b01: INC_ST = SH_ST;
                2'b10: DEC_ST = SH_ST;
                default: INC_ST = SH_ST;
        endcase
      end

      default: begin
        SCL_EN = 0; SDA_OE = 0; 
        INC_BC = 0; RST_BC = 1; 
        DEC_BY = 0; RST_BYR = 0;  RST_BYW = 1; 
        DEC_WT = 0; RST_WT= 0;
        INC_ST = 0; DEC_ST = 0;
        LD_ADWR = 0; LD_ADRD = 0; LD_CONF = 0; 
        LD_MD = 0; LD_START = 0; LD_STOP = 0;
        SH_WR = 0; SH_RD = 0; 
      end

    endcase
end


`ifdef BENCH
reg [8*40:1] state_name;
always @(*) begin
  case(state)
    IDLE              : state_name = "IDLE";
    START_1             : state_name = "START_1";
    START_2             : state_name = "START_2";
    ADDRESS           : state_name = "ADDRESS";
    READ_ACK          : state_name = "READ_ACK";
    WRITE_DATA        : state_name = "WRITE_DATA";
    READ_ACK2         : state_name = "READ_ACK2";
    READ_DATA         : state_name = "READ_DATA";
    WRITE_ACK         : state_name = "WRITE_ACK";
    WRITE_NACK        : state_name = "WRITE_NACK";
    STOP_1            : state_name = "STOP_1";
    STOP_2            : state_name = "STOP_2";
    STOP_3            : state_name = "STOP_3";
    WAIT              : state_name = "WAIT";
    CHECK_T1          : state_name = "CHECK_T1";
    CHECK_T2          : state_name = "CHECK_T2";
    SET_I1            : state_name = "SET_I1";
    SET_I2            : state_name = "SET_I2";
    SET_I3            : state_name = "SET_I3";
    CH_CONF           : state_name = "SET_I1";
  endcase
end
`endif

endmodule
