
// This module is a test bench for the add_round_key. The output of test bench is
// a pass or fail results passed on the obtained values.
`timescale 1ns / 100ps

module add_round_key_tb;


reg startTransition;
reg clock50MHz;

reg  [127:0] roundKey;
reg  [127:0] inputData;
reg  [127:0] expectedValue;
wire [127:0] outputData;

add_round_key dut(
	.inputData			(inputData),
	.roundKey			(roundKey),
	.startTransition	(startTransition),
	.outputData			(outputData)
);

// Creating the prameters required for the 50MHz clock, and the stoppage of the test bench.
localparam NUM_CYCLES = 20000;
localparam CLOCK_FREQ = 50000000;
real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;
integer half_cycle = 0;	


initial begin
	// Set input and expected values
	roundKey = 128'h754620676e754b20796d207374616854;
	inputData = 128'h6f775420656e694e20656e4f206f7754;
	expectedValue = 128'h1a3174470b1b226e59084e3c540e1f00;
	
	startTransition = 0;
	clock50MHz = 0;
end

initial begin
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
		if (outputData != expectedValue) begin
			$display("Fail \n \n",
						"For the following inputs: \n",
						"Input Key: %h \n", roundKey,
						"Input Value: %h \n \n", inputData,
						"Expected output: \n",
						"Output Value: %h \n \n", expectedValue,
						"Aquired output: \n",
						"Output Value: %h \n", outputData
			);
		end
		
		if (outputData == expectedValue) begin
			$display("Pass \n \n",
						"For the following inputs: \n",
						"Input Key: %h \n", roundKey,
						"Input Value: %h \n \n", inputData,
						"Aquired output: \n",
						"Output Value: %h \n \n", outputData
			);
		end
		// Stop simulation test
		$stop;
	end
end

endmodule

