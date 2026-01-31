

module logic_gates_1(
    input iA,
    input iB,
    output oAnd,
    output oOr,
    output oNot
    );
    and and_inst(oAnd, iA,iB);
    or or_inst(oOr, iA,iB);
    not not_inst(oNot, iA);
endmodule