/*
module mix_columns_tb;

reg  [127:0] inputValue;
reg  [127:0] expectedValue;
wire [127:0] outputValue;


mix_columns #(
	// Set 1 for encryption and 0 for decryption
	.ENCRYPT		(0)	
	) dut(
	.inputData	(inputValue),
	.outputData (outputValue)
);

initial begin 
	// For encryption 
	//expectedValue = 128'h5d7d401b0e068de8328da4847af475ba;
	// For decryption
	expectedValue = 128'h2b30c0a0cbab929f20c793eba2af2f63;
end
	

always @(*) begin 

	// For encryption
	//inputValue = 128'h2b30c0a0cbab929f20c793eba2af2f63;
	// For decryption 
	inputValue = 128'h5d7d401b0e068de8328da4847af475ba;
	
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
*/

`timescale 1ns / 100ps

module mix_columns_tb;

reg  [127:0] inputValue;
reg startTransition;
reg clock50MHz;
wire [127:0] outputValue;

mix_columns #(
	// Set 1 for encryption and 0 for decryption
	.ENCRYPT		(1)	
	) dut(
	.inputData			(inputValue),
	.startTransition	(startTransition),
	.outputData 		(outputValue)
);		

localparam NUM_CYCLES = 20000;
localparam CLOCK_FREQ = 50000000;

real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;

integer half_cycle = 0;	


initial begin
	inputValue = 128'h2b30c0a0cbab929f20c793eba2af2f63;
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
		$stop;
	end
end
endmodule

