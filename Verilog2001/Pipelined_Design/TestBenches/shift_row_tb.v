module shift_row_tb;

reg  [127:0] inputValue;
reg  [127:0] expectedValue;
wire [127:0] outputValue;

shift_row dut(
	.inputData(inputValue),
	.outputData(outputValue)
);

initial begin 
	expectedValue = 128'h2b30c0a0cbab929f20c793eba2af2f63;
end


always @(*) begin 

	inputValue = 128'ha2c792a02baf939fcb302feb20abc063;
	
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
