module ControlUnit(
    input [5:0] Opcode,
    output reg RegWrite,
    output reg MemtoReg,
    output reg MemWrite,
    output reg MemRead,
    output reg Branch,
    output reg ALUSrc,
    output reg RegDst,
    output reg Jump,
    output reg [1:0] ALUOp
);
    
    always @(*) begin
        // Default values
        RegWrite = 0; MemtoReg = 0; MemWrite = 0; MemRead = 0;
        Branch = 0; ALUSrc = 0; RegDst = 0; Jump = 0; ALUOp = 2'b00;
        
        case (Opcode)
            6'b000000: begin // R-type
                RegWrite = 1; RegDst = 1; ALUOp = 2'b10;
            end
            6'b100011: begin // LW (Load Word)
                RegWrite = 1; MemtoReg = 1; ALUSrc = 1; MemRead = 1; ALUOp = 2'b00;
            end
            6'b101011: begin // SW (Store Word)
                MemWrite = 1; ALUSrc = 1; ALUOp = 2'b00;
            end
            6'b000100: begin // BEQ (Branch Equal)
                Branch = 1; ALUOp = 2'b01;
            end
            6'b001000: begin // ADDI (Add Immediate)
                RegWrite = 1; ALUSrc = 1; ALUOp = 2'b00;
            end
            6'b000010: begin // J (Jump)
                Jump = 1;
            end
            default: begin
                // All control signals remain 0
            end
        endcase
    end
    
endmodule