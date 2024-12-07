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