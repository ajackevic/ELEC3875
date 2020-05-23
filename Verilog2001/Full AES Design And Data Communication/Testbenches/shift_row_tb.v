
// This module is a test bench for the shift_row. The output of test bench is
// a pass or fail results passed on the obtained values.
`timescale 1ns / 100ps

module shift_row_tb;

reg startTransition;
reg clock50MHz;
reg  [127:0] inputValue;
reg  [127:0] expectedValue;
wire [127:0] outputValue;

shift_row dut(
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
	expectedValue = 128'h2b30c0a0cbab929f20c793eba2af2f63;
	inputValue = 128'ha2c792a02baf939fcb302feb20abc063;
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
