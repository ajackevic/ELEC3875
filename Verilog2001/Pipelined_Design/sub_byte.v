module sub_byte(
	input  [127:0] subByteInput,
	input startTransition,
	input clock,
	output [127:0] subByteOutput
);

genvar twoBytes;
generate for(twoBytes = 0; twoBytes < 128; twoBytes = twoBytes + 8) begin: subByte
	s_box subValue(
		.inputValue				(subByteInput[twoBytes +:8]),
		.sboxOutput				(subByteOutput[twoBytes +:8])
	);
	end
endgenerate

endmodule
	
	
	
	
	
	
	


















/*
	if(startTransition == 1) begin 
		for(twoBytes = 0; twoBytes < 128; twoBytes = twoBytes + 8) begin
			subValueInput = subByteInput[twoBytes +:8];
			callModule = 1;
			subByteOutput[twoBytes +:8] = subValueOutput;
			//callModule = 0;
			//TwoBytes = subValueOutput;
		end
	end
	TwoBytesOutput = subValueOutput;
	TwoBytesInput = subValueInput;
end






	
*/

