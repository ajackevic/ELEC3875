module mix_columns(
	input [7:0] inputValue,
	input [7:0] MSDValue,
	output reg [7:0] outputValue
);

reg [10:0] tempXORdValue;

initial begin
	tempXORdValue = 11'b00000000000;
end

always @(MSDValue) begin
	outputValue = GF_mul(inputValue, MSDValue);
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
