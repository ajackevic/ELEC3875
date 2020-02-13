`timescale 1ns/100ps
module add_round_key_tb;

reg  [127:0] roundKey;
reg  [127:0] roundData;
wire [127:0] addRoundKeyOutput;

add_round_key dut (
	.data						(roundData),
	.roundKey				(roundKey),
	.addRoundKeyOutput	(addRoundKeyOutput)
);

initial begin
	$monitor("RoundData: %h \n", roundData,
				"RoundKey: %h \n", roundKey,
				"AddRoundKeyOutput: %h \n", addRoundKeyOutput,
			  );
	roundKey = 128'h5468617473206D79204B756E67204675;
	roundData = 128'h54776F204F6E65204E696E652054776F;
	#10;
end
endmodule

	