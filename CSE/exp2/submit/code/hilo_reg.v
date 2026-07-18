//////////////////////////////////////////////////////////////////////
// Module:  hilo_reg
// File:    hilo_reg.v
// Description: ±£´æ³Ë·¨½á¹ûµÄHI¡¢LO¼Ä´æÆ÷
//////////////////////////////////////////////////////////////////////

`include "defines.v"

module hilo_reg(

	input	wire										clk,
	input wire										rst,
	
	//Ð´¶Ë¿Ú
	input wire										we,
	input wire[`RegBus]				    hi_i,
	input wire[`RegBus]						lo_i,
	
	//¶Á¶Ë¿Ú1
	output reg[`RegBus]           hi_o,
	output reg[`RegBus]           lo_o
	
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
					hi_o <= `ZeroWord;
					lo_o <= `ZeroWord;
		end else if((we == `WriteEnable)) begin
					hi_o <= hi_i;
					lo_o <= lo_i;
		end
	end

endmodule