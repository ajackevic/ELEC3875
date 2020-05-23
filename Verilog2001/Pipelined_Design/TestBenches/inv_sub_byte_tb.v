module inv_sub_byte_tb;

reg  [127:0] inputValue;
reg  [127:0] expectedValue;
wire [127:0] outputValue;

inv_sub_byte dut(
	.inputValue	 (inputValue),
	.outputValue (outputValue)
);
	
initial begin 
		expectedValue = 128'h1a3174470b1b226e59084e3c540e1f00;
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
