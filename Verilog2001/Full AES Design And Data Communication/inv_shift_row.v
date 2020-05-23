
// This is AES inverse ShiftRow module. On the postaive edge of startTransition, certain values
// are cyclically shifted to the left. If the inputData is aranged as a 4x4 matrix as shown on 
// the LHS, then the ouput of this module is as shown on the RHS.
//		[a00, a01, a02, a03]		 [a00, a01, a02, a03]
//		[a10, a11, a12, a13] ==> [a11, a12, a13, a10]
//		[a20, a21, a22, a23] ==> [a22, a23, a20, a21]
//		[a30, a31, a32, a33]     [a33, a30, a31, a32]

module inv_shift_row(
	input [127:0] inputData,
	input startTransition,
	output reg [127:0] outputData
);


always @(posedge startTransition) begin 
	outputData = {inputData[31:24],   inputData[55:48],
					  inputData[79:72],   inputData[103:96],
					  inputData[127:120], inputData[23:16],
					  inputData[47:40],   inputData[71:64],
					  inputData[95:88],   inputData[119:112],
					  inputData[15:8],    inputData[39:32],
					  inputData[63:56],   inputData[87:80],
					  inputData[111:104], inputData[7:0]
					 };
end		  
endmodule
