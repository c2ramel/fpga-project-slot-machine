module symbol_rom (
    input [2:0] symbol_id,
    input [2:0] row_idx,
    output reg [7:0] pixels
);
    always @(*) begin
        case (symbol_id)
            // 0: SEVEN
            3'd0: begin
                 case (row_idx)
                    3'd0: pixels = 8'b00110000; 
                    3'd1: pixels = 8'b00110000; 
                    3'd2: pixels = 8'b00110000; 
                    3'd3: pixels = 8'b00011000; 
                    3'd4: pixels = 8'b00001100; 
                    3'd5: pixels = 8'b00000110; 
                    3'd6: pixels = 8'b01111110; 
                    3'd7: pixels = 8'b01111110; 
                endcase
            end

            // 1: CHERRY
            3'd1: begin
                case (row_idx)
                    3'd0: pixels = 8'b00011000; 
                    3'd1: pixels = 8'b00111100; 
                    3'd2: pixels = 8'b00111100; 
                    3'd3: pixels = 8'b00011000; 
                    3'd4: pixels = 8'b00001000; 
                    3'd5: pixels = 8'b00000100; 
                    3'd6: pixels = 8'b00000010; 
                    3'd7: pixels = 8'b00001100; 
                endcase
            end
            
            // 2: BAR
            3'd2: begin
                case (row_idx)
                    3'd0: pixels = 8'b00000000; 
                    3'd1: pixels = 8'b01111110; 
                    3'd2: pixels = 8'b01111110; 
                    3'd3: pixels = 8'b00000000; 
                    3'd4: pixels = 8'b00000000; 
                    3'd5: pixels = 8'b01111110; 
                    3'd6: pixels = 8'b01111110; 
                    3'd7: pixels = 8'b00000000;
                endcase
            end
            
            // 3: QUESTION MARK
            3'd3: begin
                 case (row_idx)
                    3'd0: pixels = 8'b00011000; 
                    3'd1: pixels = 8'b00000000;
                    3'd2: pixels = 8'b00011000; 
                    3'd3: pixels = 8'b00011100; 
                    3'd4: pixels = 8'b00001110; 
                    3'd5: pixels = 8'b01100110; 
                    3'd6: pixels = 8'b01111110; 
                    3'd7: pixels = 8'b00111100; 
                endcase
            end
            
            default: pixels = 8'b00000000;
        endcase
    end
endmodule