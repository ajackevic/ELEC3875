
// This is the AES encryption module. The module starts initially in IDLE and will await for the
// inputLoadedFlag to go high (indicating that both the data block and the key are loaded) in 
// which case the script will call upon all other instantiated modules for the encryption of the
// data block. Once the data has been fully processed and is thus encrypted the data block is loaded
// to the output and the dataEncryptedFlag is set high to indicate the completion of encryption.

module encryption #(
	// Default number of rounds is set to 32. This was added for future designs which would require
   // to change this parameter to 40 (if 192-bit key length used) and 48 (if 192-bit key length used).
	parameter numRounds = 32
)(
	input  [127:0] inputData,
	input  [127:0] key,
	input clock,
	input inputsLoadedFlag,
	input resetModule,
	output reg [127:0] outputData,
	output reg dataEncryptedFlag
);

// startTransition is used as a control parameter for the instantiated modules.
reg startTransition[0:39];

reg [5:0] calledModulesValue;
reg [3:0] loopCounter;


reg startKeyGenFlag;
reg keyCreatedFlag;
reg [4:0] keyGenCounter;


// FSM states
reg [3:0] state;
reg [3:0] IDLE					= 4'd0;
reg [3:0] KEY_GEN				= 4'd1;
reg [3:0] ADDROUNDKEY_INIT	= 4'd2;
reg [3:0] SUBBYTE_LOOP		= 4'd3;
reg [3:0] SHIFTROW_LOOP		= 4'd4;
reg [3:0] MIXCOLUMNS_LOOP	= 4'd5;
reg [3:0] ADDROUNDKEY_LOOP	= 4'd6;
reg [3:0] SUBBYTE_END		= 4'd7;
reg [3:0] SHIFTROW_END		= 4'd8;
reg [3:0] ADDROUNDKEY_END	= 4'd9;
reg [3:0] STOP					= 4'd10;
reg [3:0] RESET				= 4'd11;


wire [127:0] roundKey [0:10];
wire [127:0] tempData [0:39];
wire [3:0] counter [0:32];

// Counter values used for the selection of the Rcon values. Declared as such as only one type 
// variable can be incremented in the for loop, thus this was deemed the easiest method to achieve
// the required results.
assign counter[0]  = 1;
assign counter[4]  = 2;
assign counter[8]  = 3;
assign counter[12] = 4;
assign counter[16] = 5;
assign counter[20] = 6;
assign counter[24] = 7;
assign counter[28] = 8;
assign counter[32] = 9;

initial begin
	// Set the initial state to IDLE
	state = 4'd0;
	keyCreatedFlag = 0;
	calledModulesValue = 6'd0;

	startKeyGenFlag = 0;
	keyGenCounter = 5'd0;
	loopCounter = 4'd0;
	
	outputData = 128'd0;
	
	startTransition[0]  = 1'b0;
	startTransition[1]  = 1'b0;
	startTransition[2]  = 1'b0;
	startTransition[3]  = 1'b0;
	startTransition[4]  = 1'b0;
	startTransition[5]  = 1'b0;
	startTransition[6]  = 1'b0;
	startTransition[7]  = 1'b0;
	startTransition[8]  = 1'b0;
	startTransition[9]  = 1'b0;
	startTransition[10] = 1'b0;
	startTransition[11] = 1'b0;
	startTransition[12] = 1'b0;
	startTransition[13] = 1'b0;
	startTransition[14] = 1'b0;
	startTransition[15] = 1'b0;
	startTransition[16] = 1'b0;
	startTransition[17] = 1'b0;
	startTransition[18] = 1'b0;
	startTransition[19] = 1'b0;
	startTransition[20] = 1'b0;
	startTransition[21] = 1'b0;
	startTransition[22] = 1'b0;
	startTransition[23] = 1'b0;
	startTransition[24] = 1'b0;
	startTransition[25] = 1'b0;
	startTransition[26] = 1'b0;
	startTransition[27] = 1'b0;
	startTransition[28] = 1'b0;
	startTransition[29] = 1'b0;
	startTransition[30] = 1'b0;
	startTransition[31] = 1'b0;
	startTransition[32] = 1'b0;
	startTransition[33] = 1'b0;
	startTransition[34] = 1'b0;
	startTransition[35] = 1'b0;
	startTransition[36] = 1'b0;
	startTransition[37] = 1'b0;
	startTransition[38] = 1'b0;
	startTransition[39] = 1'b0;
	
end


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


