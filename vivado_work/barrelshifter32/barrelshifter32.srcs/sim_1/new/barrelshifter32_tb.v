`timescale 1ns / 1ps

module barrelshifter32_tb();
reg [31:0]data_in;//a
reg [4:0]move;//b
reg [1:0]method;//aluc
wire [31:0]data_out;//c
barrelshifter32 test1(.a(data_in),.b(move),.c(data_out),.aluc(method));

always #5 move = move + 1;
always #160 data_in = 32'b11111111_11111111_11111111_11111111;

initial begin
    #0 move = 5'b00000;
    #0 data_in = 32'b11111111_11111111_11111111_11111111;
    #0 method = 2'b01;//arithmetic left begin
    #160 method = 2'b00;//arithmetic right begin
    #160 method = 2'b11;//logic left begin
    #160 method = 2'b10;//logic right begin
end
endmodule
