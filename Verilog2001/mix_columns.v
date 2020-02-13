module mix_columns(
	input [7:0] inputValue,
	input [7:0] MSDValue,
	output reg [10:0] outputValue
);
// For gf_conv create four instances (for the 4 bits in the MSD matrix that is muiltiplied by inputData).
// Hence bit 0 = zero shift, bit 1 = 1 shift, bit 2 = 2 shitfs, and bit three = 3 shifts.
// Have an if statment that checks the MSD input and XOR's these results based on which bits are set in the MSD value.

reg [10:0] tempXORdValue;

initial begin
	tempXORdValue = 11'b00000000000;
end

always @(MSDValue) begin
	
	if(MSDValue[0] == 1'b1) begin 
		tempXORdValue = tempXORdValue ^ {3'b000, inputValue};
	end 
	if (MSDValue[1] == 1'b1) begin
		assign tempXORdValue = tempXORdValue ^ (inputValue << 1);
	end 
	if (MSDValue[2] == 1'b1) begin
		assign tempXORdValue = tempXORdValue ^ (inputValue << 2);
	end 
	if (MSDValue[3] == 1'b1) begin
		assign tempXORdValue = tempXORdValue ^ (inputValue << 3);
	end
	outputValue = tempXORdValue;
end

endmodule
