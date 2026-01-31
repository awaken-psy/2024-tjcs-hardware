`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/22 13:30:06
// Design Name: 
// Module Name: DataCompare8
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

module DataCompare4(
    input [3:0] iData_a,
    input [3:0] iData_b,
    input [2:0] iData,
    output reg [2:0] oData
    );

always@(*)begin
    case ({iData_a[3],iData_b[3]})
        2'b10: oData = 3'b100;
        2'b01: oData = 3'b010;
        default:case ({iData_a[2],iData_b[2]})
            2'b10:oData = 3'b100;
            2'b01:oData = 3'b010;
            default:case ({iData_a[1],iData_b[1]})
                2'b10:oData = 3'b100;
                2'b01:oData = 3'b010;
                default:case ({iData_a[0],iData_b[0]})
                    2'b10:oData = 3'b100;
                    2'b01:oData = 3'b010;
                    default:case (iData)
                        3'b100:oData = 3'b100;
                        3'b010:oData = 3'b010;
                        3'b001:oData = 3'b001;
                        default:oData = 3'b000;
                    endcase
                endcase
            endcase
        endcase
    endcase
end
    
endmodule


module DataCompare8(
    input [7:0] iData_a,
    input [7:0] iData_b,
    output [2:0] oData
    );
    wire [2:0]lowest = 3'b001;
    wire [2:0]middle_o;
    wire [2:0]middle_i;
    DataCompare4 lower(.iData_a(iData_a[3:0]),.iData_b(iData_b[3:0]),.iData(lowest[2:0]),.oData(middle_o[2:0]));
    assign middle_i = middle_o;
    DataCompare4 upper(.iData_a(iData_a[7:4]),.iData_b(iData_b[7:4]),.iData(middle_i[2:0]),.oData(oData[2:0]));
endmodule

