`timescale 1ns/100ps
module sub_byte_tb;

	reg  [127:0] subByteInput;
	wire [127:0] subByteOutput;

	sub_byte dut(
		.subByteInput	(subByteInput),
		.subByteOutput	(subByteOutput)
	);
	
	initial begin
		$monitor("SubByte input: %h \n", subByteInput,
					"subByte output: %h \n", subByteOutput,
				  );
		subByteInput = 128'h001f0e543c4e08596e221b0b4774311a;
		#10;
	end
endmodule
