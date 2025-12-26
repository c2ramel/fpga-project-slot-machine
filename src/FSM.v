module FSM (
    input clk_game,
    input rst,          // KEY[1]
    input btn_spin,     // KEY[0]
    input [2:0] bet_sw, // SW[3:1]
    input [1:0] rng_1, rng_2, rng_3,
    output reg [1:0] disp_1, disp_2, disp_3,
    output reg [9:0] credits,
    output reg [9:0] right_val,
    output [9:0] led
);
    parameter IDLE = 0, SPINNING = 1, STOPPING_1 = 2, STOPPING_2 = 3, RESULT = 4;
    reg [2:0] state;
    reg [1:0] target_1, target_2, target_3;
    reg [9:0] win_amount;
    
    reg btn_prev;
    wire btn_press = (!btn_spin && btn_prev);
    wire [3:0] bet_val = bet_sw + 4'd1; 
    reg [4:0] flash_timer;

    // Flash LEDs only if we are in RESULT state and won something
    assign led = (state == RESULT && win_amount > 0 && flash_timer[4]) ? 10'b1111111111 : 10'b0;

    // Flash Timer Logic
    always @(posedge clk_game or negedge rst) begin
        if (!rst) flash_timer <= 0;
        else flash_timer <= flash_timer + 1;
    end

    // Main State Machine
    always @(posedge clk_game or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            credits <= 100;
            win_amount <= 0;
            disp_1 <= 0; disp_2 <= 0; disp_3 <= 0;
            btn_prev <= 1;
        end else begin
            btn_prev <= btn_spin;

            case (state)
                IDLE: begin
                    right_val <= {6'b0, bet_val}; // Show Bet Amount
                    if (btn_press && credits >= bet_val) begin
                        credits <= credits - bet_val;
                        win_amount <= 0;
                        target_1 <= rng_1;
                        target_2 <= rng_2;
                        target_3 <= rng_3;
                        state <= SPINNING;
                    end
                end

                SPINNING: begin
                    right_val <= {6'b0, bet_val};
                    disp_1 <= disp_1 + 2'd1;
                    disp_2 <= disp_2 + 2'd1;
                    disp_3 <= disp_3 + 2'd1;
                    if (btn_press) state <= STOPPING_1;
                end

                STOPPING_1: begin
                    right_val <= {6'b0, bet_val};
                    disp_1 <= target_1;     // Lock Reel 1
                    disp_2 <= disp_2 + 2'd1;
                    disp_3 <= disp_3 + 2'd1;
                    state <= STOPPING_2;
                end
                
                STOPPING_2: begin
                    right_val <= {6'b0, bet_val};
                    disp_1 <= target_1;
                    disp_2 <= target_2;     // Lock Reel 2
                    disp_3 <= disp_3 + 2'd1;
                    
                    // Transition to RESULT
                    state <= RESULT;
                    
                    // === CHECK WIN LOGIC (Merged Here) ===
                    // We calculate the win exactly at the moment we stop the last reel.
                    if (target_1 == target_2 && target_2 == target_3) begin
                        case (target_1)
                            2'd0: begin // Cherry
                                win_amount <= bet_val * 5; 
                                credits <= credits + (bet_val * 5); 
                            end
                            2'd1: begin // Bar
                                win_amount <= bet_val * 10; 
                                credits <= credits + (bet_val * 10); 
                            end
                            2'd2: begin // Seven
                                win_amount <= bet_val * 20; 
                                credits <= credits + (bet_val * 20); 
                            end
                            2'd3: begin // Jackpot
                                win_amount <= bet_val * 50; 
                                credits <= credits + (bet_val * 50); 
                            end
                        endcase
                    end else begin
                        win_amount <= 0;
                    end
                end

                RESULT: begin
                    right_val <= win_amount; // Show Win Amount
                    disp_1 <= target_1;
                    disp_2 <= target_2;
                    disp_3 <= target_3;      // Lock Reel 3
                    
                    if (btn_press) state <= IDLE;
                end
            endcase
        end
    end
endmodule