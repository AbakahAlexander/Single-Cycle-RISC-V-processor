//Program counter

module program_counter(clk, reset, pc_in, pc_out);

input clk, reset;
input [31:0] pc_in;
output reg [31:0] pc_out;

always @(posedge clk or posedge reset)
begin

if (reset)
    pc_out <= 32'b00;
else
    pc_out <= pc_in;
end 
    
endmodule 

//PC + 4 (This calculate the next instruction

module adder4(frompc, nexttopc);

input [31:0] frompc;
output [31:0] nexttopc;

assign nexttopc = frompc + 4;

endmodule 