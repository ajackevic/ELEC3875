`timescale 1ns/100ps
module encryption_tb;
	reg  [127:0] inputData;
	reg  [127:0] key;
	wire [127:0] outputData;

	encryption dut (
		.inputData	(inputData),
		.key			(key),
		.outputData (outputData)
	);

	initial begin
		$monitor("InputData: %h \n", inputData,
					"InputKey: %h \n", key,
					"OutputData: %h \n", outputData,
				  );
		inputData = 128'h6F775420656e694e20656e4f206f7754;
		key = 128'h754620676e754b20796d207374616854;
		#10;

	end
endmodule
