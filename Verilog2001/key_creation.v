
module key_creation #(
	parameter numKeys = 11
)(
	// Should add a deafult value of roundKeyInput equale to 0's.
	input  [127:0] roundKeyInput,
	output [127:0] roundKeyOutput1,
	output [127:0] roundKeyOutput2,
	output [127:0] roundKeyOutput3,
	output [127:0] roundKeyOutput4,
	output [127:0] roundKeyOutput5,
	output [127:0] roundKeyOutput6,
	output [127:0] roundKeyOutput7,
	output [127:0] roundKeyOutput8,
	output [127:0] roundKeyOutput9,
	output [127:0] roundKeyOutput10,
	output [127:0] roundKeyOutput11
);

	wire [127:0] tempKeys   [0:numKeys-1];
	wire [31:0]  shiftedRow [0:numKeys-1];
	wire [31:0]  col3out    [0:numKeys-1];
	wire [31:0]  col2out    [0:numKeys-1];
	wire [31:0]  col1out    [0:numKeys-1];
	wire [31:0]  col0out    [0:numKeys-1];
	wire [31:0]  sboxSubCol [0:numKeys-1];
	wire [31:0]  Rcon       [0:9];
	
	
	assign Rcon[0] = 32'h01000000;
	assign Rcon[1] = 32'h02000000;
	assign Rcon[2] = 32'h04000000;
	assign Rcon[3] = 32'h08000000;
	assign Rcon[4] = 32'h10000000;
	assign Rcon[5] = 32'h20000000;
	assign Rcon[6] = 32'h40000000;
	assign Rcon[7] = 32'h80000000;
	assign Rcon[8] = 32'h1b000000;
	assign Rcon[9] = 32'h36000000;
	
	assign tempKeys[0] = roundKeyInput;
	
	genvar i;
	generate for (i = 0; i < numKeys-1; i = i + 1) begin : key_expand
	
	assign shiftedRow[i] = {tempKeys[i][23:0], tempKeys[i][31:24]};
	
		s_box value1(
			.sboxInput		(shiftedRow[i][7:0]),
			.sboxOutput		(sboxSubCol[i][7:0])
		);
		s_box value2(
			.sboxInput		(shiftedRow[i][15:8]),
			.sboxOutput		(sboxSubCol[i][15:8])
		);
		s_box value3(
			.sboxInput		(shiftedRow[i][23:16]),
			.sboxOutput		(sboxSubCol[i][23:16])
		);
		s_box value4(
			.sboxInput		(shiftedRow[i][31:24]),
			.sboxOutput		(sboxSubCol[i][31:24])
		);
		
		assign col3out[i] = sboxSubCol[i][31:0] ^ tempKeys[i][127:96] ^ Rcon[i];
		assign col2out[i] = col3out[i] ^ tempKeys[i][95:64];
		assign col1out[i] = col2out[i] ^ tempKeys[i][63:32];
		assign col0out[i] = col1out[i] ^ tempKeys[i][31:0];
		
		assign tempKeys[i+1] = {col3out[i], col2out[i], col1out[i], col0out[i]};
	end
	endgenerate
	
	assign roundKeyOutput1 = tempKeys[0];
	assign roundKeyOutput2 = tempKeys[1];
	assign roundKeyOutput3 = tempKeys[2];
	assign roundKeyOutput4 = tempKeys[3];
	assign roundKeyOutput5 = tempKeys[4];
	assign roundKeyOutput6 = tempKeys[5];
	assign roundKeyOutput7 = tempKeys[6];
	assign roundKeyOutput8 = tempKeys[7];
	assign roundKeyOutput9 = tempKeys[8];
	assign roundKeyOutput10 = tempKeys[9];
	assign roundKeyOutput11 = tempKeys[10];
	
endmodule