// The instantiation of 32 modules, including AddRoundKey, SubByte, ShiftRow and MiXColumn through the use
// generate. This was done in such a manner due to instabilities and inconsistencies experienced through 
// the use of 9 instantiated modules and tri-state buffers. Further elaboration on the matter is explained in 
// section 5.1.1.

genvar currentValue;
generate

	add_round_key AddRoundKeyInitRound(
		.inputData 			(inputData),
		.roundKey			(roundKey[0]),
		.startTransition	(startTransition[0]),
		.outputData  		(tempData[0])
	);

	for (currentValue = 0; currentValue <= numRounds; currentValue = currentValue + 4) begin : genVarLoopEncrypt
		sub_byte SubByte(
			.subByteInput 		(tempData[currentValue]),
			.startTransition	(startTransition[currentValue + 1]),
			.subByteOutput 	(tempData[currentValue + 1])
		);

		shift_row shiftRow(
			.inputData			(tempData[currentValue + 1]),
			.startTransition	(startTransition[currentValue + 2]),
			.outputData 		(tempData[currentValue + 2])
		);

		mix_columns #(
		.ENCRYPT 				 (1)
		) MixColumns (
			.inputData			 (tempData[currentValue + 2]),
			. startTransition	 (startTransition[currentValue + 3]),
			.outputData 		 (tempData[currentValue + 3])
		);

		add_round_key AddRoundKey(
			.inputData			(tempData[currentValue + 3]),
			.roundKey   		(roundKey[counter[currentValue]]),
			.startTransition	(startTransition[currentValue + 4]),
			.outputData			(tempData[currentValue + 4])
		);
	end

	sub_byte SubByteLastRound(
		.subByteInput 		(tempData[36]),
		.startTransition	(startTransition[37]),
		.subByteOutput 	(tempData[37])
	);

	shift_row shiftRowLastRound(
		.inputData			(tempData[37]),
		.startTransition	(startTransition[38]),
		.outputData			(tempData[38])
	);

	add_round_key AddRoundKeyLastRound(
		.inputData			(tempData[38]),
		.roundKey  			(roundKey[10]),
		.startTransition	(startTransition[39]),
		.outputData 		(tempData[39])
	);

endgenerate


