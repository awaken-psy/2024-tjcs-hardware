set_property PACKAGE_PIN J15 [get_ports {sw[2]}]
set_property PACKAGE_PIN L16 [get_ports {sw[1]}]
set_property PACKAGE_PIN M13 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN K16 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]




module encoder83_tb;
    reg [7:0]Data_in;
    wire [2:0]Data_out;
    encoder83 encoder83_test_1(.iData(Data_in),.oData(Data_out));
    initial begin
        #50 Data_in=8'b0000_0001;
        #50 Data_in=8'b0000_0010;
        #50 Data_in=8'b0000_0100;
        #50 Data_in=8'b0000_1000;
        #50 Data_in=8'b0001_0000;
        #50 Data_in=8'b0010_0000;
        #50 Data_in=8'b0100_0000;
        #50 Data_in=8'b1000_0000;
    end
endmodule

module encoder83(
    input [7:0] iData,
    output reg [2:0] oData
    );
    always @(*) begin
        case(iData)
            8'b0000_0001: oData = 3'b000;
            8'b0000_0010: oData = 3'b001;
            8'b0000_0100: oData = 3'b010;
            8'b0000_1000: oData = 3'b011;
            8'b0001_0000: oData = 3'b100;
            8'b0010_0000: oData = 3'b101;
            8'b0100_0000: oData = 3'b110;
            8'b1000_0000: oData = 3'b111;
        endcase
    end
endmodule

