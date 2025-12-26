module Dot_Matrix_Display (
    input clk_1khz,             
    input rst,
    input [1:0] s1,
    input [1:0] s2,
    input [1:0] s3,
    output reg [7:0] row_pins,
    output reg [7:0] col_left,  // Mapped to DOT_COL_1 (Left Matrix)
    output reg [7:0] col_right  // Mapped to DOT_COL_0 (Right Matrix)
);

    reg [2:0] row_idx;
    reg [3:0] shape1, shape2, shape3; 

    always @(posedge clk_1khz or negedge rst) begin
        if (!rst) begin
            row_idx <= 0;
            row_pins <= 8'b11111111; 
        end else begin
            row_idx <= row_idx + 1;
            case (row_idx)
                3'd0: row_pins <= 8'b11111110;
                3'd1: row_pins <= 8'b11111101;
                3'd2: row_pins <= 8'b11111011;
                3'd3: row_pins <= 8'b11110111;
                3'd4: row_pins <= 8'b11101111;
                3'd5: row_pins <= 8'b11011111;
                3'd6: row_pins <= 8'b10111111;
                3'd7: row_pins <= 8'b01111111;
            endcase
        end
    end

    function [3:0] get_pixels;
        input [1:0] sym_id;
        input [2:0] r;
        begin
            case (sym_id)
                2'd0: case(r)
                    3'd1, 3'd2, 3'd6: get_pixels = 4'b0110;
                    3'd3, 3'd4:       get_pixels = 4'b0010;
                    3'd5:             get_pixels = 4'b1001;
                    default:          get_pixels = 4'b0000;
                endcase
                2'd1: case(r)
                    3'd0, 3'd1, 3'd6, 3'd7: get_pixels = 4'b1111;
                    default:                get_pixels = 4'b0000;
                endcase
                2'd2: case(r)
                    3'd0:       get_pixels = 4'b1111;
                    3'd1:       get_pixels = 4'b0001;
                    3'd2:       get_pixels = 4'b0010;
                    default:    get_pixels = 4'b0100;
                endcase
                2'd3: case(r)
                    3'd1, 3'd6: get_pixels = 4'b0100;
                    3'd2, 3'd5: get_pixels = 4'b0110;
                    3'd3, 3'd4: get_pixels = 4'b1111;
                    default:    get_pixels = 4'b0000;
                endcase
            endcase
        end
    endfunction

    always @(*) begin
        shape1 = get_pixels(s1, row_idx);
        shape2 = get_pixels(s2, row_idx);
        shape3 = get_pixels(s3, row_idx);
        
        // Left Matrix (Col 0-7): Reel 1 + Part of Reel 2
        // Bits [3:0] = Reel 1
        // Bit [4] = Space
        // Bits [7:5] = Reel 2 Lower 3 bits
        col_left = {shape2[2:0], 1'b0, shape1};
        
        // Right Matrix (Col 8-15): Part of Reel 2 + Reel 3
        // Bit [0] = Reel 2 Upper bit
        // Bit [1] = Space
        // Bits [5:2] = Reel 3
        // Bits [7:6] = Space
        col_right = {2'b00, shape3, 1'b0, shape2[3]};
    end
endmodule