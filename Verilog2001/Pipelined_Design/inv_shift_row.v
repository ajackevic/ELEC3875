module inv_shift_row(
	input [127:0] inputData,
	input startTransition,
	input clock,
	output reg [127:0] outputData
);


always @(posedge clock) begin 
	if(startTransition == 1) begin 
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
end		  
endmodule
