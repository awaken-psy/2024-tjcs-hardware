`timescale 1ns / 1ps



module FA_tb;
    reg a;
    reg b;
    reg ic;
    wire oc;
    wire s;

    FA test1(.iA(a),.iB(b),.iC(ic),.oC(oc),.oS(s));
    initial begin
        #10 begin  a=1'b0;  b=1'b0;  ic=1'b1;  end
        #10 begin  a=1'b0;  b=1'b1;  ic=1'b0;  end
        #10 begin  a=1'b0;  b=1'b1;  ic=1'b1;  end
        #10 begin  a=1'b1;  b=1'b0;  ic=1'b0;  end
        #10 begin  a=1'b1;  b=1'b0;  ic=1'b1;  end
        #10 begin  a=1'b1;  b=1'b1;  ic=1'b0;  end
        #10 begin  a=1'b1;  b=1'b1;  ic=1'b1;  end
    end

endmodule
