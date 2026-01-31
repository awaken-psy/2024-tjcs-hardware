`timescale 1ns / 1ps

module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow
    );
     wire signed [31:0] a_signed=$signed(a);
     wire signed [31:0] b_signed=$signed(b);
    always @(*) begin
        case (aluc)
            4'b0000:begin assign r=a+b;
                assign carry=(r<a)||(r<b);
                assign negative = r[31];
            end
            4'b0010:begin assign r = a_signed+b_signed;
                assign overflow = (a_signed[31] & b_signed[31] & ~r[31])|(~a_signed[31] & ~b_signed[31] & r[31]);
                assign negative = r[31];
            end        
            4'b0001:begin assign r=a-b;
                assign carry=(a<b);
                assign negative = r[31];
            end
            4'b0011:begin assign r = a_signed-b_signed;
                if(a[31]&~b[31]) assign overflow = a[31]&~b[31]&~r[31];
                else if(~a[31]&b[31]) assign overflow = ~a[31]&b[31]&r[31];
                else assign overflow = 0;

                assign negative = r[31];
            end         
            4'b0100:begin assign r=a&b; assign negative = r[31];end        
            4'b0101:begin assign r=a|b; assign negative = r[31];end    
            4'b0110:begin assign r=a^b; assign negative = r[31];end  
            4'b0111:begin assign r =~(a|b);assign negative = r[31];end        
            4'b1000:begin assign r={b[15:0],16'b0};assign negative = r[31];end        
            4'b1001:begin assign r={b[15:0],16'b0};assign negative = r[31];end                                         
            4'b1011:begin assign r=(a_signed<b_signed)?1:0;assign negative = (a_signed-b_signed<0);end
            4'b1010:begin assign r=(a<b)?1:0;assign carry = (a<b);assign negative = r[31];end
            4'b1100:begin assign r=b_signed>>>a;
                if(a>0) assign carry=(a<32)?b[a-1]:b[31];
                else assign carry = 0;

                assign negative = r[31];
            end        
            4'b1110:begin assign r=b<<a;
                if(a>0) assign carry=(a<32)?b[32-a]:1'b0;
                else assign carry = 0;

                assign negative = r[31];
            end        
            4'b1111:begin assign r=b<<a;
                if(a>0) assign carry=(a<32)?b[32-a]:1'b0;
                else assign carry = 0;

                assign negative = r[31];
            end
            4'b1101:begin assign r=b_signed>>a;
                if(a>0) assign carry=(a<32)?b[a-1]:1'b0;
                else assign carry = 0;

                assign negative = r[31];
            end
        endcase
        if(aluc==4'b1011)
            assign zero=(a_signed == b_signed);
        else if (aluc==4'b1010)
            assign zero=(a == b);
        else 
            assign zero=(r == 0);
    end
endmodule

