module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output Zero
);
    
    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = A & B;           // AND
            4'b0001: ALUResult = A | B;           // OR
            4'b0010: ALUResult = A + B;           // ADD
            4'b0110: ALUResult = A - B;           // SUB
            4'b0111: ALUResult = (A < B) ? 1 : 0; // SLT (Set Less Than)
            4'b1100: ALUResult = ~(A | B);        // NOR
            4'b1000: ALUResult = A << B[4:0];     // SLL (Shift Left Logical)
            4'b1001: ALUResult = A >> B[4:0];     // SRL (Shift Right Logical)
            default: ALUResult = 32'b0;
        endcase
    end
    
    assign Zero = (ALUResult == 32'b0);
    
endmodule
