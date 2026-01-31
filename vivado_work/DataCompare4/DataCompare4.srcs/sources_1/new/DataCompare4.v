`timescale 1ns / 1ps

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

/*



*/
