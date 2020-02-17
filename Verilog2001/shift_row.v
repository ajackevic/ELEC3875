module shift_row(
	input  [127:0] inputData,
	output [127:0] outputData
);

	assign outputData = {inputData[127:120], inputData[87:80],
							   inputData[47:40],   inputData[7:0],
							   inputData[95:88],	 inputData[55:48],
							   inputData[15:8],	   inputData[103:96],
							   inputData[63:56],   inputData[23:16],
							   inputData[111:104], inputData[71:64],
							   inputData[31:24],   inputData[119:112],
							   inputData[79:72],	 inputData[39:32],
								inputData[127:120],  inputData[87:80],
								inputData[47:40],    inputData[7:0]
							  };

endmodule
