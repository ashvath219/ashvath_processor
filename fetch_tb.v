`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2024 15:13:39
// Design Name: 
// Module Name: fetch_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fetch_tb();
reg CLK=1,RST,PC_SELECT_E;
reg [15:0]PC_BRANCH_E;
wire [15:0]INSTR_D,PC_D,PC_NEXT_D;

fetch dut(.clk(CLK),.rst(RST),.pc_select_e(PC_SELECT_E),.pc_branch_e(PC_BRANCH_E),.pc_next_d(PC_NEXT_D),.pc_d(PC_D),.instr_d(INSTR_D));

//clk generation
always begin
CLK = ~CLK;
#50;
end 

initial begin
RST <= 1'b1;
#200;
RST <= 1'b0;
PC_SELECT_E <= 1'b0;
#50
PC_BRANCH_E <= 16'h00A7;
#20
PC_SELECT_E <= 1'b1;
#500;
$finish;

end
endmodule
