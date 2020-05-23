
// This is AES inverse SubByte module. At the posedge of startTransition, each byte
// of inputData is substituted with the lookup table of inverse sBox.

module inv_sub_byte(
	input  [127:0] inputData,
	input  startTransition,
	output [127:0] outputData
);

// This instantiate 16 inverse SBox modules. This purley so that all 16 bytes 
// can be substituted in parallel, thus saving time.
genvar twoBytes;
generate for(twoBytes = 0; twoBytes < 128; twoBytes = twoBytes + 8) begin: subByte
	inv_s_box subValue(
		.inputValue	 (inputData[twoBytes +:8]),
		.outputValue (outputData[twoBytes +:8])
	);
end
endgenerate

endmodule
