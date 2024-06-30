`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2024 02:42:31
// Design Name: 
// Module Name: fetch
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


module fetch(clk,rst,pc_select_e,pc_branch_e,pc_next_d,pc_d,instr_d);
//inputs outputs
input clk,rst,pc_select_e;
input [15:0] pc_branch_e;
output [15:0] pc_next_d,pc_d,instr_d;

//wires
wire[15:0] mux_to_pc,pc_next_f,instr_f;
reg[15:0]pc_to_instrmem;

//register buffer
reg [15:0]instr_reg_f; //instr from fetch pipe
reg [15:0]pc_to_instrmem_reg_f; //curent PC value to fetch instr from memory
reg [15:0]pc_next_reg_f; //next calculated PC value 

//MUX
assign mux_to_pc = (pc_select_e==0)? pc_next_f:pc_branch_e; // choses between next PC value and branch PC value

//PC
//this block sets the curent PC value to 0 if reset
always@(posedge clk)
begin
if(rst)pc_to_instrmem <={16{1'b0}};
else pc_to_instrmem <= mux_to_pc;
end

//Memory for Instruction
 /*initial begin
    //mem[0] = 32'hFFC4A303;
    //mem[1] = 32'h00832383;
    // mem[0] = 32'h0064A423;
     //mem[1] = 32'h00B6;
    //mem[0] = 32'h0062;
    // mem[1] = 32'h00B62423;

 end
*/
//output is instrd and input is pc_to_instrmem
reg [15:0]mem[1023:0];
assign instr_f = (rst) ? {32{1'b0}}:mem[pc_to_instrmem[15:1]]; //accessign memory for instr

//PC Adder
assign pc_next_f = pc_to_instrmem + 16'h0002; //normal operation no branching

//Fetch cycle register update 
//The inputs and outputs to the register are assumed to be nets
always@(posedge clk or negedge rst)begin
if(rst==1'b1)begin    //resets all the registers to 0 in case of reset 
instr_reg_f <= 16'h0000;
pc_to_instrmem_reg_f <= 16'h0000;
pc_next_reg_f <= 16'h0000;
end

else begin
instr_reg_f <= instr_f;
pc_to_instrmem_reg_f <= pc_to_instrmem;
pc_next_reg_f <= pc_next_f;
end
end 

//assigning reg values to output ports
assign pc_next_d = pc_next_reg_f;
assign pc_d = pc_to_instrmem_reg_f;
assign instr_d = instr_reg_f;
endmodule
