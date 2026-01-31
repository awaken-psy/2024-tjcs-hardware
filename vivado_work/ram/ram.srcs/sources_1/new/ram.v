`timescale 1ns / 1ps


module ram(
    input clk,
    input ena,
    input wena,
    input [4:0] addr,
    input [31:0] data_in,
    output reg [31:0] data_out
    );

    reg [31:0] step [0:31];

   always @(*) begin
     if(ena==1 & wena==0)
        begin
            data_out <= step[addr];
        end
     else if(ena==0)
        begin
            data_out <= 32'bz;
        end  
   end

    always @(posedge clk) begin
        if (ena==1 & wena==1)
            begin
                step[addr] <= data_in;
            end
            
    end

endmodule
