`timescale 1ns/1ps
module alu_tb;
    reg  [7:0] a;
    reg  [7:0] b;
    reg  [2:0] op;
    reg        is_signed;
    wire [7:0] result;
    wire carry, zero, negative, error;

    // plug the ALU into the test bench
    alu uut (
        .a(a), .b(b), .op(op), .is_signed(is_signed),
        .result(result), .carry(carry), .zero(zero),
        .negative(negative), .error(error)
    );

    initial begin
        $display("mode     |  op |    A    B | result | N E Z");

        // ---- unsigned tests ----
        is_signed = 0;
        a = 127; b = 1;   op = 3'b000; #10 show();   // 128, fine
        a = 200; b = 100; op = 3'b000; #10 show();   // 300 too big: error
        a = 10;  b = 20;  op = 3'b001; #10 show();   // below 0: error
        a = 50;  b = 50;  op = 3'b001; #10 show();   // 0: zero flag

        // ---- signed tests ----
        is_signed = 1;
        a = 50;   b = -80;  op = 3'b000; #10 show();  // -30: negative is bigger
        a = -20;  b = 70;   op = 3'b000; #10 show();  // +50: positive is bigger
        a = -50;  b = -30;  op = 3'b000; #10 show();  // -80
        a = 10;   b = 20;   op = 3'b001; #10 show();  // -10
        a = -30;  b = -50;  op = 3'b001; #10 show();  // +20
        a = 127;  b = 1;    op = 3'b000; #10 show();  // +128 too big: error
        a = -100; b = -100; op = 3'b000; #10 show();  // -200 too big: error
        a = 100;  b = -100; op = 3'b001; #10 show();  // +200 too big: error

        // ---- logic and shift tests ----
        a = 8'b11110000; b = 8'b00111100; op = 3'b010; #10 show();  // AND
        a = 8'b10000001; b = 0;           op = 3'b110; #10 show();  // SHL

        $finish;
    end

    task show();
        if (is_signed)
            $display("signed   | %b | %4d %4d |  %4d  | %b %b %b",
                     op, $signed(a), $signed(b), $signed(result), negative, error, zero);
        else
            $display("unsigned | %b | %4d %4d |  %4d  | %b %b %b",
                     op, a, b, result, negative, error, zero);
    endtask
endmodule
