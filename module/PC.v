module PC(
    input clk,
    input reset,
    input [31:0] NextPC,
    output reg [31:0] CurrentPC
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            CurrentPC <= 32'hFFFFFFFC;
        else
            CurrentPC <= NextPC;
    end

endmodule