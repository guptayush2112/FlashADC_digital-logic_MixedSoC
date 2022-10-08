`timescale 1ns / 1ps

////////////// CUSTOM DIGITAL LOGIC DESIGN ////////////////

////////////// AYUSH GUPTA ////////////////
 
// --------------------------------------Top Testbench Module ----------------------------------------- \\
// --------------------- 5-to-32 Thermometer Decoder with 32 Bit Priority Encoder-------------------- \\

module dec532_PE32b_str_tb;

	// Inputs
	reg [4:0] I;

	// Outputs
	wire [4:0] O;

	// Instantiate the Unit Under Test (UUT)
	dec532_PE32b_str uut (
		.I(I), 
		.O(O)
	);

	initial begin
		// Initialize Inputs
		I = 0;  #10;
		I = 1;  #10;
		I = 3;  #10;
		I = 2;  #10;
		I = 6;  #10;
		I = 7;  #10;
		I = 5;  #10;
		I = 4;  #10;
		I = 12; #10;
		I = 13; #10;
		I = 15; #10;
		I = 14; #10;
		I = 10; #10;
		I = 11; #10;
		I = 9;  #10;
		I = 8;  #10;
		I = 24; #10;
		I = 25; #10;
		I = 27; #10;
		I = 26; #10;
		I = 30; #10;
		I = 31; #10;
		I = 29; #10;
		I = 28; #10;
		I = 20; #10;
		I = 21; #10;
		I = 23; #10;
		I = 22; #10;
		I = 18; #10;
		I = 19; #10;
		I = 17; #10;
		I = 16; #10;

	end

initial #320 $finish;

endmodule

// --------------------------------------Sub-Module 1----------------------------------------- \\
// --------------------------------------Custom Digital Logic----------------------------------------- \\
// --------------Interfacing 5-to-32 Thermometer Decoder with 32 Bit Priority Encoder-------------- \\

module dec532_PE32b_str
(
	input  [4:0] I,
	output [4:0] O
);

// Store decoder output
wire [31:0] dop, dop_low;
wire PE_GS;

dec_gray532_bh d1(I, dop);
assign dop_low = (~dop)<<1;

PE_32b_str p1(dop_low, 1'b0, O, PE_GS);

endmodule




// --------------------------------------Sub-Module 2----------------------------------------- \\
// --------------------------------------5-to-32 Thermometer Decoder------------------------------------------ \\


module dec_gray532_bh
(
	input      [4:0]  I,
	output reg [31:0] O
);

always @(I)
begin

	case (I)
		5'b00000 : O = 32'b00000000000000000000000000000000;
		5'b00001 : O = 32'b00000000000000000000000000000001;
		5'b00011 : O = 32'b00000000000000000000000000000011;
		5'b00010 : O = 32'b00000000000000000000000000000111;
		5'b00110 : O = 32'b00000000000000000000000000001111;
		5'b00111 : O = 32'b00000000000000000000000000011111;
		5'b00101 : O = 32'b00000000000000000000000000111111;
		5'b00100 : O = 32'b00000000000000000000000001111111;
		5'b01100 : O = 32'b00000000000000000000000011111111;
		5'b01101 : O = 32'b00000000000000000000000111111111;
		5'b01111 : O = 32'b00000000000000000000001111111111;
		5'b01110 : O = 32'b00000000000000000000011111111111;
		5'b01010 : O = 32'b00000000000000000000111111111111;
		5'b01011 : O = 32'b00000000000000000001111111111111;
		5'b01001 : O = 32'b00000000000000000011111111111111;
		5'b01000 : O = 32'b00000000000000000111111111111111;
		5'b11000 : O = 32'b00000000000000001111111111111111;
		5'b11001 : O = 32'b00000000000000011111111111111111;
		5'b11011 : O = 32'b00000000000000111111111111111111;
		5'b11010 : O = 32'b00000000000001111111111111111111;
		5'b11110 : O = 32'b00000000000011111111111111111111;
		5'b11111 : O = 32'b00000000000111111111111111111111;
		5'b11101 : O = 32'b00000000001111111111111111111111;
		5'b11100 : O = 32'b00000000011111111111111111111111;
		5'b10100 : O = 32'b00000000111111111111111111111111;
		5'b10101 : O = 32'b00000001111111111111111111111111;
		5'b10111 : O = 32'b00000011111111111111111111111111;
		5'b10110 : O = 32'b00000111111111111111111111111111;
		5'b10010 : O = 32'b00001111111111111111111111111111;
		5'b10011 : O = 32'b00011111111111111111111111111111;
		5'b10001 : O = 32'b00111111111111111111111111111111;
		5'b10000 : O = 32'b01111111111111111111111111111111;
	   default  : O = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	 endcase
	 
end
endmodule


// --------------------------------------Sub-Module 3----------------------------------------- \\
// --------------------------------------32-to-5 Priority Encoder------------------------------------------ \\


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


// --------------------------------------Sub-Module 4----------------------------------------- \\
// --------------------------------------8-to-3 Priority Encoder------------------------------------------ \\

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