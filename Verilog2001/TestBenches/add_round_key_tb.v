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
					"Input data: %h \n \n", inputData,
					"Expected output: \n",
					"Output data: %h \n \n", expectedValue,
					"Aquired output: \n",
					"Output data: %h \n", outputData
				  );
	end

	if (outputData == expectedValue) begin
		$display("Pass \n \n",
					"For the following inputs: \n",
					"Input Key: %h \n", roundKey,
					"Input data: %h \n \n", inputData,
					"Aquired output: \n",
					"Output data: %h \n \n", outputData
				  );
	end

end
endmodule
