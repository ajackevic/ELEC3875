/*
module add_round_key_tb;

reg  [127:0] roundKey;
reg  [127:0] inputData;
reg  [127:0] expectedValue;
wire [127:0] outputData;

add_round_key dut (
	.inputData	(inputData),
	.roundKey	(roundKey),
	.outputData	(outputData)
);

initial begin 
	expectedValue = 128'h1a3174470b1b226e59084e3c540e1f00;
end


always @ (*) begin 

	roundKey = 128'h754620676e754b20796d207374616854;
	inputData = 128'h6f775420656e694e20656e4f206f7754;

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

end
endmodule
*/

`timescale 1ns / 100ps

module add_tound_ket_tb;


reg startTransition;
reg clock50MHz;

reg  [127:0] roundKey;
reg  [127:0] inputData;
wire [127:0] outputData;

add_round_key dut (
	.inputData	(inputData),
	.roundKey	(roundKey),
	.startTransition	(startTransition),
	.outputData	(outputData)
);

localparam NUM_CYCLES = 20000;
localparam CLOCK_FREQ = 50000000;

real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;

integer half_cycle = 0;	


initial begin
	roundKey = 128'h754620676e754b20796d207374616854;
	inputData = 128'h6f775420656e694e20656e4f206f7754;
	
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

