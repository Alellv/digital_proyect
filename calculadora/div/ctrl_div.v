module ctrl_div (rst,clk,start,mbb,z,sh,init,lda,dv0,dec,done);

input rst;
input clk;
input start;
input [15:0]mbb;
input z;

output reg sh;
output reg init;
output reg lda;
output reg dv0;
output reg dec;
output reg done;

parameter START = 3'b000;
parameter SHIFT_DEC = 3'b001;
parameter CHECK = 3'b010;
parameter ADD = 3'b011;
parameter END1 = 3'b100;

reg [2:0]state;
reg [3:0]count;

always @(posedge clk) begin

    if (rst) begin
        state=START;
    end else begin
        case (state)

            START:begin
                if(start)
                    state=SHIFT_DEC;
                else 
                    state=START;
            end

            SHIFT_DEC:
            state=CHECK;
            
            CHECK:
            if(z)
                if(mbb[15])
                    state=END1;
                else
                    state=ADD;
            else
                if(mbb[15])
                    state=SHIFT_DEC;
                else
                    state=ADD;


            ADD:
                if (z)
                    state=END1;
                else
                    state=SHIFT_DEC;

            END1:begin
                count=count+1;
                state=(count>9)? START:END1;
            end

            default: state=START;

        endcase 
    end

end


always @(state) begin
    
    case (state)
        
        START:begin
            sh=0;
            init=1;
            lda=0;
            dv0=0;
            dec=0;
            done=0;    
        end 

        SHIFT_DEC:begin
            sh=1;
            init=0;
            lda=0;
            dv0=0;
            dec=1;
            done=0;  
        end

        CHECK:begin
            sh=0;
            init=0;
            lda=0;
            dv0=0;
            dec=0;
            done=0;  
        end

        ADD:begin
            sh=0;
            init=0;
            lda=1;
            dv0=1;
            dec=0;
            done=0;  
        end

        END1:begin
            sh=0;
            init=0;
            lda=0;
            dv0=0;
            dec=0;
            done=1;  
        end


        default:begin
            sh=0;
            init=0;
            lda=0;
            dv0=0;
            dec=0;
            done=0; 
        end
    endcase
end


`ifdef BENCH
reg [8*40:1] state_name;
always @(*) begin
   case(state)

    START       : state_name = "START";
    SHIFT_DEC   : state_name = "SHIFT_DEC";
    CHECK       : state_name = "CHECK";
    ADD         : state_name = "ADD";
    END1        : state_name = "END1";

  endcase
end
`endif


endmodule