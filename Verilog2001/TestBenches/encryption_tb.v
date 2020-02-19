module encryption_tb;

reg  [127:0] inputValue;
reg  [127:0] key;
reg  [127:0] expectedValue;
wire [127:0] outputValue;

encryption dut(
	.inputData	(inputValue),
	.key			(key),
	.outputData (outputValue)
);

initial begin
	expectedValue = 128'h3ad7021ab3992240f62014575f50c329;
end

always @(*) begin
	inputValue = 128'h6F775420656e694e20656e4f206f7754;
	key = 128'h754620676e754b20796d207374616854;

	if (outputValue != expectedValue) begin
		$display("Fail \n \n",
					"For the following inputs: \n",
					"Input Value: %h \n", inputValue,
					"Input Key: %h \n \n", key,
					"Expected output: \n",
					"Output Value: %h \n \n", expectedValue,
					"Aquired output: \n",
					"Output Value: %h \n", outputValue
				  );
	end

	if (outputValue == expectedValue) begin
		$display("Pass \n \n",
					"For the following inputs: \n",
					"Input Value: %h \n", inputValue,
					"Input Key: %h \n \n", key,
					"Aquired output: \n",
					"Output Value: %h \n \n", outputValue
				  );
	end

end
endmodule
