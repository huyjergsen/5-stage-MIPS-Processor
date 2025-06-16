module MEM_WB_Register(
    input clk,
    input reset,
    input flush,
    // Control signals
    input RegWrite_In, MemtoReg_In,
    // Data
    input [31:0] ReadData_In,
    input [31:0] ALUResult_In,
    input [4:0] WriteReg_In,
    // Outputs
    output reg RegWrite_Out, MemtoReg_Out,
    output reg [31:0] ReadData_Out,
    output reg [31:0] ALUResult_Out,
    output reg [4:0] WriteReg_Out
);
    
    always @(posedge clk) begin
        if (reset || flush) begin
            // Reset all control signals
            RegWrite_Out <= 0;
            MemtoReg_Out <= 0;
            // Reset data
            ReadData_Out <= 32'b0;
            ALUResult_Out <= 32'b0;
            WriteReg_Out <= 5'b0;
        end else begin
            // Pass through control signals
            RegWrite_Out <= RegWrite_In;
            MemtoReg_Out <= MemtoReg_In;
            // Pass through data
            ReadData_Out <= ReadData_In;
            ALUResult_Out <= ALUResult_In;
            WriteReg_Out <= WriteReg_In;
        end
    end
    
endmodule