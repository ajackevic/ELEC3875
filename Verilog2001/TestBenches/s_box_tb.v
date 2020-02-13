`timescale 1ns/100ps
module s_box_tb;

reg [7:0] inputValue;
wire [7:0] outputValue;

s_box dut (
	.sboxInput		(inputValue),
	.sboxOutput	(outputValue)
);

initial begin
	
	$display("Time start: %d ns", $time);
	$monitor ("Time: %d ns\ Input: %h \ Output: %h", $time, inputValue, outputValue);
	inputValue = 8'h12;
	#10;
	inputValue = 8'hAD;
	#10;
	inputValue = 8'hA0;
	#10;
	inputValue = 8'h5F;
	#10;
	inputValue = 8'h9A;
	#10;
	inputValue = 8'h34;
	#10;
	inputValue = 8'h00;
	#10;
	inputValue = 8'h73;
	#10;
	inputValue = 8'hFF;
	#10;
	$display("Time end: %d ns", $time);
end
endmodule
	