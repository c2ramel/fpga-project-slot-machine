module Frequency_Divider (
    input clk,          // 50 MHz System Clock
    input rst,
    output reg tick_1khz, // 1ms pulse for Display Scanning
    output reg tick_15hz  // 66ms pulse for Game Logic/Animation
);
    integer count_scan;
    integer count_game;

    // Generated pulses are exactly 1 clock cycle wide
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count_scan <= 0;
            tick_1khz <= 0;
            count_game <= 0;
            tick_15hz <= 0;
        end else begin
            // 1kHz Generation (50,000 cycles)
            if (count_scan >= 49999) begin
                tick_1khz <= 1;
                count_scan <= 0;
            end else begin
                tick_1khz <= 0;
                count_scan <= count_scan + 1;
            end

            // 15Hz Generation (3,333,333 cycles)
            if (count_game >= 3333332) begin
                tick_15hz <= 1;
                count_game <= 0;
            end else begin
                tick_15hz <= 0;
                count_game <= count_game + 1;
            end
        end
    end
    
endmodule
