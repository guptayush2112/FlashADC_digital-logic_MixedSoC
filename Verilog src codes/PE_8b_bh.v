`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:01:34 10/06/2022 
// Design Name: 
// Module Name:    PE_8b_bh 
// Project Name: 
// Target Devices: 
// Tool versions: 
// DescrItion: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PE_8b_bh(
	input  	  [7:0] I_low,
	input 	        En_low,
	output reg [2:0] Y_low,
	output reg       GS_low,
	output reg       Enop_low
	);

reg [7:0] I;
reg [2:0] Y;
reg En, GS, Enop;
integer n;

always @(I or I_low or En or En_low or Y or GS or Enop)
begin
	// Active-low Input Pins
	I    = ~I_low;
	En   = ~En_low;

	// Default Values of Encoder Outputs when
	// En = 0 and I = 1
	Y = 0; GS = 0; Enop = 1;
	
	if (En == 0)
		Enop = 0;
		
	else
	begin
		for(n=0; n<=7; n=n+1)
		begin
			if(I[n] == 1)
			begin
				Y = n;
				GS = 1;
				Enop = 0;
			end
		end
	end
	
	// Active-low Output Pins
	GS_low   = ~GS;
	Enop_low = ~Enop;
	Y_low    = ~Y;
	
end
endmodule
