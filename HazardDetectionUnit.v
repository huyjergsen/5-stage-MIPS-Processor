module HazardDetectionUnit(
    input [4:0] ID_EX_Rt,
    input ID_EX_MemRead,
    input [4:0] IF_ID_Rs,
    input [4:0] IF_ID_Rt,
    output reg PCWrite,
    output reg IF_ID_Write,
    output reg Stall
);
    
    always @(*) begin
        // Default: no stall
        PCWrite = 1;
        IF_ID_Write = 1;
        Stall = 0;
        
        // Load-use hazard detection
        if (ID_EX_MemRead && 
            ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt)) &&
            (ID_EX_Rt != 5'b0)) begin
            PCWrite = 0;     // Don't update PC
            IF_ID_Write = 0; // Don't update IF/ID register
            Stall = 1;       // Insert bubble (NOP) in ID/EX
        end
    end
    
endmodule