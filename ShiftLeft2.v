module ShiftLeft2(
    input [31:0] DataIn,
    output [31:0] DataOut
);
    
    assign DataOut = {DataIn[29:0], 2'b00}; // Shift left by 2 positions
    
endmodule