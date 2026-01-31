`timescale 1ns / 1ps


module ram2(
    input clk,
    input ena,
    input wena,
    input [4:0] addr,
    inout [31:0] data
    );

    reg [31:0] oData;
    reg [31:0] step [0:31];
   assign data = oData;

    always @(*) begin
        if(ena==1 & wena==0)
            begin oData = step[addr]; end
        else
            begin oData = 32'bz; end
    end
   
    always @(posedge clk) begin
        if (ena==1 & wena==1)
            begin step[addr] <= data; end
    end
endmodule
