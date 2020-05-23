
// This is the AES AddRoundKey module. At the posedge of startTransition
// the output is determined by the XOR opperation of inputData and the
// roundKey.

module add_round_key(
	input  [127:0] inputData,
	input  [127:0] roundKey,
	input startTransition,
	output reg [127:0] outputData
);

always @(posedge startTransition) begin
	outputData = inputData ^ roundKey;
end

endmodule
