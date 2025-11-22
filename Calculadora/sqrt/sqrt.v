module sqrt (
    input              reset,
    input              clk,
    
    input              init,
    output reg         done,

    input      [15:0]  op_A,      // numero a encontrar raiz
    output reg [15:0]  result     // resultado
);

parameter START          = 3'b000;
parameter LOAD           = 3'b001;
parameter SHIFT          = 3'b010;
parameter CHECK           = 3'b011;
parameter CHECK_END      = 3'b100;
parameter END            = 3'b101;

reg [2:0] state;
reg [31:0] A;          // registro raiz expandido
reg [15:0] result_par;          // root parcial
reg [15:0] comparador;
reg [15:0] residuo;

reg [4:0]  count;

initial begin
    result = 0;
    done   = 0;
end

always @(posedge clk or posedge reset)
begin
    if(reset) begin
        state   <= START;
        done    <= 0;
        result  <= 0;
    end else begin
        case(state)

        START: begin
            done  <= 0;
            result <= 0;
            count <= 8;          // 16 bits 8 iteraciones
            if(init)
                state <= LOAD;
            else
                state <= START;
        end
        
        LOAD: begin
            A <= {op_A,16'b0};
            residuo <= 0;
            result_par <= 0;
            done <= 0;
            state <= SHIFT;
        end

        SHIFT: begin // bajar los siguientes 2 bits
            residuo <= {residuo[13:0], A[31:30]};   
            A <= {A[29:0],2'b00};
            state <= CHECK;
        end

        CHECK: begin
            comparador = (result_par << 1) + 1;
            if(residuo >= comparador) begin
                residuo <= residuo - comparador;
                result_par <= (result_par << 1) | 1;
            end
            else begin
                result_par <= (result_par << 1);
            end
            state <= CHECK_END;
        end

        CHECK_END: begin
            if(count == 0) begin
                result <= result_par;
                state <= END;
            end else begin
                count <= count - 1;
                state <= SHIFT;
            end
        end

        END: begin
            done <= 1;
            state <= START;
        end
        
        default: state <= START;

        endcase
    end
end

endmodule
