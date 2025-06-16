module ALUControl(
    input [1:0] ALUOp,
    input [5:0] Funct,
    output reg [3:0] ALUControlOut
);
    
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControlOut = 4'b0010; // LW/SW: ADD
            2'b01: ALUControlOut = 4'b0110; // BEQ: SUB
            2'b10: begin // R-type instructions
                case (Funct)
                    6'b100000: ALUControlOut = 4'b0010; // ADD
                    6'b100010: ALUControlOut = 4'b0110; // SUB
                    6'b100100: ALUControlOut = 4'b0000; // AND
                    6'b100101: ALUControlOut = 4'b0001; // OR
                    6'b101010: ALUControlOut = 4'b0111; // SLT
                    6'b000000: ALUControlOut = 4'b1000; // SLL
                    6'b000010: ALUControlOut = 4'b1001; // SRL
                    6'b100111: ALUControlOut = 4'b1100; // NOR
                    default:   ALUControlOut = 4'b0010; // Default ADD
                endcase
            end
            default: ALUControlOut = 4'b0010; // Default ADD
        endcase
    end
    
endmodule