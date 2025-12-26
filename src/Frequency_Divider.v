module Frequency_Divider (
    input clk,
    input rst,
    output reg clk_1khz,
    output reg clk_15hz
);
    integer count_scan;
    integer count_game;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            count_scan <= 0;
            clk_1khz <= 0;
            count_game <= 0;
            clk_15hz <= 0;
        end else begin
            if (count_scan >= 25000) begin
                clk_1khz <= ~clk_1khz;
                count_scan <= 0;
            end else begin
                count_scan <= count_scan + 1;
            end

            if (count_game >= 1666666) begin
                clk_15hz <= ~clk_15hz;
                count_game <= 0;
            end else begin
                count_game <= count_game + 1;
            end
        end
    end
endmodule