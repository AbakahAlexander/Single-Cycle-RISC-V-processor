
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












