
// This is the main decryption module. It uses pipelining to dramatically increase the speed,
// when in comparison to the previous design. The module starts initially in IDLE and will await 
// for the key and the first data block to be loaded. Since all the outputs of the sub-modules 
// are connected to the inputs on the next corresponding sub-module, a new data block can be constantly 
// applied to the start of the chain with the correct processed output being supplied to the corresponding
// module at the start of the next clock cycle. Due to such it takes 32 clock cycles  + 22 key_creation clock 
// cyclesfor the cyphertext to be processed after the plaintext has been applied. Once the round keys are 
// created 32 data block can be in the process of being decrypted at the same time. 

// The value is 32 and not, 40 due to 2 cycles required for the clock and since SubByte module not requiring
// a startTransition signal for the execution of the module.

// The full functionality of pipelining is only available due to the instantiation of the 40 sub-modules.

module decryption #(
	// Default number of rounds is set to 34. This was added for future designs which would require
   // to change this parameter to 44 (if 192-bit key length used) and 52 (if 192-bit key length used).
	parameter numRounds = 34
)(
	input [127:0] inputData,
	input [127:0] key,
	input clock,
	input inputsLoadedFlag,
	output reg [127:0] outputData
);
	
reg startKeyGenFlag;
reg keyCreatedFlag;

reg [5:0] counterOut;
reg [3:0] state;
reg [4:0] keyGenCounter;

reg [127:0] inputDataIn;

// startTransition is used as a control parameter for the instantiated modules.
reg startTransition;

reg [3:0] IDLE					= 4'd0;
reg [3:0] KEY_GEN				= 4'd1;
reg [3:0] START_DECRYPTION = 4'd2;

wire [127:0] roundKey [0:10];
wire [127:0] tempData [0:39];
wire [3:0] counter [0:34];


// Counter values used for the selection of the Rcon values. Declared as such as only one type 
// variable can be incremented in the for loop, thus this was deemed the easiest method to achieve
// the required results.
assign counter[2]  = 9;
assign counter[6]  = 8;
assign counter[10] = 7;
assign counter[14] = 6;
assign counter[18] = 5;
assign counter[22] = 4;
assign counter[26] = 3;
assign counter[30] = 2;
assign counter[34] = 1;

initial begin
	// Set the initial state to IDLE
	state = 4'd0;
	keyCreatedFlag = 0;

	startKeyGenFlag = 0;
	keyGenCounter = 5'd0;
	counterOut = 6'd0;
	
	inputDataIn = 128'd0;
	outputData = 128'h0;
	
	startTransition = 1'b0;
end

// Instantiation of the key_creation module.
key_creation keyGen(
	.clock				(clock),
	.startTransition	(startKeyGenFlag),
	.roundKeyInput		(key),
	.roundKeyOutput1	(roundKey[0]),	
	.roundKeyOutput2	(roundKey[1]),
	.roundKeyOutput3	(roundKey[2]),
	.roundKeyOutput4	(roundKey[3]),
	.roundKeyOutput5	(roundKey[4]),
	.roundKeyOutput6	(roundKey[5]),
	.roundKeyOutput7	(roundKey[6]),
	.roundKeyOutput8	(roundKey[7]),
	.roundKeyOutput9	(roundKey[8]),
	.roundKeyOutput10	(roundKey[9]),
	.roundKeyOutput11	(roundKey[10])
);

// The instantiation of 40 modules, including AddRoundKey, SubByte, ShiftRow and MiXColumn through the use
// generate. All (apart from SubByte) sub-modules require the use the clock signal and startTransition to 
// execute its corresponding operation. The sub-modules are identical in the previous design, except that
// module operates on the positive edge of the clock signal, and the operation of the module will only start if 
// startTransition is equal to 1.
genvar currentValue;
generate 
	add_round_key AddRoundKeyLastRound(
		.inputData 	 		(inputDataIn),
		.roundKey	 		(roundKey[10]),
		.startTransition	(startTransition),
		.clock				(clock),
		.outputData  		(tempData[0])
	);
	inv_shift_row shiftRowLastRound(
		.inputData	 		(tempData[0]),
		.startTransition	(startTransition),
		.clock				(clock),
		.outputData 		(tempData[1])
	);
	inv_sub_byte SubByteLastRound(
		.inputData  		(tempData[1]), 
		.startTransition	(startTransition),
		.clock				(clock),
		.outputData 		(tempData[2])
	);
	for (currentValue = 2; currentValue <= numRounds; currentValue = currentValue + 4) begin : decryptionLoop
		add_round_key InvAddRoundKey(
			.inputData			(tempData[currentValue]),
			.roundKey  			(roundKey[counter[currentValue]]), 
			.startTransition	(startTransition),
			.clock				(clock),
			.outputData 		(tempData[currentValue + 1])
		);
		
		mix_columns #(
			.ENCRYPT 			(0)
		)MixColumns(
			.inputData			(tempData[currentValue + 1]),
			.startTransition	(startTransition),
			.clock				(clock),
			.outputData 		(tempData[currentValue + 2])
		);
		
		inv_shift_row shiftRow(
			.inputData			(tempData[currentValue + 2]),
			.startTransition	(startTransition),
			.clock				(clock),
			.outputData 		(tempData[currentValue + 3])
		);
		
		inv_sub_byte SubByte(
			.inputData  		(tempData[currentValue + 3]),
			.startTransition	(startTransition),	
			.clock				(clock),
			.outputData 		(tempData[currentValue + 4])
		);	
	end 	
	
	add_round_key AddRoundKeyInitRound(
		.inputData			(tempData[38]),
		.roundKey   		(roundKey[0]), 
		.startTransition	(startTransition),
		.clock				(clock),
		.outputData 		(tempData[39])
	);
endgenerate


always @(posedge clock) begin
	case(state)
	
		// The IDLE state will constantly loop round until both the key and the data block are loaded, in which 
		// case the inputsLoadedFlag is set high by the top-level module.
		IDLE: begin		
			if(inputsLoadedFlag == 1) begin
				if(keyCreatedFlag == 0) begin
					state = KEY_GEN;
				end
			end
		end
		
		// Create the round key used by the AES encryption. Requires 2 two clock cyles wait for the first round 
      // key to be available. It should be noted the key_creation module operates in parallel to this module.
		KEY_GEN: begin
			startKeyGenFlag = 1'b1;
			if(keyGenCounter == 5'd22) begin
				keyGenCounter = 5'd0;
				startKeyGenFlag = 1'b0;
				keyCreatedFlag = 1'b1;
				state = START_DECRYPTION;
			end
			keyGenCounter = keyGenCounter + 5'd1;
		end
		
		// Once keys have been created, set startTransition high.
		// Due to the output being the last processed value, tempData[39], the first output will only be aviable 
		// after 32 clock cycles, thus the use of counterOut.
		START_DECRYPTION: begin
			inputDataIn = inputData;
			startTransition = 1'b1;
			
			if(counterOut <= 31) begin
				counterOut = counterOut + 6'd1;
			end 
			if(counterOut == 32) begin
				outputData = tempData[39];
			end
		end	
		
		default: begin
			state = IDLE;
			keyGenCounter = 5'd0;
		end
	endcase
end
endmodule

