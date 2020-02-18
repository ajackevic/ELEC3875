module mix_columns_tb;

reg  [127:0] inputValue;
reg  [127:0] expectedValue;
wire [127:0] outputValue;

mix_columns dut (
	.inputData	 (inputValue),
	.outputData (outputValue)
);

initial begin
	expectedValue = 128'h5d7d401b0e068de8328da4847af475ba;
end


always @(*) begin

	inputValue = 128'h2b30c0a0cbab929f20c793eba2af2f63;

	if (outputValue != expectedValue) begin
		$display("Fail \n \n",
					"For the following inputs: \n",
					"Input Value: %h \n \n", inputValue,
					"Expected output: \n",
					"Output Value: %h \n \n", expectedValue,
					"Aquired output: \n",
					"Output Value: %h \n", outputValue
				  );
	end

	if (outputValue == expectedValue) begin
		$display("Pass \n \n",
					"For the following inputs: \n",
					"Input Value: %h \n \n", inputValue,
					"Aquired output: \n",
					"Output Value: %h \n \n", outputValue
				  );
	end

end
endmodule
