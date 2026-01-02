module lfsr (
    input clk,
    output reg [15:0] random_out
);
    always @(posedge clk) begin
        // Init to non-zero value if reset (or just start non-zero)
        if (random_out == 0) 
            random_out <= 16'hACE1;
        else begin
            // Tap configuration for 16-bit LFSR: x^16 + x^14 + x^13 + x^11 + 1
            // We XOR specific bits and shift left.
            random_out <= {random_out[14:0], 
                           random_out[15] ^ random_out[13] ^ random_out[12] ^ random_out[10]};
        end
    end
endmodule