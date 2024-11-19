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

//Instruction Memory

module instruction_memory(clk, reset, read_address, instruction);

input clk, reset;
input [31:0] read_address;
output reg [31:0] instruction;

reg [31:0] I_mem[63:0];
integer i;

always @(posedge clk or posedge reset)
begin
if (reset)
    begin
        for(i=0; i<64; i= i + 1)begin
            I_mem[i] <= 32'b00;
        end
    end
else

    //R-type
    I_mem[0] = 32'b0000000000000000000000000000000; //no operation
    I_mem[4] = 32'b0000000_11001_10000_000_01101_0110011; //add x13 , x16, x25
    I_mem[8] = 32'b0100000_00011_01000_000_00101_0110011;  //sub x5, x8, x3
    I_mem[12] = 32'b0000000_00011_00010_111_00001_0110011;  //and x1, x2, x3
    I_mem[16] = 32'b0000000_00101_00011_110_00100_0110011;  // or x4, x3, x5
    
    //I-type
    I_mem[20] = 32'b000000000011_10101_000_10110_0010011;  //addi x22, x21, 3
    I_mem[24] = 32'b000000000001_01000_110_01001_0010011;   //ori x9, x8, 1
    
    //L-type
    I_mem[28] = 32'b000000001111_00101_010_01000_0000011; //lw x8, 15(x5)
    I_mem[32] = 32'b000000000011_00011_010_01001_0000011;  //lw x9, 3(x3)
    
    //S-type
    I_mem[36] = 32'b0000000_01111_00101_010_01100_0100011; //sw, x15, 12(x5)
    I_mem[40] = 32'b0000000_01110_00110_010_01010_0100011;   //sw x14, 10(x6)
    
    //SB-type
    I_mem[44] = 32'h00948663; //beq x9, x9, 12
end    
endmodule 


//Register file
module register_file(clk, reset, rs1, rs2, rd, regwrite, writedata, read_data1, read_data2);
input clk, reset, regwrite;
input [4:0] rs1, rs2, rd;
input [31:0] writedata;
output [31:0] read_data1, read_data2;

reg [31:0] registers[31:0];

initial begin
registers[0] = 0;
registers[1] = 4;
registers[2] = 2;
registers[3] = 24;
registers[4] = 4;
registers[5] = 1;
registers[6] = 44;
registers[7] = 4;
registers[8] = 2;
registers[9] = 1;
registers[10] = 23;
registers[11] = 4;
registers[12] = 90;
registers[13] = 10;
registers[14] = 20;
registers[15] = 30;
registers[16] = 40;
registers[17] = 50;
registers[18] = 60;
registers[19] = 70;
registers[20] = 80;
registers[21] = 80;
registers[22] = 90;
registers[23] = 70;
registers[24] = 60;
registers[25] = 65;
registers[26] = 4;
registers[27] = 32;
registers[28] = 12;
registers[29] = 34;
registers[30] = 5;
registers[31] = 10;
end

integer i;

always @(posedge clk or posedge reset)
begin
if (reset)
    begin
        for(i=0;i<32;i=i+1)begin
            registers[i] <= 32'b00;
        end
     end
else if (regwrite)begin
    registers[rd] <= writedata;
end
end

assign read_data1 = rs1;
assign read_data2 = rs2;

endmodule


//Immediate generator 

module immediate_gen(opcode, instruction, ImmExt);
input [6:0] opcode;
input [31:0] instruction;
output reg [31:0] ImmExt; 

always @(*)
begin
    case (opcode)
    7'b0000011 : ImmExt <= {{20{instruction[31]}}, instruction[31:20]};
    7'b0100011 : ImmExt <=  {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
    7'b1100011 : ImmExt <= {{19{instruction[31]}}, instruction[31], instruction[30:25], instruction[11:8], 1'b0};
    endcase 
end
endmodule

