`timescale 1ns / 1ps


module DataCompare8_tb;
    reg [7:0]a;
    reg [7:0]b;
    reg [2:0]Data_out;

DataCompare8 test1(.iData_a(a),.iData_b(b),.oData(Data_out));
initial begin
    //a = 1111_0011 b = 1100_1011 100
    #10 begin a = 8'b1111_0011;b = 8'b1100_1011;  end
    //a = 1111_0000 b = 0000_1111 100
    #10 begin a = 8'b1111_0000;b = 8'b0000_1111;  end

    //a = 1010_1010 b = 1100_1111 010
    #10 begin a = 8'b1010_1010;b = 8'b1100_1111;  end
    //a = 1010_1010 b = 1010_1010 001
    #10 begin a = 8'b1010_1010;b = 8'b1010_1010;  end
    
end
endmodule
