module slot_machine_v2 (
    input MAX10_CLK1_50,
    input KEY0, // Spin
    input KEY1, // Reset
    
    // Switches
    input SW0, SW1, SW2, // Bet
    input SW9,           // Cheat Mode

    // Outputs
    output LEDR0, LEDR1, LEDR2, LEDR3, LEDR4, LEDR5, LEDR6, LEDR7, LEDR8, LEDR9,
    output HEX00, HEX01, HEX02, HEX03, HEX04, HEX05, HEX06, 
    output HEX30, HEX31, HEX32, HEX33, HEX34, HEX35, HEX36, 
    output HEX40, HEX41, HEX42, HEX43, HEX44, HEX45, HEX46, 
    output HEX50, HEX51, HEX52, HEX53, HEX54, HEX55, HEX56, 

    output DMR0, DMR1, DMR2, DMR3, DMR4, DMR5, DMR6, DMR7,
    output DMC10, DMC11, DMC12, DMC13, DMC14, DMC15, DMC16, DMC17,
    output DMC00, DMC01, DMC02, DMC03, DMC04, DMC05, DMC06, DMC07
);

    wire btn_spin_clean;
    wire btn_reset_clean;
    wire [2:0] idx_L, idx_R;
    wire [7:0] pixels_L, pixels_R;
    wire [2:0] row_scan_idx;
    wire [15:0] rng_value;
    wire [9:0] led_wires;
    wire [9:0] credits_wire;
    wire [3:0] bet_wire;

    debounce db_spin  (.clk(MAX10_CLK1_50), .btn_in(KEY0), .state(btn_spin_clean));
    debounce db_reset (.clk(MAX10_CLK1_50), .btn_in(KEY1), .state(btn_reset_clean));
    lfsr rng_inst (.clk(MAX10_CLK1_50), .random_out(rng_value));

    // --- CONTROLLER ---
    slot_machine_controller logic_inst (
        .clk(MAX10_CLK1_50),
        .btn_spin(btn_spin_clean),
        .btn_reset(btn_reset_clean),
        .cheat_mode(SW9),            // CONNECT CHEAT SWITCH
        .sw_bet({SW2, SW1, SW0}), 
        .random_seed(rng_value), 
        .symbol_left(idx_L),  
        .symbol_right(idx_R),
        .leds(led_wires),
        .current_credits(credits_wire),
        .current_bet(bet_wire)
    );
    
    // --- DISPLAYS (HEX & MATRIX) ---
    // (This part is identical to previous, just included for context)
    wire [6:0] hex0_out, hex3_out, hex4_out, hex5_out;
    seven_seg_decoder hex0_dec (.num(bet_wire), .seg(hex0_out));
    seven_seg_decoder hex3_dec (.num(credits_wire % 10), .seg(hex3_out));
    seven_seg_decoder hex4_dec (.num((credits_wire / 10) % 10), .seg(hex4_out));
    seven_seg_decoder hex5_dec (.num((credits_wire / 100) % 10), .seg(hex5_out));

    assign HEX00=hex0_out[0]; assign HEX01=hex0_out[1]; assign HEX02=hex0_out[2]; assign HEX03=hex0_out[3]; assign HEX04=hex0_out[4]; assign HEX05=hex0_out[5]; assign HEX06=hex0_out[6];
    assign HEX30=hex3_out[0]; assign HEX31=hex3_out[1]; assign HEX32=hex3_out[2]; assign HEX33=hex3_out[3]; assign HEX34=hex3_out[4]; assign HEX35=hex3_out[5]; assign HEX36=hex3_out[6];
    assign HEX40=hex4_out[0]; assign HEX41=hex4_out[1]; assign HEX42=hex4_out[2]; assign HEX43=hex4_out[3]; assign HEX44=hex4_out[4]; assign HEX45=hex4_out[5]; assign HEX46=hex4_out[6];
    assign HEX50=hex5_out[0]; assign HEX51=hex5_out[1]; assign HEX52=hex5_out[2]; assign HEX53=hex5_out[3]; assign HEX54=hex5_out[4]; assign HEX55=hex5_out[5]; assign HEX56=hex5_out[6];

    assign LEDR0 = led_wires[0]; assign LEDR1 = led_wires[1]; assign LEDR2 = led_wires[2]; assign LEDR3 = led_wires[3]; assign LEDR4 = led_wires[4];
    assign LEDR5 = led_wires[5]; assign LEDR6 = led_wires[6]; assign LEDR7 = led_wires[7]; assign LEDR8 = led_wires[8]; assign LEDR9 = led_wires[9];

    symbol_rom rom_left  (.symbol_id(idx_L), .row_idx(row_scan_idx), .pixels(pixels_L));
    symbol_rom rom_right (.symbol_id(idx_R), .row_idx(row_scan_idx), .pixels(pixels_R));

    matrix_driver driver_inst (
        .clk(MAX10_CLK1_50),
        .pixels_left(pixels_L), .pixels_right(pixels_R), .current_row(row_scan_idx),
        .rows({DMR7, DMR6, DMR5, DMR4, DMR3, DMR2, DMR1, DMR0}),
        .cols_left({DMC17, DMC16, DMC15, DMC14, DMC13, DMC12, DMC11, DMC10}),
        .cols_right({DMC07, DMC06, DMC05, DMC04, DMC03, DMC02, DMC01, DMC00})
    );

endmodule