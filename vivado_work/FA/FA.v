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
