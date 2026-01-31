`timescale 1ns/1ns

module MULT_tb;
    reg clk;
    reg reset;
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] z;

    MULT uut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .z(z)
    );

    // 生成时钟信号，周期10ns
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // 测试用例
    initial begin
        // 初始化输入
        reset = 1;
        a = 0;
        b = 0;

        #20 reset = 0;
        #140; // 等待两个时钟周期
        reset = 1;
        #40 reset = 0;
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        #140;
       

        reset = 1;
        #60 reset = 0;
        a = 32'h7FFFFFFF;
        b = 32'h1;
        #140;
      

        reset = 1;
        #40 reset = 0;
        a = 32'h80000000;
        b = 32'h1;
        #140;
      
        reset = 1;
        #40 reset = 0;
        a = 32'h80000000;
        b = 32'h80000000;
        #140;
    end

endmodule
