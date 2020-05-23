
// This module is a test bench for the decryption pipelined design. The output of test 
// bench has to be visually seen in ModelSim. The expected results is a pipelined system
// with the correct decrypted output. Aes.online-domain should be used as confirmation
// of the correct decrypted data.

`timescale 1 ns/100 ps

module decryption_tb;

reg clock50MHz;
reg [127:0] inputData;
reg [127:0] key;
reg inputsLoadedFlag;
wire [127:0] outputData;

decryption dut(
	.inputData			 (inputData),
	.key					 (key),
	.clock				 (clock50MHz),
	.inputsLoadedFlag  (inputsLoadedFlag),
	.outputData			 (outputData)
);

// Creating the prameters required for the 50MHz clock, and the stoppage of the test bench.
localparam NUM_CYCLES = 200000;
localparam CLOCK_FREQ = 50000000;
real HALF_CLOCK_PERIOD = (1000000000.0 / $itor(CLOCK_FREQ)) / 2.0;
integer half_cycle = 0;

initial begin 
	clock50MHz = 1'b0;
	inputData = 128'd0;
	key  = 128'd0;
	inputsLoadedFlag = 0;
end

initial begin 
    // Input values are loaded. A new data block is loaded every clock cycle to 
    // show the full working utilisation of the pipelined AES design.
	key = 128'h754620676e754b20796d207374616854;		
	inputsLoadedFlag = 1;
	// Takes 24 clock cycles before the decryption module is ready to accept the data
	repeat(24) @ (posedge clock50MHz);
	inputData = 128'h00000000000000000000000000000000;	
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h11111111111111111111111111111111;	
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h22222222222222222222222222222222;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h33333333333333333333333333333333;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h44444444444444444444444444444444;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h55555555555555555555555555555555;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h66666666666666666666666666666666;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h77777777777777777777777777777777;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h88888888888888888888888888888888;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h99999999999999999999999999999999;  
	repeat(1) @ (posedge clock50MHz);
   inputData = 128'h41414141414141414141414141414141;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h42424242424242424242424242424242;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h43434343434343434343434343434343;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h44444444444444444444444444444444;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h45454545454545454545454545454545;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h46464646464646464646464646464646;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h47474747474747474747474747474747;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h48484848484848484848484848484848;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h49494949494949494949494949494949;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C4C;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E4E;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h50505050505050505050505050505050;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h51515151515151515151515151515151;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h52525252525252525252525252525252;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h53535353535353535353535353535353;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h54545454545454545454545454545454;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h55555555555555555555555555555555;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h56565656565656565656565656565656;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h57575757575757575757575757575757;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h58585858585858585858585858585858;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h59595959595959595959595959595959;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h5C5C5C5C5C5C5C5C5C5C5C5C5C5C5C5C;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D5D;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F5F;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h60606060606060606060606060606060;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h61616161616161616161616161616161;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h62626262626262626262626262626262;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h63636363636363636363636363636363;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h64646464646464646464646464646464;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h65656565656565656565656565656565;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h66666666666666666666666666666666;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h67676767676767676767676767676767;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h68686868686868686868686868686868;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h69696969696969696969696969696969;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E6E;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h70707070707070707070707070707070;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h71717171717171717171717171717171;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h72727272727272727272727272727272;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h73737373737373737373737373737373;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h74747474747474747474747474747474;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h75757575757575757575757575757575;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h76767676767676767676767676767676;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h77777777777777777777777777777777;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h78787878787878787878787878787878;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h79797979797979797979797979797979;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A7A;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B7B;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h7C7C7C7C7C7C7C7C7C7C7C7C7C7C7C7C;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D7D;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E;
	repeat(1) @ (posedge clock50MHz);
	inputData = 128'h7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F;
end


always begin
	#(HALF_CLOCK_PERIOD);
	clock50MHz = ~clock50MHz;
	half_cycle = half_cycle + 1;
	
	if (half_cycle == (2 * NUM_CYCLES)) begin		
		// Stop simulation test
		$stop;
	end
	
end

endmodule
