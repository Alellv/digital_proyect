module control_fsm_b2b (
    input wire clk,
    input wire reset,
    input wire start,
    input wire z,          
    output reg shift,      
    output reg load_init,  
    output reg load_sub,  
    output reg done      
);

    localparam START     = 5'b00001;
    localparam CHECK     = 5'b00010;
    localparam SUB       = 5'b00100;
    localparam SHIFT_DEC = 5'b01000; 
    localparam END1      = 5'b10000; 

    reg [4:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= START;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            START: 
                if (start) next_state = CHECK;
                else       next_state = START;
            
            CHECK:        next_state = SUB; 
            
            SUB:          next_state = SHIFT_DEC; 
            
            SHIFT_DEC: 
                if (z)    next_state = END1;  
                else      next_state = CHECK; 
            
            END1:         next_state = END1;  
            
            default:      next_state = START;
        endcase
    end

    always @(*) begin
        shift = 0; load_init = 0; load_sub = 0; done = 0;

        case (current_state)
            START: begin
                if (start) load_init = 1;
            end

            CHECK: begin
            end

            SUB: begin
            end

            SHIFT_DEC: begin
                shift = 1;    
            end

            END1: begin
                done = 1;   
            end
        endcase
    end

endmodule
