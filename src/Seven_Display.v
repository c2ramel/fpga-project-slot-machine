module Seven_Display (
    input [9:0] left_val,
    input [9:0] right_val,
    output [6:0] hex0,
    output [6:0] hex1,
    output [6:0] hex2,
    output [6:0] hex3,
    output [6:0] hex4,
    output [6:0] hex5
);
    function [6:0] dec;
        input [3:0] bin;
        begin
            case(bin)
                4'h0: dec = 7'b1000000;
                4'h1: dec = 7'b1111001;
                4'h2: dec = 7'b0100100;
                4'h3: dec = 7'b0110000;
                4'h4: dec = 7'b0011001;
                4'h5: dec = 7'b0010010;
                4'h6: dec = 7'b0000010;
                4'h7: dec = 7'b1111000;
                4'h8: dec = 7'b0000000;
                4'h9: dec = 7'b0010000;
                default: dec = 7'b1111111;
            endcase
        end
    endfunction

    assign hex0 = dec(right_val % 10);
    assign hex1 = dec((right_val / 10) % 10);
    assign hex2 = dec((right_val / 100) % 10);
    assign hex3 = dec(left_val % 10);
    assign hex4 = dec((left_val / 10) % 10);
    assign hex5 = dec((left_val / 100) % 10);

endmodule