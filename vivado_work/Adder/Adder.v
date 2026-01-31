`timescale 1ns / 1ps

module FA(
    input iA,
    input iB,
    input iC,
    output oS,
    output oC
    );
    xor (xor_1,iA,iB);
    and (and1_2,iA,iB);
    and (and2_2,iC,xor_1);
    or  (oC,and1_2,and2_2);
    xor (oS,iC,xor_1);

endmodule

module Adder(
    input [7:0] iData_a,
    input [7:0] iData_b,
    input iC,
    output [7:0] oData,
    output oData_C
    );

    wire c0,c1,c2,c3,c4,c5,c6;
    FA A0(.iA(iData_a[0]),.iB(iData_b[0]),.iC(iC),.oC(c0),.oS(oData[0]));
    FA A1(.iA(iData_a[1]),.iB(iData_b[1]),.iC(c0),.oC(c1),.oS(oData[1]));
    FA A2(.iA(iData_a[2]),.iB(iData_b[2]),.iC(c1),.oC(c2),.oS(oData[2]));
    FA A3(.iA(iData_a[3]),.iB(iData_b[3]),.iC(c2),.oC(c3),.oS(oData[3]));
    FA A4(.iA(iData_a[4]),.iB(iData_b[4]),.iC(c3),.oC(c4),.oS(oData[4]));
    FA A5(.iA(iData_a[5]),.iB(iData_b[5]),.iC(c4),.oC(c5),.oS(oData[5]));
    FA A6(.iA(iData_a[6]),.iB(iData_b[6]),.iC(c5),.oC(c6),.oS(oData[6]));
    FA A7(.iA(iData_a[7]),.iB(iData_b[7]),.iC(c6),.oC(oData_C),.oS(oData[7]));
endmodule

