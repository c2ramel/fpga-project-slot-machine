module Final_Project_Slot_Machine (
    input MAX10_CLK1_50,
    input [1:0] KEY,
    input [3:0] SW,
    output [9:0] LED,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,
    output [7:0] DOT_ROW,
    output [7:0] DOT_COL_0,
    output [7:0] DOT_COL_1
);

    wire clk_1khz;
    wire clk_15hz;
    wire [1:0] rng_1;
    wire [1:0] rng_2;
    wire [1:0] rng_3;
    wire [1:0] disp_1;
    wire [1:0] disp_2;
    wire [1:0] disp_3;
    wire [9:0] credits;
    wire [9:0] right_val;
    wire [7:0] matrix_left;
    wire [7:0] matrix_right;
    
    assign DOT_COL_0 = matrix_right;
    assign DOT_COL_1 = matrix_left;

    Frequency_Divider fd (
        .clk(MAX10_CLK1_50),
        .rst(KEY[1]),
        .clk_1khz(clk_1khz),
        .clk_15hz(clk_15hz)
    );

    Random_Number_Generator rng (
        .clk(MAX10_CLK1_50),
        .rst(KEY[1]),
        .cheat_sw(SW[0]),
        .r1(rng_1),
        .r2(rng_2),
        .r3(rng_3)
    );

    FSM game_logic (
        .clk_game(clk_15hz),
        .rst(KEY[1]),
        .btn_spin(KEY[0]),
        .bet_sw(SW[3:1]),
        .rng_1(rng_1),
        .rng_2(rng_2),
        .rng_3(rng_3),
        .disp_1(disp_1),
        .disp_2(disp_2),
        .disp_3(disp_3),
        .credits(credits),
        .right_val(right_val),
        .led(LED)
    );

    Dot_Matrix_Display display (
        .clk_1khz(clk_1khz),
        .rst(KEY[1]),
        .s1(disp_1),
        .s2(disp_2),
        .s3(disp_3),
        .row_pins(DOT_ROW),
        .col_left(matrix_left),
        .col_right(matrix_right)
    );

    Seven_Display scoreboard (
        .left_val(credits),
        .right_val(right_val),
        .hex0(HEX0),
        .hex1(HEX1),
        .hex2(HEX2),
        .hex3(HEX3),
        .hex4(HEX4),
        .hex5(HEX5)
    );

endmodule