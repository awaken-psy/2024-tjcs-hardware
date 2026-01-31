module logic_gates_2(
    input iA,
    input iB,
    output oAnd,
    output oOr,
    output oNot
    );
   assign oAnd = iA & iB;
   assign oOr = iA | iB;
   assign oNot = ~iA;
endmodule
