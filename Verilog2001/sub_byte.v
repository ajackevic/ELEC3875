module sub_byte(
	input  [127:0] subByteInput,
	output [127:0] subByteOutput

);

	genvar twoBytes;
	generate for(twoBytes = 0; twoBytes < 128; twoBytes = twoBytes + 8) begin: subByte
		s_box subValue(
			.sboxInput	(subByteInput[twoBytes +:8]),
			.sboxOutput	(subByteOutput[twoBytes +:8])
		);
	end
	endgenerate

endmodule
