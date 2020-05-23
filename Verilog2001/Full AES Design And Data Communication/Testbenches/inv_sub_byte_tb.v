
// This module is a test bench for the inv_sub_byte. The output of test bench is
// a pass or fail results passed on the obtained values.
`timescale 1ns / 100ps

module inv_sub_byte_tb;

reg startTransition;
reg clock50MHz;
reg  [127:0] inputValue;
reg  [127:0] expectedValue;

wire [127:0] outputValue;

inv_sub_byte dut(
	.inputData			(inputValue),
	.startTransition	(startTransition),
	.outputData			(outputValue)
);

// Creating the prameters required for the 50MHz clock, and the stoppage of the test bench.
localparam NUM_CYCLES = 20000;
localparam CLOCK_FREQ = 50000000;
real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;
integer half_cycle = 0;	


initial begin
	// Set input and expected values
	expectedValue = 128'h432eca169e44944515bfb66dfdd7cb52;
	inputValue = 128'h1a3174470b1b226e59084e3c540e1f00;
	startTransition = 0;
	clock50MHz = 0;
end

initial begin
	// Wait 500 clock cylces before setting the startTransition high.
  repeat(500) @ (posedge clock50MHz);  
  startTransition = 1;
end


always begin
	#(HALF_CLOCK_PERIOD);
	clock50MHz = ~clock50MHz;
	half_cycle = half_cycle + 1;
	if (half_cycle == (2 * NUM_CYCLES)) begin		
	
		// Comparing the acquired outputs with the expected outputs and printing
      // the corresponding message depending on the results.
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
		// Stop simulation test
		$stop;
	end
end

endmodule

