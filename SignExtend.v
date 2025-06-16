module SignExtend(
    input [15:0] DataIn,
    output [31:0] DataOut
);
    
    assign DataOut = {{16{DataIn[15]}}, DataIn}; // Sign extend
    
endmodule