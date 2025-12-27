module FSM (
    input clk,          // 50 MHz
    input tick_game,    // 15Hz Enable Pulse
    input rst,          
    input btn_spin,     
    input [2:0] bet_sw, 
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
    // Edge detection must happen inside the tick to be consistent with game speed
    wire btn_press = (!btn_spin && btn_prev);
    wire [3:0] bet_val = bet_sw + 4'd1; 
    reg [4:0] flash_timer;

    assign led = (state == RESULT && win_amount > 0 && flash_timer[4]) ? 10'b1111111111 : 10'b0;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            credits <= 100;
            win_amount <= 0;
            disp_1 <= 0; disp_2 <= 0; disp_3 <= 0;
            btn_prev <= 1;
            flash_timer <= 0;
        end else if (tick_game) begin
            // Sample button at 15Hz (Implicit Debouncing)
            btn_prev <= btn_spin;
            
            // Flash timer runs continuously
            flash_timer <= flash_timer + 1;

            case (state)
                IDLE: begin
                    right_val <= {6'b0, bet_val}; 
                    if (btn_press && credits >= bet_val) begin
                        credits <= credits - bet_val;
                        win_amount <= 0;
                        // Capture Targets instantly
                        target_1 <= rng_1;
                        target_2 <= rng_2;
                        target_3 <= rng_3;
                        state <= SPINNING;
                    end
                end

                SPINNING: begin
                    right_val <= {6'b0, bet_val};
                    disp_1 <= disp_1 + 1;
                    disp_2 <= disp_2 + 1;
                    disp_3 <= disp_3 + 1;
                    if (btn_press) state <= STOPPING_1;
                end

                STOPPING_1: begin
                    right_val <= {6'b0, bet_val};
                    
                    // Logic: Keep spinning Reel 1 until it hits target
                    if (disp_1 != target_1) begin
                        disp_1 <= disp_1 + 1;
                    end
                    
                    disp_2 <= disp_2 + 1;
                    disp_3 <= disp_3 + 1;

                    // Only advance state if Reel 1 has reached target
                    if (disp_1 == target_1) begin
                        state <= STOPPING_2;
                    end
                end
                
                STOPPING_2: begin
                    right_val <= {6'b0, bet_val};
                    // Reel 1 is locked
                    
                    // Logic: Keep spinning Reel 2 until it hits target
                    if (disp_2 != target_2) begin
                        disp_2 <= disp_2 + 1;
                    end
                    
                    disp_3 <= disp_3 + 1;
                    
                    // Only advance state if Reel 2 has reached target
                    if (disp_2 == target_2) begin
                        state <= RESULT;
                        
                        // Calculate Win immediately
                        if (target_1 == target_2 && target_2 == target_3) begin
                            case (target_1)
                                2'd0: begin win_amount <= bet_val * 5;  credits <= credits + (bet_val * 5); end
                                2'd1: begin win_amount <= bet_val * 10; credits <= credits + (bet_val * 10); end
                                2'd2: begin win_amount <= bet_val * 20; credits <= credits + (bet_val * 20); end
                                2'd3: begin win_amount <= bet_val * 50; credits <= credits + (bet_val * 50); end
                            endcase
                        end else begin
                            win_amount <= 0;
                        end
                    end
                end

                RESULT: begin
                    right_val <= win_amount; 
                    // All reels locked
                    disp_1 <= target_1;
                    disp_2 <= target_2;
                    disp_3 <= target_3;      
                    
                    if (btn_press) state <= IDLE;
                end
            endcase
        end
    end
    
endmodule