always @(posedge clock) begin
	case(state)
		
		// The IDLE state will constantly loop round until either data is reset or input data has been loaded.
		// When data has been loaded, it will check if round keys have already been created in the previous 
      // cycle, if so it will transition to ADDROUNDKEY_INIT and miss the KEY_GEN state.
		IDLE: begin
			dataEncryptedFlag = 1'b0;
			if(resetModule == 1) begin
				state = RESET;
			end
			
			if(inputsLoadedFlag == 1) begin
				if(keyCreatedFlag == 0) begin
					state = KEY_GEN;
				end
				if(keyCreatedFlag == 1) begin
					state = ADDROUNDKEY_INIT;
				end
			end
		end
		
		KEY_GEN: begin
			startKeyGenFlag = 1'b1;
			if(keyGenCounter == 5'd2) begin
				keyGenCounter = 5'd0;
				startKeyGenFlag = 1'b0;
				keyCreatedFlag = 1'b1;
				state = ADDROUNDKEY_INIT;
			end
			keyGenCounter = keyGenCounter + 5'd1;
		end
		
		ADDROUNDKEY_INIT: begin
			
			startTransition[0] = 1'b1;
			calledModulesValue = calledModulesValue + 6'd1;
			state = SUBBYTE_LOOP;
		end	
		
		SUBBYTE_LOOP: begin
			startTransition[calledModulesValue - 1] = 1'b0;			
			calledModulesValue = calledModulesValue + 6'd1;
			startTransition[calledModulesValue] = 1'b1;	
			loopCounter = loopCounter + 4'd1;
			state = SHIFTROW_LOOP;
		end
		
		SHIFTROW_LOOP: begin
			startTransition[calledModulesValue - 1] = 1'b0;	
			calledModulesValue = calledModulesValue + 6'd1;
			startTransition[calledModulesValue] = 1'b1;	
			state = MIXCOLUMNS_LOOP;	
		end
		
		MIXCOLUMNS_LOOP: begin
			startTransition[calledModulesValue - 1] = 1'b0;	
			calledModulesValue = calledModulesValue + 6'd1;
			startTransition[calledModulesValue] = 1'b1;	
			state = ADDROUNDKEY_LOOP;
		end
		
		ADDROUNDKEY_LOOP: begin
			startTransition[calledModulesValue - 1] = 1'b0;	
			calledModulesValue = calledModulesValue + 6'd1;
			startTransition[calledModulesValue] = 1'b1;	
			// If loopCounter is less than 9, transition to SUBEBYTE_LOOP and loop round till loopCounter is 
         // equal to 9, in which case transition to the last 3 end modules
			if(loopCounter == 4'd9) begin
				state = SUBBYTE_END;
			end else begin
				state = SUBBYTE_LOOP;
			end
		end
		
		SUBBYTE_END: begin
			startTransition[calledModulesValue - 1] = 1'b0;	
			calledModulesValue = calledModulesValue + 6'd1;
			startTransition[calledModulesValue] = 1'b1;	
			state = SHIFTROW_END;
		end
		
		SHIFTROW_END: begin
			startTransition[calledModulesValue - 1] = 1'b0;	
			calledModulesValue = calledModulesValue + 6'd1;
			startTransition[calledModulesValue] = 1'b1;	
			state = ADDROUNDKEY_END;
		end
		
		ADDROUNDKEY_END: begin
			startTransition[calledModulesValue - 1] = 1'b0;	
			calledModulesValue = calledModulesValue + 6'd1;
			startTransition[calledModulesValue] = 1'b1;	
			state = STOP;
		end
		
		// Load the output data, set dataEncryptedFlag high and reset all used variables apart from keyCreatedFlag.
      // Then transition to IDLE and await further input.
		STOP: begin
			outputData = tempData[39];
			dataEncryptedFlag = 1'b1;
			loopCounter = 4'd0;
			keyGenCounter = 5'd0;
			startTransition[39] = 1'b0;
			calledModulesValue = 6'd0;
			
			startTransition[0]  = 1'b0;
			startTransition[1]  = 1'b0;
			startTransition[2]  = 1'b0;
			startTransition[3]  = 1'b0;
			startTransition[4]  = 1'b0;
			startTransition[5]  = 1'b0;
			startTransition[6]  = 1'b0;
			startTransition[7]  = 1'b0;
			startTransition[8]  = 1'b0;
			startTransition[9]  = 1'b0;
			startTransition[10] = 1'b0;
			startTransition[11] = 1'b0;
			startTransition[12] = 1'b0;
			startTransition[13] = 1'b0;
			startTransition[14] = 1'b0;
			startTransition[15] = 1'b0;
			startTransition[16] = 1'b0;
			startTransition[17] = 1'b0;
			startTransition[18] = 1'b0;
			startTransition[19] = 1'b0;
			startTransition[20] = 1'b0;
			startTransition[21] = 1'b0;
			startTransition[32] = 1'b0;
			startTransition[33] = 1'b0;
			startTransition[34] = 1'b0;
			startTransition[35] = 1'b0;
			startTransition[36] = 1'b0;
			startTransition[37] = 1'b0;
			startTransition[38] = 1'b0;
			startTransition[39] = 1'b0;
			
			state = IDLE;
		end
		
		// Reset all variables used by the decryption module and transitions to IDLE and then await further input.
		RESET: begin
			keyCreatedFlag = 0;
			outputData = 128'd0;
			dataEncryptedFlag = 0;
			loopCounter = 4'd0;
			keyGenCounter = 5'd0;
			calledModulesValue = 6'd0;
			
			startTransition[0]  = 1'b0;
			startTransition[1]  = 1'b0;
			startTransition[2]  = 1'b0;
			startTransition[3]  = 1'b0;
			startTransition[4]  = 1'b0;
			startTransition[5]  = 1'b0;
			startTransition[6]  = 1'b0;
			startTransition[7]  = 1'b0;
			startTransition[8]  = 1'b0;
			startTransition[9]  = 1'b0;
			startTransition[10] = 1'b0;
			startTransition[11] = 1'b0;
			startTransition[12] = 1'b0;
			startTransition[13] = 1'b0;
			startTransition[14] = 1'b0;
			startTransition[15] = 1'b0;
			startTransition[16] = 1'b0;
			startTransition[17] = 1'b0;
			startTransition[18] = 1'b0;
			startTransition[19] = 1'b0;
			startTransition[20] = 1'b0;
			startTransition[21] = 1'b0;
			startTransition[32] = 1'b0;
			startTransition[33] = 1'b0;
			startTransition[34] = 1'b0;
			startTransition[35] = 1'b0;
			startTransition[36] = 1'b0;
			startTransition[37] = 1'b0;
			startTransition[38] = 1'b0;
			startTransition[39] = 1'b0;
			
			state = IDLE;
		end
		
		default: begin
			state = IDLE;
			dataEncryptedFlag = 1'b1;
			loopCounter = 4'd0;
			keyGenCounter = 5'd0;
			startTransition[39] = 1'b0;
			calledModulesValue = 6'd0;
		end
		
	endcase
end
endmodule
