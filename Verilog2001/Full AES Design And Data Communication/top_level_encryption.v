
// This is the top-level module of the AES design and implementation on the FPGA. Through the instantiation
// of data communications, AES encryption and AES decryption a stable design was achieved of the algorithm.

module top_level_encryption(
	// Input of the base system clock, connected to Terasic 50MHz clock.
	input clock50MHz,
	// Listed ports below is utilised by data comms for the receiving and transmitting of data.
	input TXE,
	input RXF,
	output WR, 
	output RD,

	inout bit1,
	inout bit2,
	inout bit3,
	inout bit4,
	inout bit5,
	inout bit6,
	inout bit7,
	inout bit8
);


reg sendDataFlag;
reg nextDataBlockFlag;
reg encryptionFinishedFlag;
reg encryptionInputsLoadedFlag;
reg decryptionInputsLoadedFlag;

reg resetEncryptionModule;
reg resetDecryptionModule;

reg [127:0] encryptionkey;
reg [127:0] decryptionkey;
reg [127:0] encryptionDataIn;
reg [127:0] decryptionDataIn;
reg [127:0] UARTDataOut;
reg [103:0] cipherBlocksRemaining;

wire receivedKeyFlag;
wire receivedDataInFlag;
wire dataCommsObtainedSendFlag;
wire configDataFlag;
wire dataCommsObtainedNextBlockFlag;
wire dataCommsObtainedFinishedFlag;

wire [127:0] receivedDataIn;
wire [127:0] receivedKey;
wire [127:0] encryptionDataOut;
wire [127:0] decryptionDataOut;
wire [127:0] receivedConfigData;
wire dataEncryptedFlag;
wire dataDecryptedFlag;

// FSM states
reg[3:0] state;
reg[3:0] IDLE 						= 4'd0;
reg[3:0] NEXT_CYPHER_BLOCK 	= 4'd2;
reg[3:0] EXTRACT_CONFIG_DATA  = 4'd4;
reg[3:0] ENCRYPTION_IDLE		= 4'd5;
reg[3:0] DECRYPTION_IDLE		= 4'd6;
reg[3:0] FINISHED_ENCRYPTION  = 4'd8;
reg[3:0] SEND_DATA 				= 4'd9;


initial begin
	// Set the initial state to IDLE
	state = 3'd0;

	sendDataFlag = 0;
	nextDataBlockFlag = 0;
	encryptionInputsLoadedFlag = 0;
	decryptionInputsLoadedFlag = 0;
	resetEncryptionModule = 0;
	resetDecryptionModule = 0;
	encryptionFinishedFlag = 0;

	cipherBlocksRemaining = 104'd0;
	encryptionDataIn = 128'd0;
	decryptionDataIn = 128'd0;
	encryptionkey = 128'd0;
	decryptionkey = 128'd0;
	UARTDataOut = 128'd0;

end

// Instantiation of the Data communication module.
data_communication readAndWriteData(
	.clock50MHz							(clock50MHz),		 // Pin connection passed down from top
	.TXE									(TXE),				 // Pin connection passed down from top
	.RXF									(RXF),				 // Pin connection passed down from top
	.WR									(WR),					 // Pin connection passed down from top
	.RD									(RD),					 // Pin connection passed down from top

	.dataToSendFlag					(sendDataFlag),			 			// Input to data comms
	.dataOut128Bits					(UARTDataOut),				 			// Input to data comms
	.nextDataBlockFlag				(nextDataBlockFlag),					// Input to data comms
	.encryptionFinishedFlag			(encryptionFinishedFlag),			// Input to data comms

	.key									(receivedKey),			 				// Output from data comms
	.dataIn128Bits						(receivedDataIn),				 		// Output from data comms
	.configData128Bits				(receivedConfigData),		 		// Output from data comms
	.receivedKeyFlag					(receivedKeyFlag),					// Output from data comms
	.receivedDataFlag					(receivedDataInFlag),		 	   // Output from data comms
	.receivedSendDataFlag			(dataCommsObtainedSendFlag),		// Output from data comms
	.receivedConfigDataFlag			(configDataFlag),					   // Output from data comms
	.receivedNextBlockFlag			(dataCommsObtainedNextBlockFlag),// Output from data comms
	.receivedFinishedFlag			(dataCommsObtainedFinishedFlag), // Output from data comms

	.bit1									(bit1),				 // Pin connection passed down from top
	.bit2									(bit2),				 // Pin connection passed down from top
	.bit3									(bit3),				 // Pin connection passed down from top
	.bit4									(bit4),				 // Pin connection passed down from top
	.bit5									(bit5),				 // Pin connection passed down from top
	.bit6									(bit6),				 // Pin connection passed down from top
	.bit7									(bit7),				 // Pin connection passed down from top
	.bit8									(bit8)				 // Pin connection passed down from top
);

