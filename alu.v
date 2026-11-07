module alu ( input [7:0] A, input [7:0] B, output reg [7:0] result, input [3:0] opcode, );
  always @(*) begin
    case (opcode)
          4'b0000: result = A + B;
          4'b0001: result = A - B;
          4'b0010: result = A & B;
          4'b0011: result = A | B;
          4'b0100: result = A ^ B;
          default: result = 8'b00000000;
    endcase
  end
endmodule
