`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// 
// Create Date:    03:37:05 10/07/2022 
// Design Name:  	 
// Module Name:    PE_32b_str 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// AYUSH GUPTA
// 32 to 5 Priority Encoder designed using cascaded 8-to-3 Priority Encoders with Active Low Inputs

module PE_32b_str
(
	input wire [31:0] I_low,
	input wire        En_low,
	output     [4:0]  Y,
	output 		      GS
	// output 		      En_O_low
);

wire En_O_low; 

// 1st Stage Priority Encoder [Highest Priority Bits i.e. MSBs]
wire [2:0] P3_op;
wire P3_GS;
wire P3_En_O;

PE_8b_bh PE3(I_low[31:24], En_low, P3_op[2:0], P3_GS, P3_En_O);

// 2nd Stage Priority Encoder
wire [2:0] P2_op;
wire P2_GS;
wire P2_En_O;

PE_8b_bh PE2(I_low[23:16], P3_En_O, P2_op[2:0], P2_GS, P2_En_O);

// 3rd Stage Priority Encoder
wire [2:0] P1_op;
wire P1_GS;
wire P1_En_O;

PE_8b_bh PE1(I_low[15:8], P2_En_O, P1_op[2:0], P1_GS, P1_En_O);

// 4th Stage Priority Encoder [Lowest Priority Bits i.e. LSBs]
wire [2:0] P0_op;
wire P0_GS;

PE_8b_bh PE0(I_low[7:0], P1_En_O, P0_op[2:0], P0_GS, En_O_low);

// Calculating Output Bits

assign Y[4] = ~(P3_GS & P2_GS);
assign Y[3] = ~(P3_GS & P1_GS);
assign Y[2] = ~(P3_op[2] & P2_op[2] & P1_op[2] & P0_op[2]);
assign Y[1] = ~(P3_op[1] & P2_op[1] & P1_op[1] & P0_op[1]);
assign Y[0] = ~(P3_op[0] & P2_op[0] & P1_op[0] & P0_op[0]);

// Calculating Output Group Select [GS]
assign GS = ~(P3_GS & P2_GS & P1_GS & P0_GS);

endmodule
