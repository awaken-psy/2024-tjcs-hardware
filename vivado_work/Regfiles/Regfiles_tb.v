`timescale 1ns / 1ns

module Regfiles_tb;
    reg clk;
    reg rst;
    reg we;
    reg [4:0] raddr1;
    reg [4:0] raddr2;
    reg [4:0] waddr;
    reg [31:0] wdata;

    wire [31:0] rdata1;
    wire [31:0] rdata2;

    Regfiles uut (
        .clk(clk),
        .rst(rst),
        .we(we),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        we = 0;
        raddr1 = 5'b0;
        raddr2 = 5'b0;
        waddr = 5'b0;
        wdata = 32'b0;

        // Reset
        rst = 1; #10;
        rst = 0; #10;

        we = 1; waddr = 5'b00001; wdata = 32'hAAAA_BBBB; #10;
        we = 0; #10;

        raddr1 = 5'b00001; #10;
        if (rdata1 !== 32'hAAAA_BBBB) $display("Test 1 Failed: rdata1 = %h", rdata1);
        else $display("Test 1 Passed: rdata1 = %h", rdata1);

        we = 1; waddr = 5'b00010; wdata = 32'hCCCC_DDDD; #10;
        we = 1; waddr = 5'b00011; wdata = 32'hEEEE_FFFF; #10;
        we = 0; #10;

        raddr1 = 5'b00010; raddr2 = 5'b00011; #10;
        if (rdata1 !== 32'hCCCC_DDDD) $display("Test 2 Failed: rdata1 = %h", rdata1);
        else $display("Test 2 Passed: rdata1 = %h", rdata1);

        if (rdata2 !== 32'hEEEE_FFFF) $display("Test 2 Failed: rdata2 = %h", rdata2);
        else $display("Test 2 Passed: rdata2 = %h", rdata2);

        $stop;
    end
endmodule
