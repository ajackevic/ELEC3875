`timescale 1ns/100ps
module key_creation_tb;

reg  [127:0] inputKey;
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

initial begin

	$monitor("%d ns \ input: %h \n", $time, inputKey,
				"OutputKey1: %h \n", outputKey1,
				"OutputKey2: %h \n", outputKey2,
				"OutputKey3: %h \n", outputKey3,
				"OutputKey4: %h \n", outputKey4,
				"OutputKey5: %h \n", outputKey5,
				"OutputKey6: %h \n", outputKey6,
				"OutputKey7: %h \n", outputKey7,
				"OutputKey8: %h \n", outputKey8,
				"OutputKey9: %h \n", outputKey9,
				"OutputKey10: %h \n", outputKey10,
				"OutputKey11: %h \n", outputKey11,
			  );

	//inputKey = 128'h2b7e151628aed2a6abf7158809cf4f3c;
	//inputKey = 128'h3c4fcf098815f7aba6d2ae2816157e2b;
	//inputKey = 128'h5468617473206D79204B756E67204675;
	inputKey = 128'h754620676e754b20796d207374616854;
	#10;

end
endmodule
