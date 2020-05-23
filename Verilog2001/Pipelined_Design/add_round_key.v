module add_round_key(
	input  [127:0] inputData,
	input  [127:0] roundKey,
	input startTransition,
	input clock,
	output reg [127:0] outputData
);

always @(posedge clock) begin
	if(startTransition == 1) begin
		outputData = inputData ^ roundKey;
	end
end

endmodule
