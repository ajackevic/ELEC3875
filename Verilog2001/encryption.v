module encryption #(
	parameter numRounds = 4
)(
	input [127:0] inputData,
	input [127:0] key,
	output reg [127:0] outputData
);

	wire [127:0] roundKey [0:10];
	wire [127:0] tempData [0:35];


key_creation keyGen(
	.roundKeyInput		(key),
	.roundKeyOutput1	(roundKey[0]),
	.roundKeyOutput2	(roundKey[1]),
	.roundKeyOutput3	(roundKey[2]),
	.roundKeyOutput4	(roundKey[3]),
	.roundKeyOutput5	(roundKey[4]),
	.roundKeyOutput6	(roundKey[5]),
	.roundKeyOutput7	(roundKey[6]),
	.roundKeyOutput8	(roundKey[7]),
	.roundKeyOutput9	(roundKey[8]),
	.roundKeyOutput10	(roundKey[9]),
	.roundKeyOutput11	(roundKey[10])
);

add_round_key roundInit(
		.inputData 	 (inputData),
		.roundKey	 (roundKey[0]),
		.outputData  (tempData[0])
	);

	genvar currentValue;
  
	generate 	for (currentValue = 0; currentValue < numRounds; currentValue = currentValue + 5) begin : t
		sub_byte SubByte(
			.subByteInput (tempData[currentValue]),
			.subByteOutput (tempData[currentValue + 1])
		);

		shift_row shiftRow(
			.inputData	(tempData[currentValue + 1]),
			.outputData (tempData[currentValue + 2])
		);

		mix_columns MixColumns(
			.inputData	(tempData[currentValue + 2]),
			.outputData (tempData[currentValue + 3])
		);

		add_round_key AddRoundKey(
			.inputData	(tempData[currentValue + 3]),
			.roundKey   (roundKey[1]), // could use an array for this but thats effort
			.outputData (tempData[currentValue + 4])
		);

	end
	endgenerate


	always @(tempData) begin
		outputData = tempData[4];
	end


endmodule
