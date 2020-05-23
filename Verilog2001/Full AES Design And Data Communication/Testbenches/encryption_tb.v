
// This module is a test bench for the encryption. The output of test bench is
// a pass or fail results passed on the obtained values.
`timescale 1 ns/100 ps
module encryption_tb;

reg clock50MHz;
reg inputsLoadedFlag;
reg resetModule;
reg [127:0] inputValue;
reg [127:0] key;
reg [127:0] expectedValue;

wire dataEncryptedFlag;
wire [127:0] outputValue;

// Creating the prameters required for the 50MHz clock, and the stoppage of the test bench.
localparam NUM_CYCLES = 200000;
localparam CLOCK_FREQ = 50000000;
real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;
integer half_cycle = 0;


encryption dut(
	.inputData			 (inputValue),
	.key					 (key),
	.clock				 (clock50MHz),
	.inputsLoadedFlag  (inputsLoadedFlag),
	.outputData			 (outputValue),
	.resetModule		 (resetModule),
	.dataEncryptedFlag (dataEncryptedFlag)
);


initial begin 
	// Set input and expected values
	expectedValue = 128'h3ad7021ab3992240f62014575f50c329;
	inputValue = 128'h6F775420656e694e20656e4f206f7754;
	key = 128'h754620676e754b20796d207374616854;
	
	resetModule = 0;
	clock50MHz = 1'b0;
	inputsLoadedFlag = 0;
end

initial begin	
	// Wait 500 clock cylces before setting the startTransition high.
   repeat(500) @ (posedge clock50MHz);  
	inputsLoadedFlag = 1;
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
		// Stop simulation test
		$stop;
	end
end

endmodule





