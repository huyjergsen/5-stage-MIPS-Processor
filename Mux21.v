module Mux21 #(parameter WIDTH = 32)(
    input [WIDTH-1:0] Input0,
    input [WIDTH-1:0] Input1,
    input Select,
    output [WIDTH-1:0] Output
);
    
    assign Output = Select ? Input1 : Input0;
    
endmodule