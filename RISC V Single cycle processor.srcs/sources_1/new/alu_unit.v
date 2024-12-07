//ALU

module alu_unit(A, B, control_in, ALU_result, zero);
input [31:0] A, B;
input [3:0] control_in;
output reg [31:0] ALU_result;
output reg zero;

always @(A or B or control_in)
begin
    case(control_in)
    4'b0000: begin zero <= 0; ALU_result <= A & B; end
    4'b0010: begin zero <= 0; ALU_result <= A | B; end
    4'b0010: begin zero <= 0; ALU_result <= A + B; end
    4'b0110: begin if (A==B) zero <= 1; else zero <= 0; ALU_result <= A - B; end
    endcase
end 
endmodule 