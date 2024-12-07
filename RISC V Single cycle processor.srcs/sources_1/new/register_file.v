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