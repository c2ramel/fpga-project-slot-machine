module Random_Number_Generator (
    input clk,
    input rst,
    input cheat_sw,
    output [1:0] r1,
    output [1:0] r2,
    output [1:0] r3
);
    // 16-bit Linear Feedback Shift Register (LFSR)
    // Polynomial: x^16 + x^14 + x^13 + x^11 + 1
    reg [15:0] lfsr;

    wire feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            lfsr <= 16'hACE1; // Seed must not be zero
        end else begin
            lfsr <= {lfsr[14:0], feedback}; // Shift left, insert feedback
        end
    end

    // Slice the LFSR to get 3 independent 2-bit values
    assign r1 = (cheat_sw) ? 2'd2 : lfsr[1:0];
    assign r2 = (cheat_sw) ? 2'd2 : lfsr[5:4];
    assign r3 = (cheat_sw) ? 2'd2 : lfsr[9:8];

endmodule
