module Random_Number_Generator (
    input clk,
    input rst,
    input cheat_sw,
    output reg [1:0] r1,
    output reg [1:0] r2,
    output reg [1:0] r3
);
    reg [1:0] c1, c2, c3;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            c1 <= 0; c2 <= 1; c3 <= 2;
        end else begin
            c1 <= c1 + 1;
            c2 <= c2 + 1;
            c3 <= c3 + 1;
        end
    end

    always @(*) begin
        if (cheat_sw) begin
            r1 = 2'd2; r2 = 2'd2; r3 = 2'd2; 
        end else begin
            r1 = c1; r2 = c2; r3 = c3;
        end
    end
endmodule