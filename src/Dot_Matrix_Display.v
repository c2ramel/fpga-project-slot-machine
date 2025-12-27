module Dot_Matrix_Display (
    input clk,                  // 50 MHz
    input tick_1khz,            // Enable pulse
    input rst,
    input [1:0] s1,
    input [1:0] s2,
    input [1:0] s3,
    output reg [7:0] row_pins,
    output reg [7:0] col_left,  
    output reg [7:0] col_right  
);

    reg [2:0] row_idx;
    reg [3:0] shape1, shape2, shape3; 

    // Synchronous Update Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            row_idx <= 0;
            row_pins <= 8'b11111111; 
        end else if (tick_1khz) begin // Only update when the tick fires
            row_idx <= row_idx + 1;
            case (row_idx) // Next row (pre-calculated for next cycle)
                3'd7: row_pins <= 8'b11111110; // Row 0
                3'd0: row_pins <= 8'b11111101; // Row 1
                3'd1: row_pins <= 8'b11111011; // Row 2
                3'd2: row_pins <= 8'b11110111; // Row 3
                3'd3: row_pins <= 8'b11101111; // Row 4
                3'd4: row_pins <= 8'b11011111; // Row 5
                3'd5: row_pins <= 8'b10111111; // Row 6
                3'd6: row_pins <= 8'b01111111; // Row 7
            endcase
        end
    end

    function [3:0] get_pixels;
        input [1:0] sym_id;
        input [2:0] r;
        begin
            case (sym_id)
                2'd0: case(r) // Cherry
                    3'd1, 3'd2, 3'd6: get_pixels = 4'b0110;
                    3'd3, 3'd4:       get_pixels = 4'b0010;
                    3'd5:             get_pixels = 4'b1001;
                    default:          get_pixels = 4'b0000;
                endcase
                2'd1: case(r) // Bar
                    3'd0, 3'd1, 3'd6, 3'd7: get_pixels = 4'b1111;
                    default:                get_pixels = 4'b0000;
                endcase
                2'd2: case(r) // Seven
                    3'd0:       get_pixels = 4'b1111;
                    3'd1:       get_pixels = 4'b0001;
                    3'd2:       get_pixels = 4'b0010;
                    default:    get_pixels = 4'b0100;
                endcase
                2'd3: case(r) // Jackpot
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
        
        // Left Matrix: Reel 1 + Lower half of Reel 2
        col_left = {shape2[2:0], 1'b0, shape1};
        
        // Right Matrix: Upper bit of Reel 2 + Reel 3
        col_right = {2'b00, shape3, 1'b0, shape2[3]};
    end
    
endmodule
