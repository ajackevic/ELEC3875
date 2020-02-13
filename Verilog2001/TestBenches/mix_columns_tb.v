`timescale 1ns/100ps
module mix_columns_tb;

reg [7:0] inputValue;
reg [7:0] MSDValue;
wire [10:0] outputValue;


mix_columns dut (
	.inputValue	 (inputValue),
	.MSDValue    (MSDValue),
	.outputValue (outputValue)
);

initial begin
	$monitor("InputValue: %h \n", inputValue,
				"MSDValue: %h \n", MSDValue,
				"OutputValue: %h \n", outputValue,
			  );
	inputValue = 8'h66;
	MSDValue = 8'h0b;
	#10;
	
		
end
	
	
endmodule
