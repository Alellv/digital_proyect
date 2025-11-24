module ctrl (rst, clk, start, lsbb, z, load, sh, add, done);

input           clk;
input           rst;
input           lsbb;
input           z;
input           start;

output reg load;
output reg sh;
output reg add;
output reg done;

parameter START = 3'b000;
parameter CHECK = 3'b001;
parameter ADD = 3'b010;
parameter SHIFT = 3'b011;
parameter END1 = 3'b100;

reg [2:0] state;
reg [3:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= START;
        count <= 4'b0;
    end else begin
        case (state)
            START: begin
                if(start)
                    state <= CHECK;
                else 
                    state <= START;
            end

            CHECK: begin 
                if(lsbb)
                    state <= ADD;
                else
                    state <= SHIFT;
            end

            ADD:
                state <= SHIFT;

            SHIFT: begin
                if(z)
                    state <= END1;
                else
                    state <= CHECK; 
            end

            END1: begin
                count <= count + 1;
                if(count > 9) begin
                    state <= START;
                    count <= 4'b0;
                end else begin
                    state <= END1;
                end
            end

            default: state <= START;
        endcase 
    end
end

always @(*) begin
    case (state)

        START: begin
            load = 1;
            sh = 0;
            add = 0;
            done = 0;
        end 

        CHECK: begin
            load = 0;
            sh = 0;
            add = 0;
            done = 0;
        end

        ADD: begin
            load = 0;
            sh = 0;
            add = 1;
            done = 0;
        end

        SHIFT: begin
            load = 0;
            sh = 1;
            add = 0;
            done = 0;
        end

        END1: begin
            load = 0;
            sh = 0;
            add = 0;
            done = 1;
        end

        default: begin
            load = 0;
            sh = 0;
            add = 0;
            done = 0;
        end
        
    endcase
end


`ifdef BENCH
reg [8*40:1] state_name;
always @(*) begin
   case(state)

    START       : state_name = "START";
    CHECK       : state_name = "CHECK";
    ADD         : state_name = "ADD";
    SHIFT       : state_name = "SHIFT";
    END1        : state_name = "END1";

  endcase
end
`endif




endmodule