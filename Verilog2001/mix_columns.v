module mix_columns(
	input [127:0] inputData,
	output reg [127:0] outputData
);

reg [10:0] tempXORdValue;
reg [7:0] MSDMatrix [0:15];
reg [7:0] row01 [0:3];
reg [7:0] row02 [0:3];
reg [7:0] row03 [0:3];
reg [7:0] row04 [0:3];

initial begin
	MSDMatrix[0]  = 8'h02;
	MSDMatrix[1]  = 8'h01;
	MSDMatrix[2]  = 8'h01;
	MSDMatrix[3]  = 8'h03;
	MSDMatrix[4]  = 8'h03;
	MSDMatrix[5]  = 8'h02;
	MSDMatrix[6]  = 8'h01;
	MSDMatrix[7]  = 8'h01;
	MSDMatrix[8]  = 8'h01;
	MSDMatrix[9]  = 8'h03;
	MSDMatrix[10] = 8'h02;
	MSDMatrix[11] = 8'h01;
	MSDMatrix[12] = 8'h01;
	MSDMatrix[13] = 8'h01;
	MSDMatrix[14] = 8'h03;
	MSDMatrix[15] = 8'h02;
end

// For some reason ModelSim requires the block to have a name for the use of 'integer', thus mixColumns
always @(inputData) begin: mixColumns
	/*
			  InputData			 MDS_matrix(encrypt)		  OutputData
    [a00, a01, a02, a03]   [02, 03, 01 ,01]   [b00, b01, b02, b03]
		[a10, a11, a12, a13] • [01, 02, 03, 01] =	[b10, b11, b12, b13]
		[a20, a21, a22, a23]   [01, 01, 02, 03]   [b20, b21, b22, b23]
		[a30, a31, a32, a33]   [03, 01, 01, 02]   [b30, b31, b32, b33]


	For loop which goes thorugh each column [visualised 4x4 input matrix]
   Multiplication and addition in GF(2^8)
   b00 = row01[0] = [a00•02]⊕[a10•03]⊕[a20•01]⊕[a30•01]
	*/
	integer columns;
	integer i;
	i = 0;
	for(columns = 0; columns < 128; columns = columns + 32) begin
		row01[i] = (GF_mul(inputData[columns +: 8], MSDMatrix[0])		  ^
						GF_mul(inputData[(columns + 8) +: 8], MSDMatrix[4])  ^
						GF_mul(inputData[(columns + 16) +: 8], MSDMatrix[8]) ^
						GF_mul(inputData[(columns + 24) +: 8], MSDMatrix[12]));

		row02[i] = (GF_mul(inputData[columns +: 8], MSDMatrix[1])   	  ^
						GF_mul(inputData[(columns + 8) +: 8], MSDMatrix[5])  ^
						GF_mul(inputData[(columns + 16) +: 8], MSDMatrix[9]) ^
						GF_mul(inputData[(columns + 24) +: 8], MSDMatrix[13]));

		row03[i] = (GF_mul(inputData[columns +: 8], MSDMatrix[2])   	  ^
						GF_mul(inputData[(columns + 8) +: 8], MSDMatrix[6])  ^
						GF_mul(inputData[(columns + 16) +: 8], MSDMatrix[10])^
						GF_mul(inputData[(columns + 24) +: 8], MSDMatrix[14]));

		row04[i] = (GF_mul(inputData[columns +: 8], MSDMatrix[3])  		  ^
						GF_mul(inputData[(columns + 8) +: 8], MSDMatrix[7])  ^
						GF_mul(inputData[(columns + 16) +: 8], MSDMatrix[11])^
						GF_mul(inputData[(columns + 24) +: 8], MSDMatrix[15]));

		i = i + 1;
	end

	outputData = {row04[3], row03[3], row02[3], row01[3],
					  row04[2], row03[2], row02[2], row01[2],
					  row04[1], row03[1], row02[1], row01[1],
					  row04[0], row03[0], row02[0], row01[0]};
end

/*
 Function for multiplication of two 8 bit values in GF(2^8). This corresponds to shifting and XORing
 inputValue with its previous sate depending on MSDValue. Since MSDValue will range from
 00000000 to 00001111, only four cases need to be considered. The following function can be applied
 for the multiplication in GF(2^8):
        {y                            for n = 0
 x[n] = {
        {x[n-1] ^ (y << n)        for n >= 1
 where y is ioriginal inputValue, n is set bit position of MSDValue and x[n] is tempXORdValue.
*/

function [7:0] GF_mul;
	input [7:0] inputValue;
	input [7:0] MSDValue;
begin
	tempXORdValue = 11'b00000000000;

	if(MSDValue[0] == 1'b1) begin
		tempXORdValue = inputValue;
	end
	if (MSDValue[1] == 1'b1) begin
		tempXORdValue = tempXORdValue ^ (inputValue << 1);
	end
	if (MSDValue[2] == 1'b1) begin
		tempXORdValue = tempXORdValue ^ (inputValue << 2);
	end
	if (MSDValue[3] == 1'b1) begin
		tempXORdValue = tempXORdValue ^ (inputValue << 3);
	end

	// If value is greater than 8 bits (255) then XOR 0x11B from the MSB side
	// to reduce the values that were muiltiplied in GF(2^8)
	while (tempXORdValue >= 11'd256) begin

		if (tempXORdValue >= 11'd1024) begin
			tempXORdValue = tempXORdValue ^ 11'd1132;
		end
		if (tempXORdValue >= 11'd512 & tempXORdValue <= 11'd1023) begin
			tempXORdValue = tempXORdValue ^ 11'd566;
		end
		if (tempXORdValue >= 11'd256 & tempXORdValue <= 11'd511) begin
			tempXORdValue = tempXORdValue ^ 11'd283;
		end
	end
	GF_mul = tempXORdValue[7:0];
end endfunction

endmodule
