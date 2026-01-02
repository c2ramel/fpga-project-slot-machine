module matrix_driver (
    input clk,
    
    // Data Input (What to draw on the current row)
    input [7:0] pixels_left,
    input [7:0] pixels_right,

    // Status Output (Tells the ROM which row we are on)
    output reg [2:0] current_row,

    // Physical Hardware Pins
    output reg [7:0] rows,      // Active Low
    output reg [7:0] cols_left, // Active High
    output reg [7:0] cols_right // Active High
);

    reg [16:0] scan_timer;

    // 1. Scanning Logic
    always @(posedge clk) begin
        scan_timer <= scan_timer + 1;
        if (scan_timer == 0) begin
            current_row <= current_row + 1;
        end
    end

    // 2. Physical Output Logic
    always @(*) begin
        // Activate one row (Active Low)
        case (current_row)
            3'd0: rows = 8'b11111110; 
            3'd1: rows = 8'b11111101;
            3'd2: rows = 8'b11111011;
            3'd3: rows = 8'b11110111;
            3'd4: rows = 8'b11101111;
            3'd5: rows = 8'b11011111;
            3'd6: rows = 8'b10111111;
            3'd7: rows = 8'b01111111;
            default: rows = 8'b11111111;
        endcase

        // Pass the input pixels directly to the columns
        cols_left  = pixels_left;
        cols_right = pixels_right;
    end

endmodule