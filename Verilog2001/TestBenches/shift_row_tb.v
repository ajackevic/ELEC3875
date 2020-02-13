`timescale 1ns/100ps
module shift_row_tb;

reg  [127:0] inputData;
wire [127:0] outputData;

shift_row dut(
	.inputData(inputData),
	.outputData(outputData)
);

initial begin
	$monitor("InputData: %h \n", inputData,
				"OutputData: %h \n", outputData,
			  );
	inputData = 128'h1ab4d3aaab5bbae80130e9bb2741d29a;
	#10;
end
endmodule
