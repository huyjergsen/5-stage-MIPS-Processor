module RegisterFile(
    input clk,
    input reset,
    input RegWrite,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2, 
    input [4:0] WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2,
    // Thêm output cho các thanh ghi $t0-$t7 (registers 8-15)
    output [31:0] reg_t0_out,   // Register 8  ($t0)
    output [31:0] reg_t1_out,   // Register 9  ($t1)
    output [31:0] reg_t2_out,   // Register 10 ($t2)
    output [31:0] reg_t3_out,   // Register 11 ($t3)
    output [31:0] reg_t4_out,   // Register 12 ($t4)
    output [31:0] reg_t5_out,   // Register 13 ($t5)
    output [31:0] reg_t6_out,   // Register 14 ($t6)
    output [31:0] reg_t7_out    // Register 15 ($t7)
);

    // Separate array for registers 1-31 (register 0 is always 0)
    reg [31:0] Registers [1:31];
    integer i;
    
    // Write operation and reset (synchronous)
    always @(posedge clk) begin
        if (reset) begin
            for (i = 1; i < 32; i = i + 1)
                Registers[i] <= 32'b0;
        end
        else if (RegWrite && WriteReg != 5'b0) // Register 0 is always 0
            Registers[WriteReg] <= WriteData;
    end
    
    // Read operations (asynchronous)
    assign ReadData1 = (ReadReg1 == 5'b0) ? 32'b0 : Registers[ReadReg1];
    assign ReadData2 = (ReadReg2 == 5'b0) ? 32'b0 : Registers[ReadReg2];
    
    // Output các thanh ghi $t0-$t7
    assign reg_t0_out = Registers[8];   // $t0
    assign reg_t1_out = Registers[9];   // $t1
    assign reg_t2_out = Registers[10];  // $t2
    assign reg_t3_out = Registers[11];  // $t3
    assign reg_t4_out = Registers[12];  // $t4
    assign reg_t5_out = Registers[13];  // $t5
    assign reg_t6_out = Registers[14];  // $t6
    assign reg_t7_out = Registers[15];  // $t7
    
endmodule