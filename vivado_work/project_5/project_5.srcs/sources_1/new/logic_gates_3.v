module logic_gates_3(
    input iA,
    input iB,
    output reg oAnd,
    output reg oOr,
    output reg oNot
    );
    always @ (*)
    begin
    oAnd = iA & iB;
    oOr = iA | iB;
    oNot = ~ iA;
    end
endmodule
