module encryption #(
	parameter numRounds = 32
)(
	input [127:0] inputData,
	input [127:0] key,
	output reg [127:0] outputData
);

	wire [127:0] roundKey [0:10];
	wire [127:0] tempData [0:39];
	wire [3:0] counter [0:32];


	assign counter[0] = 1;
	assign counter[4] = 2;
	assign counter[8] = 3;
	assign counter[12] = 4;
	assign counter[16] = 5;
	assign counter[20] = 6;
	assign counter[24] = 7;
	assign counter[28] = 8;
	assign counter[32] = 9;

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




	//assign counter = 3'b001;
	genvar currentValue;
	generate

	add_round_key AddRoundKeyInitRound(
		.inputData 	 (inputData),
		.roundKey	 (roundKey[0]),
		.outputData  (tempData[0])
	);

	for (currentValue = 0; currentValue <= numRounds; currentValue = currentValue + 4) begin : t
		//assign counter = counter + 1'b1;
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
			.roundKey   (roundKey[counter[currentValue]]),
			.outputData (tempData[currentValue + 4])
		);

	end

	sub_byte SubByteLastRound(
		.subByteInput (tempData[36]),
		.subByteOutput (tempData[37])
	);

	shift_row shiftRowLastRound(
		.inputData	(tempData[37]),
		.outputData (tempData[38])
	);

	add_round_key AddRoundKeyLastRound(
		.inputData	(tempData[38]),
		.roundKey   (roundKey[10]),
		.outputData (tempData[39])
	);

	endgenerate


	always @(tempData) begin
		outputData = tempData[39];
	end

endmodule
