`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/21 15:47:14
// Design Name: 
// Module Name: DataCompare4_tb
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


module DataCompare4_tb;
    reg [3:0]a;
    reg [3:0]b;
    reg [2:0]lower;
    wire [2:0] data_out;

    DataCompare4 test1(.iData_a(a),.iData_b(b),.iData(lower),.oData(data_out));
    initial begin
        #10 begin a = 4'b1000;b = 4'b0111;  end
        #10 begin a = 4'b0111;b = 4'b1000;  end
        #10 begin a = 4'b0100;b = 4'b0011;  end
        #10 begin a = 4'b0011;b = 4'b0100;  end
        #10 begin a = 4'b0010;b = 4'b0001;  end
        #10 begin a = 4'b0001;b = 4'b0010;  end
        #10 begin a = 4'b0001;b = 4'b0000;  end
        #10 begin a = 4'b0000;b = 4'b0001;  end
        #10 begin a = 4'b1111;b = 4'b1111;lower = 3'b100;  end
        #10 begin a = 4'b1111;b = 4'b1111;lower = 3'b010;  end
        #10 begin a = 4'b1111;b = 4'b1111;lower = 3'b001;  end
    end
endmodule
