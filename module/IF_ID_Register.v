	module IF_ID_Register(
    input clk,
    input reset,
    input flush,
    input stall,
    input [31:0] PC_In,
    input [31:0] Instruction_In,
    output reg [31:0] PC_Out,
    output reg [31:0] Instruction_Out
);
    
    always @(posedge clk) begin
        if (reset || flush) begin
            PC_Out <= 32'b0;
            Instruction_Out <= 32'b0;
        end else if (!stall) begin
            PC_Out <= PC_In;
            Instruction_Out <= Instruction_In;
        end
    end
    
endmodule