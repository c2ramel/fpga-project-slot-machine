module debounce (
    input clk,
    input btn_in,     // Raw button input (Active Low)
    output reg state  // Cleaned output (1 = Pressed/Active)
);
    reg [19:0] count;
    reg last_btn;

    always @(posedge clk) begin
        if (btn_in == last_btn) begin
            if (count < 20'd999_999) count <= count + 1;
            else state <= ~btn_in; // Invert so 1 = Pressed
        end else begin
            count <= 0;
            last_btn <= btn_in;
        end
    end
endmodule