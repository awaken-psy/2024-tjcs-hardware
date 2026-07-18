`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/10 21:52:30
// Design Name: 
// Module Name: openmips_min_sopc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module openmips_min_sopc_tb();
    
    reg CLOCK_50;
    reg rst;
    
    // ÿ��10ns��CLOCK_50�źŷ�ת���Σ�����һ��������20ns����Ӧ50MHz
    initial
    begin
        CLOCK_50 = 1'b0;
        forever #10 CLOCK_50 = ~CLOCK_50;
    end
    
    // ���ʱ�̣���λ�ź���Ч���ڵ�195ns����λ�ź���Ч����СSOPC��ʼ����
    initial
    begin
        rst = 1'b1;
        #195 rst = 1'b0;
    end
    
    // ������СSOPC
    openmips_min_sopc openmips_min_sopc0(
        .clk(CLOCK_50),
        .rst(rst)
    );
    
endmodule
