`timescale 1ns/100ps
module mix_columns_tb;

reg  [127:0] inputValue;
wire [127:0] outputValue;

mix_columns dut (
	.inputData	 (inputValue),
	.outputData (outputValue)
);

initial begin
	$monitor("InputValue: %h \n", inputValue,
				"OutputValue: %h \n", outputValue,
			  );
	inputValue = 128'h2b30c0a0cbab929f20c793eba2af2f63;
	#10;

end

endmodule
