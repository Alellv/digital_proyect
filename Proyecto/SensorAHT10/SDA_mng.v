module SDA_mng (
    input clk, 
    input rst,
    input [2:0] cnt_by,
    input LD_ADWR, 
    input LD_ADRD, 
    input LD_CONF, 
    input LD_MD,  
    input LD_START, 
    input LD_STOP,
    input SH_WR, 
    input SH_RD, 
    input SDA_OE, 
    output [19:0] temp, 
    output ACK,
    inout SDA
);
    
reg [7:0] data_comd [0:10];
reg [7:0] data_out;
reg [47:0] data_sav;

always @(negedge clk ) begin

    if(rst) begin
        //Bytes para address
        data_comd[0] <= 8'h70;  //WR
        data_comd[1] <= 8'h71;  //RD
        //Bytes para configuracion
        data_comd[2] <= 8'h00;
        data_comd[3] <= 8'h08;
        data_comd[4] <= 8'hE1;
        //Bytes para comenzar medicion
        data_comd[5] <= 8'h00;
        data_comd[6] <= 8'h33;
        data_comd[7] <= 8'hAC;
        //Registros para entrada y salida de datos
        data_out <= 8'h00;
        data_sav <= 48'h000000;
    end
    else begin
        if(LD_START)
            data_out[7] <= 1'b0;
        if(LD_STOP)
            data_out[7] <= 1'b1;
        if(LD_ADWR)
            data_out <= data_comd[0];
        if(LD_ADRD)
            data_out <= data_comd[1];
        if(LD_CONF)
            data_out <= data_comd[1+cnt_by];
        if(LD_MD)
            data_out <= data_comd[4+cnt_by];
        if(SH_WR)
            data_out[7:0] <= {data_out[6:0],1'b0};
        if(~SDA_OE) begin
            if(SH_RD)begin
                data_sav[47:0] <= {data_sav[46:0],SDA};
            end
        end
    end
end
        
assign SDA = (data_out[7] == 0 && SDA_OE) ? 1'b0 : 1'bz;
assign ACK = SDA;
assign temp = data_sav[19:0];
endmodule