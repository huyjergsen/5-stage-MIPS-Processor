module Mux31 #(parameter WIDTH = 32)(
    input [WIDTH-1:0] Input0,
    input [WIDTH-1:0] Input1,
    input [WIDTH-1:0] Input2,
    input [1:0] Select,
    output reg [WIDTH-1:0] Output
);
    
    always @(*) begin
        case (Select)
            2'b00: Output = Input0;
            2'b01: Output = Input1;
            2'b10: Output = Input2;
            default: Output = Input0;
        endcase
    end
    
endmodule