`timescale 1ns / 1ps

module JK_FF(
    input CLK,
    input J,
    input K,
    input RST_n,
    output reg Q1,
    output reg Q2
    );
    always @(posedge CLK or negedge RST_n) begin
        if (~RST_n) 
        begin Q1 <= 1'b0;Q2 <= 1'b1;end
        else begin
            case ({J,K})
                2'b11:begin Q1=~Q1;Q2=~Q2;end
                2'b01:begin Q1=1'b0;Q2=1'b1;end
                2'b10:begin Q1=1'b1;Q2=1'b0;end
            endcase
        end
    end
endmodule
