module slot_machine_controller (
    input clk,
    input btn_spin,      
    input btn_reset,     
    input cheat_mode,    
    input [2:0] sw_bet,  
    input [15:0] random_seed, 
    
    output reg [2:0] symbol_left,
    output reg [2:0] symbol_right,
    output reg [9:0] leds,
    
    output wire [9:0] current_credits, 
    output wire [3:0] current_bet      
);

    // ==========================================
    // --- CONFIGURATION (EDIT TO YOUR NEEDS) ---
    // ==========================================
    // Enter a number between 0-999
	 localparam START_CREDITS = 12'd100; 
    
    // Payout Multipliers (Bet x Multiplier)
    // Note: We don't specify bits (e.g. 4'd) so it defaults to 32-bit integers
    localparam MULT_SEVEN    = 20;
    localparam MULT_CHERRY   = 5;
    localparam MULT_BAR      = 2;
    localparam MULT_QUEST    = 1;
    // ==========================================


    // --- States ---
    localparam STATE_IDLE = 2'd0;
    localparam STATE_SPIN = 2'd1;
    localparam STATE_WIN  = 2'd2; 

    // --- Timing ---
    localparam TIME_STOP_LEFT  = 28'd100_000_000; 
    localparam TIME_STOP_RIGHT = 28'd150_000_000; 
    localparam TIME_FLASH_SPD  = 28'd12_500_000; 

    reg [1:0] state;
    reg [27:0] spin_timer;      
    reg [25:0] animation_speed;
    reg [25:0] led_timer;       
    
    reg prev_spin, prev_reset;
    wire start_spin = (btn_spin && !prev_spin);
    wire do_reset   = (btn_reset && !prev_reset);
    
    reg [2:0] target_left;
    reg [2:0] target_right;
    reg [3:0] flash_count;

    // --- WALLET LOGIC ---
    reg [11:0] balance; 
    reg [3:0] active_bet; 
    
    assign current_credits = balance[9:0];
    assign current_bet = {1'b0, sw_bet} + 4'd1;

    initial begin
        balance = START_CREDITS;
    end

    always @(posedge clk) begin
        prev_spin  <= btn_spin;
        prev_reset <= btn_reset;

        if (do_reset) begin
            balance <= START_CREDITS; 
            state <= STATE_IDLE;
            leds <= 10'b0;
        end 
        else case (state)
            // --- IDLE STATE ---
            STATE_IDLE: begin
                leds <= 10'b0; 
                
                if (start_spin) begin
                    if (balance >= current_bet) begin
                        active_bet <= current_bet;       
                        balance <= balance - current_bet; 
                        
                        state <= STATE_SPIN;
                        spin_timer <= 0;
                        animation_speed <= 0;
                        led_timer <= 0;
                        leds <= 10'b1000000000; 
                        
                        target_left <= random_seed[1:0]; 
                        if (cheat_mode) target_right <= random_seed[1:0]; 
                        else target_right <= random_seed[3:2]; 
                    end
                end
            end

            // --- SPIN STATE ---
            STATE_SPIN: begin
                spin_timer <= spin_timer + 1;

                if (animation_speed < 26'd5_000_000) animation_speed <= animation_speed + 1;
                else begin
                    animation_speed <= 0;
                    if (spin_timer < TIME_STOP_LEFT) 
                        if (symbol_left >= 3'd3) symbol_left <= 0; else symbol_left <= symbol_left + 1;
                    if (spin_timer < TIME_STOP_RIGHT) 
                        if (symbol_right >= 3'd3) symbol_right <= 0; else symbol_right <= symbol_right + 1;
                end

                if (led_timer < 26'd2_500_000) led_timer <= led_timer + 1;
                else begin
                    led_timer <= 0;
                    leds <= {leds[0], leds[9:1]}; 
                end

                if (spin_timer == TIME_STOP_LEFT) symbol_left <= target_left;
                
                if (spin_timer >= TIME_STOP_RIGHT) begin
                    symbol_right <= target_right;
                    if (target_left == target_right) begin
                        state <= STATE_WIN;
                        spin_timer <= 0;
                        flash_count <= 0;
                        leds <= 10'b1111111111; 
                    end else begin
                        state <= STATE_IDLE; 
                    end
                end
            end

            // --- WIN STATE ---
            STATE_WIN: begin
                spin_timer <= spin_timer + 1;
                
                if (spin_timer >= TIME_FLASH_SPD) begin
                    spin_timer <= 0;
                    leds <= ~leds; 
                    
                    if (leds[0] == 1'b1) begin 
                        if (flash_count < 3) begin
                            flash_count <= flash_count + 1;
                        end else begin
                            state <= STATE_IDLE;
                            
                            // --- PAYOUT LOGIC (Expanded Safe Math) ---
                            // We use a temporary 16-bit wire implicitly to handle the large multiplication
                            // before capping it to 12-bit balance.
                            case (target_left)
                                3'd0: begin // SEVEN
                                    if ((balance + (active_bet * MULT_SEVEN)) > 12'd999) balance <= 12'd999;
                                    else balance <= balance + (active_bet * MULT_SEVEN);
                                end
                                3'd1: begin // CHERRY
                                    if ((balance + (active_bet * MULT_CHERRY)) > 12'd999) balance <= 12'd999;
                                    else balance <= balance + (active_bet * MULT_CHERRY);
                                end
                                3'd2: begin // BAR
                                    if ((balance + (active_bet * MULT_BAR)) > 12'd999) balance <= 12'd999;
                                    else balance <= balance + (active_bet * MULT_BAR);
                                end
                                3'd3: begin // QUESTION MARK
                                    if ((balance + (active_bet * MULT_QUEST)) > 12'd999) balance <= 12'd999;
                                    else balance <= balance + (active_bet * MULT_QUEST);
                                end
                                default: balance <= balance;
                            endcase
                        end
                    end
                end
            end
        endcase
    end
endmodule