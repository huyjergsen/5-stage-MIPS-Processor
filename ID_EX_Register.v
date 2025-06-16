module ID_EX_Register(
    input clk,
    input reset,
    input flush,
    // Control signals
    input RegWrite_In, MemtoReg_In, MemWrite_In, MemRead_In,
    input Branch_In, ALUSrc_In, RegDst_In,
    input [1:0] ALUOp_In,
    // Data
    input [31:0] PC_In,
    input [31:0] ReadData1_In, ReadData2_In,
    input [31:0] SignExtImm_In,
    input [4:0] Rs_In, Rt_In, Rd_In,
    input [5:0] Funct_In,
    // Outputs
    output reg RegWrite_Out, MemtoReg_Out, MemWrite_Out, MemRead_Out,
    output reg Branch_Out, ALUSrc_Out, RegDst_Out,
    output reg [1:0] ALUOp_Out,
    output reg [31:0] PC_Out,
    output reg [31:0] ReadData1_Out, ReadData2_Out,
    output reg [31:0] SignExtImm_Out,
    output reg [4:0] Rs_Out, Rt_Out, Rd_Out,
    output reg [5:0] Funct_Out
);
    always @(posedge clk) begin
        if (reset || flush) begin
            // Reset all control signals
            RegWrite_Out <= 0; MemtoReg_Out <= 0; MemWrite_Out <= 0;
            MemRead_Out <= 0; Branch_Out <= 0; ALUSrc_Out <= 0;
            RegDst_Out <= 0; ALUOp_Out <= 2'b0;
            // Reset data
            PC_Out <= 32'b0; ReadData1_Out <= 32'b0; ReadData2_Out <= 32'b0;
            SignExtImm_Out <= 32'b0; Rs_Out <= 5'b0; Rt_Out <= 5'b0;
            Rd_Out <= 5'b0; Funct_Out <= 6'b0;
        end else begin
            // Pass through control signals
            RegWrite_Out <= RegWrite_In; MemtoReg_Out <= MemtoReg_In;
            MemWrite_Out <= MemWrite_In; MemRead_Out <= MemRead_In;
            Branch_Out <= Branch_In; ALUSrc_Out <= ALUSrc_In;
            RegDst_Out <= RegDst_In; ALUOp_Out <= ALUOp_In;
            // Pass through data
            PC_Out <= PC_In; ReadData1_Out <= ReadData1_In;
            ReadData2_Out <= ReadData2_In; SignExtImm_Out <= SignExtImm_In;
            Rs_Out <= Rs_In; Rt_Out <= Rt_In; Rd_Out <= Rd_In;
            Funct_Out <= Funct_In;
        end
    end
    
endmodule