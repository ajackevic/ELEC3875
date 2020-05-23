module inv_sub_byte(
	input  [127:0] inputData,
	input startTransition,
	input clock,
	output [127:0] outputData
);

genvar twoBytes;
generate for(twoBytes = 0; twoBytes < 128; twoBytes = twoBytes + 8) begin: subByte
	inv_s_box subValue(
		.inputValue	 (inputData[twoBytes +:8]),
		.outputValue (outputData[twoBytes +:8])
	);
end
endgenerate

endmodule
