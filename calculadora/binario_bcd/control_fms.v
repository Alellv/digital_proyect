module control_fsm (
    input wire clk,
    input wire reset,
    input wire init,
    input wire z,         
    output reg sh,         
    output reg ld,        
    output reg add,       
    output reg ld_msb,
    output reg done
);

    localparam START     = 6'b000001;
    localparam SHIFT_DEC = 6'b000010;
    localparam CHECK     = 6'b000100;
    localparam LOAD_A2   = 6'b001000;
    localparam ADD       = 6'b010000;
    localparam END1      = 6'b100000;

    reg [5:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= START;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            START: 
                if (init) next_state = SHIFT_DEC;
                else      next_state = START;
            
            SHIFT_DEC: 
                if (z)    next_state = END1; 
                else      next_state = CHECK; 
            
            CHECK:        next_state = LOAD_A2;
            LOAD_A2:      next_state = ADD;
            ADD:          next_state = SHIFT_DEC; 
            
            END1:         next_state = END1; 
            
            default:      next_state = START;
        endcase
    end

    always @(*) begin
        sh = 0; ld = 0; add = 0; sel = 0; ld_msb = 0; done = 0;

        case (current_state)
            START: begin
                ld = 1;    
            end

            SHIFT_DEC: begin
                sh = 1;      
                sel = 1;
                ld_msb = 1;
            end

            CHECK: begin
                sel = 1;     
                ld_msb = 1;  
            end

            LOAD_A2: begin
                add = 1;    
            end
            
            ADD: begin
                 
            end

            END1: begin
                done = 1;    
            end
        endcase
    end

endmodule
