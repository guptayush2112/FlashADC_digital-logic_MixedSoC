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
