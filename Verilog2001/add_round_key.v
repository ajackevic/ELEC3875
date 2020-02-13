module add_round_key(
	input  [127:0] data,
	input  [127:0] roundKey,
	output [127:0] addRoundKeyOutput
);
	assign addRoundKeyOutput = data ^ roundKey;
endmodule
