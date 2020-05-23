
// This module is a test bench for the Key_creation. The output of test bench is
// a pass or fail results passed on the obtained values.

`timescale 1ns / 100ps
module key_creation_tb;


reg clock50MHz;
reg startTransition;
reg  [127:0] inputKey;
reg  [127:0] expectedValue1;
reg  [127:0] expectedValue2;
reg  [127:0] expectedValue3;
reg  [127:0] expectedValue4;
reg  [127:0] expectedValue5;
reg  [127:0] expectedValue6;
reg  [127:0] expectedValue7;
reg  [127:0] expectedValue8;
reg  [127:0] expectedValue9;
reg  [127:0] expectedValue10;
reg  [127:0] expectedValue11;

wire [127:0] outputKey1;
wire [127:0] outputKey2;
wire [127:0] outputKey3;
wire [127:0] outputKey4;
wire [127:0] outputKey5;
wire [127:0] outputKey6;
wire [127:0] outputKey7;
wire [127:0] outputKey8;
wire [127:0] outputKey9;
wire [127:0] outputKey10;
wire [127:0] outputKey11;


key_creation dut(
	.clock				(clock50MHz),
	.startTransition	(startTransition),
	.roundKeyInput		(inputKey),
	.roundKeyOutput1	(outputKey1),
	.roundKeyOutput2	(outputKey2),
	.roundKeyOutput3	(outputKey3),
	.roundKeyOutput4	(outputKey4),
	.roundKeyOutput5	(outputKey5),
	.roundKeyOutput6	(outputKey6),
	.roundKeyOutput7	(outputKey7),
	.roundKeyOutput8	(outputKey8),
	.roundKeyOutput9	(outputKey9),
	.roundKeyOutput10	(outputKey10),
	.roundKeyOutput11	(outputKey11)
);

// Creating the prameters required for the 50MHz clock, and the stoppage of the test bench. 
localparam NUM_CYCLES = 1000;
localparam CLOCK_FREQ = 50000000;
real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;
integer half_cycle = 0;	


initial begin
	// Set input and expected values
	inputKey = 128'h754620676e754b20796d207374616854;
	expectedValue1  = 128'h754620676e754b20796d207374616854;
	expectedValue2  = 128'h93a279d6e6e459b188911291f1fc32e2;
	expectedValue3  = 128'hfaf73aa0695543768fb11ac707200856;
	expectedValue4  = 128'hfb1e03c301e9396368bc7a15e70d60d2;
	expectedValue5  = 128'h5b495214a05751d7a1be68b4c90212a1;
	expectedValue6  = 128'h699b42c632d210d292854105333b29b1;
	expectedValue7  = 128'h4e0e2eac27956c6a15477cb887c23dbd;
	expectedValue8  = 128'h6a31a8b2243f861e03aaea7416ed96cc;
	expectedValue9  = 128'h6c4b9556067a3de42245bbfa21ef518e;
	expectedValue10 = 128'hd8cbf1f7b48064a1b2fa594590bfe2bf;
	expectedValue11 = 128'h266f313bfea4c0cc4a24a46df8defd28;
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
		if((outputKey1 != expectedValue1) | (outputKey2  != expectedValue2)  |
			(outputKey3 != expectedValue3) | (outputKey4  != expectedValue4)  |
			(outputKey5 != expectedValue5) | (outputKey6  != expectedValue6)  |
			(outputKey7 != expectedValue7) | (outputKey8  != expectedValue8)  |
			(outputKey9 != expectedValue9) | (outputKey10 != expectedValue10) |
			(outputKey11 != expectedValue11)) begin 
			
			$display("Fail \n \n",
						"For the following inputs: \n",
						"Input Key: %h \n \n", inputKey,
						"Expected output: \n",
						"Output RoundKey 1: %h \n", expectedValue1,
						"Output RoundKey 2: %h \n", expectedValue2,
						"Output RoundKey 3: %h \n", expectedValue3,
						"Output RoundKey 4: %h \n", expectedValue4,
						"Output RoundKey 5: %h \n", expectedValue5,
						"Output RoundKey 6: %h \n", expectedValue6,
						"Output RoundKey 7: %h \n", expectedValue7,
						"Output RoundKey 8: %h \n", expectedValue8,
						"Output RoundKey 9: %h \n", expectedValue9,
						"Output RoundKey 10: %h \n", expectedValue10,
						"Output RoundKey 11: %h \n \n", expectedValue11,
						"Aquired output: \n",
						"Output RoundKey 1: %h \n", outputKey1,
						"Output RoundKey 2: %h \n", outputKey2,
						"Output RoundKey 3: %h \n", outputKey3,
						"Output RoundKey 4: %h \n", outputKey4,
						"Output RoundKey 5: %h \n", outputKey5,
						"Output RoundKey 6: %h \n", outputKey6,
						"Output RoundKey 7: %h \n", outputKey7,
						"Output RoundKey 8: %h \n", outputKey8,
						"Output RoundKey 9: %h \n", outputKey9,
						"Output RoundKey 10: %h \n", outputKey10,
						"Output RoundKey 11: %h \n \n", outputKey11,
					  );
		end
	
		if((outputKey1 == expectedValue1) | (outputKey2 == expectedValue2)   |
			(outputKey3 == expectedValue3) | (outputKey4 == expectedValue4)   |
			(outputKey5 == expectedValue5) | (outputKey6 == expectedValue6)   |
			(outputKey7 == expectedValue7) | (outputKey8 == expectedValue8)   |
			(outputKey9 == expectedValue9) | (outputKey10 == expectedValue10) |
			(outputKey11 == expectedValue11)) begin 
			
			$display("Pass \n \n",
						"For the following inputs: \n",
						"Input Key: %h \n \n", inputKey,
						"Aquired output: \n",
						"Output RoundKey 1: %h \n", outputKey1,
						"Output RoundKey 2: %h \n", outputKey2,
						"Output RoundKey 3: %h \n", outputKey3,
						"Output RoundKey 4: %h \n", outputKey4,
						"Output RoundKey 5: %h \n", outputKey5,
						"Output RoundKey 6: %h \n", outputKey6,
						"Output RoundKey 7: %h \n", outputKey7,
						"Output RoundKey 8: %h \n", outputKey8,
						"Output RoundKey 9: %h \n", outputKey9,
						"Output RoundKey 10: %h \n", outputKey10,
						"Output RoundKey 11: %h \n \n", outputKey11,
					  );
		end
		
		$stop;
	end
end
endmodule


