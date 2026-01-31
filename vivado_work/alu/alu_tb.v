`timescale 1ns / 1ps

module alu_tb;
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] aluc;

    wire [31:0] r;
    wire zero;
    wire carry;
    wire negative;
    wire overflow;

    alu uut (
        .a(a),
        .b(b),
        .aluc(aluc),
        .r(r),
        .zero(zero),
        .carry(carry),
        .negative(negative),
        .overflow(overflow)
    );

    initial begin
        a = 32'h00000000; b = 32'h0F0F0F0F; aluc = 4'b0101; 
        #10;
        a = 32'hFFFF0000; b = 32'hFFFFFFFF; aluc = 4'b0110;
        #10;
        a = 32'h0; b = 32'hA0A0A0A0; aluc = 4'b0111;
        #10;
        a = 32'h7FFFFFFF; b = 32'h00000001; aluc = 4'b0010; 
        #10;
        a = 32'h0000000F; b = 32'hFFFFFFFF; aluc = 4'b1101; 
        #10;
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; aluc = 4'b0011; 
        #10;
        a = 32'h7fffffff; b = 32'h80000000; aluc = 4'b0011;
        #10;
        a = 32'hffffffff; b = 32'h80000000; aluc = 4'b0011;
        #10
        a = 32'h00000001; b = 32'h00000001; aluc = 4'b1110; 
        #10;
        a = 32'h00000000; b = 32'h00000001; aluc = 4'b1110;
        #10;
        a = 32'h00000001; b = 32'h00000001; aluc = 4'b0000; 
        #10;
        a = 32'h00000002; b = 32'h00000001; aluc = 4'b0001;
        #10;
        a = 32'hFFFFFFFF; b = 32'h0F0F0F0F; aluc = 4'b0100; 
        #10;
        a = 32'h00000000; b = 32'hFFFFFFFF; aluc = 4'b1101; 
        #10;
        a = 32'h00000001; b = 32'hFFFFFFFF; aluc = 4'b1100;
        #10;
        a = 32'h00000000; b = 32'hFFFFFFFF; aluc = 4'b1100;
        #10
        a = 32'h00000001; b = 32'hffffffff; aluc=4'b1010;
        #10;
        
    end
endmodule
