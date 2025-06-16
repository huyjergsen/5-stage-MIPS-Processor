module InstructionMemory(
    input [31:0] Address,
    output reg [31:0] Instruction
);
    
    reg [31:0] Memory [0:1023]; // 1024 words of instruction memory
    
    initial begin
        // Initialize with some test instructions or load from file
          $readmemh("D:/HDL UIT/DoAn/code.txt", Memory);
    end
    
    always @(*) begin
        if (Address[31:2] < 1024)
            Instruction = Memory[Address[31:2]]; // Word addressing
        else
            Instruction = 32'b0; // NOP for out of bounds
    end
    
endmodule