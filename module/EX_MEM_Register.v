module EX_MEM_Register(
    input clk,
    input reset,
    input flush,
    // Control signals
    input RegWrite_In, MemtoReg_In, MemWrite_In, MemRead_In,
    input Branch_In,
    // Data
    input [31:0] BranchAddress_In,
    input Zero_In,
    input [31:0] ALUResult_In,
    input [31:0] WriteData_In,
    input [4:0] WriteReg_In,
    // Outputs
    output reg RegWrite_Out, MemtoReg_Out, MemWrite_Out, MemRead_Out,
    output reg Branch_Out,
    output reg [31:0] BranchAddress_Out,
    output reg Zero_Out,
    output reg [31:0] ALUResult_Out,
    output reg [31:0] WriteData_Out,
    output reg [4:0] WriteReg_Out
);
    
    always @(posedge clk) begin
        if (reset || flush) begin
            // Reset all control signals
            RegWrite_Out <= 0;
            MemtoReg_Out <= 0;
            MemWrite_Out <= 0;
            MemRead_Out <= 0;
            Branch_Out <= 0;
            // Reset data
            BranchAddress_Out <= 32'b0;
            Zero_Out <= 0;
            ALUResult_Out <= 32'b0;
            WriteData_Out <= 32'b0;
            WriteReg_Out <= 5'b0;
        end else begin
            // Pass through control signals
            RegWrite_Out <= RegWrite_In;
            MemtoReg_Out <= MemtoReg_In;
            MemWrite_Out <= MemWrite_In;
            MemRead_Out <= MemRead_In;
            Branch_Out <= Branch_In;
            // Pass through data
            BranchAddress_Out <= BranchAddress_In;
            Zero_Out <= Zero_In;
            ALUResult_Out <= ALUResult_In;
            WriteData_Out <= WriteData_In;
            WriteReg_Out <= WriteReg_In;
        end
    end
    
endmodule