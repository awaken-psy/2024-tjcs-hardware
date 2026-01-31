`timescale 1ns / 1ps

module Counter8(
    input CLK,
    input rst_n,
    output [2:0] oQ,
    output [6:0] oDisplay
    ); 
    wire [2:0] Q;
    JK_FF JK0(.J(1'b1),.K(1'b1),.CLK(CLK),.RST_n(rst_n),.Q1(Q[0]),.Q2());
    JK_FF JK1(.J(Q[0]),.K(Q[0]),.CLK(CLK),.RST_n(rst_n),.Q1(Q[1]),.Q2());
    JK_FF JK2(.J(Q[0]&Q[1]),.K(Q[0]&Q[1]),.CLK(CLK),.RST_n(rst_n),.Q1(Q[2]),.Q2());
    assign oQ = Q ;
    display7 disp1(.iData({1'b0,oQ}),.oData(oDisplay));

endmodule

module JK_FF(
    input CLK,
    input J,
    input K,
    input RST_n,
    output reg Q1,
    output reg Q2
    );
    always @(posedge CLK or negedge RST_n) 
    begin
        if (~RST_n) begin
            Q1 <= 1'b0;
            Q2 <= 1'b1;
        end
        else begin
            case ({J,K})
                2'b10:begin Q1=1'b1;Q2=1'b0;end
                2'b11:begin Q1=~Q1;Q2=~Q2;end
                2'b01:begin Q1=1'b0;Q2=1'b1;end
            endcase
        end
    end
endmodule

module display7(
    input [3:0] iData,
    output reg [6:0] oData
    );
    always @(*) begin
            case(iData)
                4'b0000: oData = 7'b100_0000;
                4'b0001: oData = 7'b111_1001;
                4'b0010: oData = 7'b010_0100;
                4'b0011: oData = 7'b011_0000;
                4'b0100: oData = 7'b001_1001;
                4'b0101: oData = 7'b001_0010;
                4'b0110: oData = 7'b000_0010;
                4'b0111: oData = 7'b111_1000;
                4'b1000: oData = 7'b000_0000;
                4'b1001: oData = 7'b001_0000;
            endcase
        end
endmodule