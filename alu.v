module alu (input  [7:0] a, input  [7:0] b, input  [2:0] op, input is_signed, output reg [7:0] result, output reg carry, output reg zero, output reg negative, output reg error);
    reg [8:0] sum;              
    reg [7:0] size_a, size_b;   
    always @(*) begin
        carry    = 0;
        error    = 0;
        sum      = 0;
        result   = 0;
        negative = 0;
        // MUX
        case (op)
            3'b000: begin              
                sum    = a + b;
                carry  = sum[8];
                result = sum[7:0];
            end
            3'b001: begin                  
                sum    = a - b;
                carry  = sum[8];            
                result = sum[7:0];
            end
            3'b010: result = a & b;          // AND
            3'b011: result = a | b;          // OR
            3'b100: result = a ^ b;          // XOR
            3'b101: result = ~a;             // NOT
            3'b110: begin                    // SHL 
                carry  = a[7];
                result = a << 1;
            end
            3'b111: begin                    // SHR 
                carry  = a[0];
                result = a >> 1;
            end
        endcase
        if (a[7] == 1)
            size_a = ~a + 1;                
        else
            size_a = a;

        if (b[7] == 1)
            size_b = ~b + 1;
        else
            size_b = b; 
        if (is_signed == 0) begin
            negative = 0;                           
        end
        else if (op == 3'b000) begin                
            if (a[7] == 0 && b[7] == 0)
                negative = 0;                      
            else if (a[7] == 1 && b[7] == 1)
                negative = 1;                        
            else if (a[7] == 1)
                negative = (size_a > size_b);       
            else
                negative = (size_b > size_a);       
        end
        else if (op == 3'b001) begin                 
            if (a[7] == 0 && b[7] == 1)
                negative = 0;                        
            else if (a[7] == 1 && b[7] == 0)
                negative = 1;                       
            else if (a[7] == 0)
                negative = (size_b > size_a);       
            else
                negative = (size_a > size_b);       
        end
        else begin
            negative = result[7];                    
        end

        // see if error
        if (op == 3'b000 || op == 3'b001) begin
            if (is_signed == 0)
                error = carry;                     
            else
                error = (negative != result[7]);     
        end
        if (result == 0)
            zero = 1;
        else
            zero = 0;
    end
endmodule
