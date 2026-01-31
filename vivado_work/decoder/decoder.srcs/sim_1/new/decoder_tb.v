`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/13 21:12:00
// Design Name: 
// Module Name: decoder_tb
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


module decoder_tb;
reg [2:0] Data_in;
reg [1:0] Ena_in;
wire [7:0] Data_out;
decoder decoder_test_1(.iData(Data_in),.iEna(Ena_in),.oData(Data_out));
initial begin
    #10 begin Ena_in=2'b10;Data_in=3'b000;end
    #10 begin Ena_in=2'b10;Data_in=3'b001;end
    #10 begin Ena_in=2'b10;Data_in=3'b010;end
    #10 begin Ena_in=2'b10;Data_in=3'b011;end
    #10 begin Ena_in=2'b10;Data_in=3'b100;end
    #10 begin Ena_in=2'b10;Data_in=3'b101;end
    #10 begin Ena_in=2'b10;Data_in=3'b110;end
    #10 begin Ena_in=2'b10;Data_in=3'b111;end
end
endmodule
