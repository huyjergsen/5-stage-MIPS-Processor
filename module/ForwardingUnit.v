module ForwardingUnit(
    input [4:0] ID_EX_Rs,
    input [4:0] ID_EX_Rt,
    input [4:0] EX_MEM_Rd,
    input [4:0] MEM_WB_Rd,
    input EX_MEM_RegWrite,
    input MEM_WB_RegWrite,
    output reg [1:0] ForwardA,
    output reg [1:0] ForwardB
);
    
    always @(*) begin
        // Default: no forwarding
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        
        // EX hazard (MEM stage result to EX stage)
        if (EX_MEM_RegWrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rs))
            ForwardA = 2'b10;
        if (EX_MEM_RegWrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rt))
            ForwardB = 2'b10;
            
        // MEM hazard (WB stage result to EX stage)
        if (MEM_WB_RegWrite && (MEM_WB_Rd != 5'b0) && 
            !(EX_MEM_RegWrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rs)) &&
            (MEM_WB_Rd == ID_EX_Rs))
            ForwardA = 2'b01;
            
        if (MEM_WB_RegWrite && (MEM_WB_Rd != 5'b0) && 
            !(EX_MEM_RegWrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rt)) &&
            (MEM_WB_Rd == ID_EX_Rt))
            ForwardB = 2'b01;
    end
    
endmodule