//control_unit
module control_unit(instruction, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
input [6:0] instruction;
output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
output reg [1:0] ALUOp;

always @(*)
begin
    case(instruction)
    7'b0110011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b001000_10;
    7'b0110011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b111100_00;
    7'b0110011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b100010_00;
    7'b0110011 : {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= 8'b000001_01;
    endcase
end

endmodule 

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

//ALU control

module ALU_Control(ALUOp, fun7, fun3, Control_out);

input fun7;
input [2:0] fun3;
input [1:0] ALUOp;
output reg [3:0] Control_out;

always @(*)
begin
    case({ALUOp, fun7, fun3})
    6'b00_0_000: Control_out <= 4'b0010;
    6'b01_0_000: Control_out <= 4'b0110;
    6'b10_0_000: Control_out <= 4'b0010;
    6'b10_1_000: Control_out <= 4'b0110;
    6'b10_0_111: Control_out <= 4'b0000;
    6'b10_0_110: Control_out <= 4'b0000;
    endcase
end
endmodule 

//Data Memory

module Data_Memory(clk, reset, MemWrite, MemRead, read_address, Write_data, MemData_out);
input clk,reset, MemWrite, MemRead;
input [31:0] read_address, Write_data;
output [31:0] MemData_out;

reg [31:0] D_Memory [63:0];
integer i;

always @(posedge clk or posedge reset)
begin
if(reset)
    begin
        for(i=0; i<64; i = i + 1)begin
        D_Memory[i] = 32'b00;
        end
    end
else if(MemWrite)begin
    D_Memory[read_address] <= Write_data;
    end
end

assign MemData_out = (MemRead) ? D_Memory[read_address] : 32'b00;

endmodule

//Multiplexers

module mux1(sel1, A1, B1, Mux_out1);
input sel1;
input [31:0] A1, B1;
output [31:0] Mux_out1;

assign Mux_out1 = (sel1 == 1'b0) ? A1 : B1;
endmodule


//Mux 2
module mux2(sel2, A2, B2, Mux_out2);
input sel2;
input [31:0] A2, B2;
output [31:0] Mux_out2;

assign Mux_out2 = (sel2 == 1'b0) ? A2 : B2;
endmodule


//Mux 3
 module mux3(sel3, A3, B3, Mux_out3);
input sel3;
input [31:0] A3, B3;
output [31:0] Mux_out3;

assign Mux_out3 = (sel3 == 1'b0) ? A3 : B3;
endmodule

//AND logic

module and_logic(branch, zero, and_out);
input branch, zero;
output and_out;

assign and_out = branch & zero;

endmodule

//adder

module adder(in_1, in_2, sum_out);
input [31:0] in_1, in_2;
output [31:0] sum_out;

assign sum_out = in_1 + in_2;

endmodule 

//All modules instantiate here

module top(clk, reset);
input clk, reset;

wire [31:0] PC_top, instruction_top, Rd1_top, Rd2_top, ImmExt_top, mux1_top, sum_out_top, nexttopc_top,PCin_top, address_top, Memdata_top, WriteBack_top ;
wire regwrite_top, ALUSrc_top, zero_top, branch_top, sel2_top, MemtoReg_top, MemWrite_top, MemRead_top;
wire [1:0] ALUOp_top;
wire [3:0] control_top;

//Program counter
program_counter PC(.clk(clk), .reset(reset), .pc_in(PCin_top), .pc_out(PC_top));

//PC adder
adder4 PC_adder(.frompc(PC_top), .nexttopc(nexttopc_top));


//Instruction Memory
instruction_memory Inst_Memory(.clk(clk), .reset(reset), .read_address(PC_top), .instruction(instruction_top));

//Register file
register_file Reg_File(.clk(clk), .reset(reset), .rs1(instruction_top[19:15]), .rs2(instruction_top[24:20]), .rd(instruction_top[11:7]), .regwrite(regwrite_top), .writedata(WriteBack_top), .read_data1(Rd1_top), .read_data2(Rd2_top));

//Immediate Generator
immediate_gen ImmGen(.opcode(instruction_top[6:0]), .instruction(instruction_top), .ImmExt(ImmExt_top));

//Control Unit
control_unit control_unit(.instruction(instruction_top[6:0]), .Branch(branch_top), .MemRead(MemRead_top), .MemtoReg(MemtoReg_top), .ALUOp(ALUOp_top), .MemWrite(MemWrite_top), .ALUSrc(ALUSrc_top), .RegWrite(regwrite_top));


//ALU control unit
ALU_Control ALU_Control(.ALUOp(ALUOp_top), .fun7(instruction_top[30]), .fun3(instruction_top[14:12]), .Control_out(control_top));

//ALU
alu_unit ALU(.A(Rd1_top), .B(mux1_top), .control_in(control_top), .ALU_result(address_top), .zero(zero_top));

//ALU Mux
mux1 ALU_mux(.sel1(ALUSrc_top), .A1(Rd2_top), .B1(ImmExt_top), .Mux_out1(mux1_top));

//Adder
adder adder(.in_1(PC_top), .in_2(ImmExt_top), .sum_out(sum_out_top));

//And gate
and_logic and_logic(.branch(branch_top), .zero(zero_top), .and_out(sel2_top));

//Mux
mux2 Adder_mux(.sel2(sel2_top), .A2(nexttopc_top), .B2(sum_out_top), .Mux_out2(PCin_top));

//Data Memory
Data_Memory Data_mem(.clk(clk), .reset(reset), .MemWrite(MemWrite_top), .MemRead(MemRead_top), .read_address(address_top), .Write_data(Rd2_top), .MemData_out(Memdata_top));

//Mux
mux3 Memory_mux(.sel3(MemtoReg_top), .A3(address_top), .B3(Memdata_top), .Mux_out3(WriteBack_top));

endmodule

//test_bench
module tb_top;

reg clk, reset;

top uut(.clk(clk), .reset(reset));

initial begin
clk = 0;
reset = 1;
#5;

reset = 0;
#400;
end

always begin 
#5 clk = ~clk;
end 




endmodule 