// Instantiation of the AES encryption module.
encryption encryptAES(
	.inputData				(encryptionDataIn),				// Input to encryption
	.key						(encryptionkey),					// Input to encryption
	.clock					(clock50MHz),						// Input to encryption
	.inputsLoadedFlag		(encryptionInputsLoadedFlag),	// Input to encryption
	.resetModule			(resetEncryptionModule),		// Input to encryption
	.outputData				(encryptionDataOut), 			// Output from encryption
	.dataEncryptedFlag	(dataEncryptedFlag)				// Output from encryption
);

// Instantiation of the AES decryption module.
decryption decryptAES(
	.inputData				(decryptionDataIn),				// Input to decryption
	.key						(decryptionkey),					// Input to decryption
	.clock					(clock50MHz),						// Input to decryption
	.inputsLoadedFlag		(decryptionInputsLoadedFlag),	// Input to decryption
	.resetModule			(resetDecryptionModule),		// Input to decryption
	.outputData				(decryptionDataOut),				// Output from decryption
	.dataDecryptedFlag	(dataDecryptedFlag)				// Output from decryption
);


always @(posedge clock50MHz) begin
	case(state)

		// The state will constantly loop round until configDataFlag is set high in The
		// data comms module, in which case the FSM will transition to EXTRACT_CONFIG_DATA.
		IDLE: begin
			sendDataFlag = 0;
			resetEncryptionModule = 0;
			resetDecryptionModule = 0;
			if(configDataFlag == 1) begin
				state = EXTRACT_CONFIG_DATA;
			end
		end

		EXTRACT_CONFIG_DATA: begin
		  // Extract the value from configData which states how many data blocks are expected to be
			// encrypted/decrypted.
			cipherBlocksRemaining = receivedConfigData[127:24];
			// If in encryption mode, transition to ENCRYPTION_IDLE.
			if(receivedConfigData[7:0] == 8'h30) begin		// Encryption - char value 0 = hex vale 30.
				state = ENCRYPTION_IDLE;
			end
			// If in encryption mode, transition to DECRYPTION_IDLE.
			if(receivedConfigData[7:0] == 8'h31) begin		// Decryption - char value 1 = hex vale 31.
				state = DECRYPTION_IDLE;
			end
		end

		ENCRYPTION_IDLE: begin
			sendDataFlag = 0;
			// Wait untill both DataIn and Key flags are high, in which case load the receivedDataIn
			// and receivedKey to the encryption module and transition to SEND_DATA.
			if((receivedKeyFlag == 1) & (receivedDataInFlag == 1)) begin
				encryptionInputsLoadedFlag = 1;
				encryptionDataIn = receivedDataIn;
				encryptionkey = receivedKey;
				state = SEND_DATA;
			end
		end

		DECRYPTION_IDLE: begin
			sendDataFlag = 0;
			// Wait untill both DataIn and Key flags are high, in which case load the receivedDataIn
			// and receivedKey to the decryption module and transition to SEND_DATA.
			if((receivedKeyFlag == 1) & (receivedDataInFlag == 1)) begin
				decryptionInputsLoadedFlag = 1;
				decryptionDataIn = receivedDataIn;
				decryptionkey = receivedKey;
				state = SEND_DATA;
			end
		end

		SEND_DATA: begin
			// Set inputs loaded flag low and await until the either dataEncryptedFlag or dataDecryptedFlag
			// is high, indicating data has been processed and is ready to be sent back. In which case
			// set sendDataFlag and await for confirmation back.
			decryptionInputsLoadedFlag = 0;
			encryptionInputsLoadedFlag = 0;

			if(receivedConfigData[7:0] == 8'h30) begin		// Encryption - char value 0 = hex vale 30.
				if(dataEncryptedFlag == 1) begin
					sendDataFlag = 1;
					// Send encryption data to the data comms module.
					UARTDataOut = encryptionDataOut;
				end
			end

			if(receivedConfigData[7:0] == 8'h31) begin		// Decryption - char value 1 = hex vale 31.
				if(dataDecryptedFlag == 1) begin
					sendDataFlag = 1;
					// Send decryption data to the data comms module.
					UARTDataOut = decryptionDataOut;
				end
			end

			// Await until dataCommsObtainedSendFlag is high, indicating the data comms has successfully received
			// sendDataFlag and sent the processed data to the external application.
			if(dataCommsObtainedSendFlag == 1) begin
				sendDataFlag = 0;
				// Subtract 1 from the total amount of remaining cipher blocks and transition to
				// NEXT_CYPHER_BLOCK state.
				cipherBlocksRemaining = cipherBlocksRemaining - 104'd1;
				state = NEXT_CYPHER_BLOCK;
			end
		end

		NEXT_CYPHER_BLOCK: begin
			// Check the amount of data blocks remaining in cipherBlocksRemaining, if it is equal to
			// zero transition to FINISHED_ENCRYPTION, else set nextDataBlockFlag high. This indicates
			// to data comms that the top level design is awaiting the next data block, thus the data comms
			// should receive the next 16 bytes and pass it on to the top level module.
			if(cipherBlocksRemaining >= 104'd1) begin
				nextDataBlockFlag = 1;
				// Once the data comms has acknowledged the nextDataBlockFlag, transition to either ENCRYPTION_IDLE
				// or DECRYPTION_IDLE depending on configData.
				if(dataCommsObtainedNextBlockFlag == 1) begin
					nextDataBlockFlag = 0;
					if(receivedConfigData[7:0] == 8'h30) begin	// Encryption mode
						state = ENCRYPTION_IDLE;
					end
					if(receivedConfigData[7:0] == 8'h31) begin	// Decryption mode
						state = DECRYPTION_IDLE;
					end
				end
			end
			if(cipherBlocksRemaining == 104'd0) begin
				state = FINISHED_ENCRYPTION;
			end
		end

		// Once all the data blocks have been processed. Set encryptionFinishedFlag high,
		// await confirmation from data comms. Once confirmed set all used variable in then
		// module to zero and then set reset signal high for both encryption and decryption
		// module.
		FINISHED_ENCRYPTION: begin
			encryptionFinishedFlag = 1;
			if(dataCommsObtainedFinishedFlag == 1) begin
				UARTDataOut = 128'd0;
				sendDataFlag = 0;
				encryptionInputsLoadedFlag = 0;
				decryptionInputsLoadedFlag = 0;
				encryptionDataIn = 128'd0;
				decryptionDataIn = 128'd0;
				encryptionkey = 128'd0;
				decryptionkey = 128'd0;
				cipherBlocksRemaining = 104'd0;
				nextDataBlockFlag = 0;
				encryptionFinishedFlag = 0;
				resetEncryptionModule = 1;
				resetDecryptionModule = 1;
				state = IDLE;
			end
		end

		default: begin
			state = IDLE;
		end
	endcase
end

endmodule
