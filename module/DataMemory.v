module DataMemory(
    input clk,
    input MemWrite,
    input MemRead,
    input [31:0] Address,
    input [31:0] WriteData,
    output reg [31:0] ReadData
);
    
    reg [31:0] Memory [0:1023]; // 1024 words of data memory
    integer i; 
    // Initialize memory
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            Memory[i] = 32'b0;
    end
    
    always @(posedge clk) begin
        if (MemWrite && Address[31:2] < 1024) begin
            Memory[Address[31:2]] <= WriteData; // Word addressing
        end
    end
    
    always @(*) begin
        if (MemRead && Address[31:2] < 1024)
            ReadData = Memory[Address[31:2]];
        else
            ReadData = 32'b0;
    end
    
endmodule