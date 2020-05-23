
// This module is a test bench for the inv_s_box. The output of test bench is
// a pass or fail results passed on the obtained values.
module inv_s_box_tb;

reg  [7:0] inputValue1;
reg  [7:0] inputValue2;
reg  [7:0] inputValue3;
reg  [7:0] expectedValue1;
reg  [7:0] expectedValue2;
reg  [7:0] expectedValue3;
wire [7:0] outputValue1;
wire [7:0] outputValue2;
wire [7:0] outputValue3;

inv_s_box dut1(
	.inputValue	 (inputValue1),
	.outputValue (outputValue1)
);

inv_s_box dut2(
	.inputValue	 (inputValue2),
	.outputValue (outputValue2)
);

inv_s_box dut3(
	.inputValue	 (inputValue3),
	.outputValue (outputValue3)
);


initial begin
	// Set expected values
	expectedValue1 = 8'h6c;
	expectedValue2 = 8'h80;
	expectedValue3 = 8'h5c;
end

always @(*) begin 
	inputValue1 = 8'h50;
	inputValue2 = 8'hcd;
	inputValue3 = 8'h4a;

	// Comparing the acquired outputs with the expected outputs and printing
   // the corresponding message depending on the results.
	if((outputValue1 != expectedValue1) | (outputValue2 != expectedValue2) | (outputValue3 != expectedValue3))begin 
		$display("Fail \n \n",
					"For the following inputs: \n",
					"Input Value: %h, %h, %h \n \n", inputValue1, inputValue2, inputValue3,
					"Expected output: \n",
					"Output Value: %h, %h, %h \n \n", expectedValue1, expectedValue2, expectedValue3,
					"Aquired output: \n",
					"Output Value: %h, %h, %h \n", outputValue1, outputValue2, outputValue3
		);
	end
	
	if((outputValue1 == expectedValue1) & (outputValue2 == expectedValue2) & (outputValue3 == expectedValue3))begin
		$display("Pass \n \n",
					"For the following inputs: \n",
					"Input Value: %h, %h, %h \n \n", inputValue1, inputValue2, inputValue3,
					"Aquired output: \n",
					"Output Value: %h, %h, %h \n", outputValue1, outputValue2, outputValue3
		);
	end
	
end
endmodule
	