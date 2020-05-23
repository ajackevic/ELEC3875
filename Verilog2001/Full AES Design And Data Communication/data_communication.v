
// This is the data communication module. Data is received and transmitted through the 
// use of this module, with the acquired and sent data coming from the top-level module.

module data_communication(
	input clock50MHz,

	input TXE,
	input RXF,
	output WR,
	output RD,

	input [127:0] dataOut128Bits,
	input dataToSendFlag,
	input nextDataBlockFlag,
	input encryptionFinishedFlag,

	output reg [127:0] configData128Bits,
	output reg [127:0] key,
	output reg [127:0] dataIn128Bits,
	
	output reg receivedKeyFlag,
	output reg receivedDataFlag,
	output reg receivedConfigDataFlag,
	output reg receivedSendDataFlag,
	output reg receivedNextBlockFlag,
	output reg receivedFinishedFlag,

	inout bit1,
	inout bit2,
	inout bit3,
	inout bit4,
	inout bit5,
	inout bit6,
	inout bit7,
	inout bit8
);

reg enableOutputs;
reg enableRD;
reg enableWR;
reg everySecondByte;

reg [7:0] FIFOBuffer [0:15];
reg [7:0] FIFODataOut;
reg [4:0] inputCounter;
reg [4:0] outputCounter;
reg [3:0] state;

// FSM states
reg [3:0] IDLE 			      = 4'd0;
reg [3:0] RECEIVE_DATA	  	   = 4'd1;
reg [3:0] LOAD_DATA_TO_SEND   = 4'd2;
reg [3:0] SEND_DATA			   = 4'd3;
reg [3:0] OBTAIN_KEY		      = 4'd4;
reg [3:0] LOAD_INPUT_DATA     = 4'd5;
reg [3:0] OBTAIN_CONFIG_DATA  = 4'd6;
reg [3:0] ENCRYPTION_FINISHED = 4'd7;
reg [3:0] STOP					   = 4'd8;

wire clock1MHz;

clock_signals callClock(
	.clock50MHz	(clock50MHz),
	.clock1MHz	(clock1MHz)
);

// Tri-state buffers are used to alternate bitN from read to write. By
// setting enableOutputs to zero, bitN is of high input impedance. Once
// enableOutputs are is set high, bitN acts as an output.
assign bit1 = enableOutputs ? FIFODataOut[0] : 1'bz;
assign bit2 = enableOutputs ? FIFODataOut[1] : 1'bz;
assign bit3 = enableOutputs ? FIFODataOut[2] : 1'bz;
assign bit4 = enableOutputs ? FIFODataOut[3] : 1'bz;
assign bit5 = enableOutputs ? FIFODataOut[4] : 1'bz;
assign bit6 = enableOutputs ? FIFODataOut[5] : 1'bz;
assign bit7 = enableOutputs ? FIFODataOut[6] : 1'bz;
assign bit8 = enableOutputs ? FIFODataOut[7] : 1'bz;

// Tri-state buffers are used for the read (RD) and write (WR) pins. The connected
// external component, UM245R, requires a high to low line transition for the read of data,
// whilst for a write its a low to high. It is because of this why the default values of RD
// is 1 and WR is 0.
assign RD = enableRD ? clock1MHz : 1'b1;
assign WR = enableWR ? clock1MHz : 1'b0;


initial begin
	// Set the initial state to IDLE
	state = 4'd0;

	key = 128'd0;
	configData128Bits = 128'd0;
	dataIn128Bits = 128'd0;

	receivedKeyFlag = 0;
	receivedConfigDataFlag = 0;
	receivedDataFlag = 0;
	receivedSendDataFlag = 0;
	receivedNextBlockFlag = 0;
	receivedFinishedFlag = 0;

	enableRD = 0;
	enableWR = 0;
	enableOutputs = 0;

	everySecondByte = 0;
	inputCounter = 5'd0;
	outputCounter = 5'd0;
	FIFODataOut = 8'd0;

	FIFOBuffer[0]  = 8'd0;
	FIFOBuffer[1]  = 8'd0;
	FIFOBuffer[2]  = 8'd0;
	FIFOBuffer[3]  = 8'd0;
	FIFOBuffer[4]  = 8'd0;
	FIFOBuffer[5]  = 8'd0;
	FIFOBuffer[6]  = 8'd0;
	FIFOBuffer[7]  = 8'd0;
	FIFOBuffer[8]  = 8'd0;
	FIFOBuffer[9]  = 8'd0;
	FIFOBuffer[10] = 8'd0;
	FIFOBuffer[11] = 8'd0;
	FIFOBuffer[12] = 8'd0;
	FIFOBuffer[13] = 8'd0;
	FIFOBuffer[14] = 8'd0;
	FIFOBuffer[15] = 8'd0;
end


always @(posedge clock1MHz) begin
	case(state)

		IDLE: begin
			// If the UM245R device has available data (RXF is equal to zero) and receivedConfigDataFlag
			// has not already been set high, it indicates the receiving information is the 16-byte configData,
			// thus the state will transition to OBTAIN_CONFIG_DATA to acquire the and store the received data.
			if(RXF == 0) begin
				if(receivedConfigDataFlag == 0) begin
					everySecondByte = 0;
					state = OBTAIN_CONFIG_DATA;
				end
			end

			// If there's space available on the UM245R transmitter FIFO, and dataToSendFlag is set high by the
			// top-level module, data is available to be sent, thus acknowledge the request and transition to
			// LOAD_DATA_TO_SEND to send the processed data from the device.
			if((dataToSendFlag == 1) & (TXE == 0)) begin
				receivedDataFlag = 0;
				receivedNextBlockFlag = 0;
				receivedSendDataFlag = 1;
				dataIn128Bits = 128'd0;
				state = LOAD_DATA_TO_SEND;
			end

			// If there is available data to be collected in the UM245R device and the nextDataBlockFlag has been
			// set high by the top-level module, acknowledge the request and transition to RECEIVE_DATA to collect
			// the incoming 16 bytes.
			if((nextDataBlockFlag == 1) & (RXF == 0)) begin
				everySecondByte = 0;
				receivedSendDataFlag = 0;
				receivedDataFlag = 0;
				receivedNextBlockFlag = 1;
				state = RECEIVE_DATA;
			end

			// If encryptionFinishedFlag is set high by the top-level module, once again acknowledge the request and
			// transition to ENCRYPTION_FINISHED state for the reset of all stored variables used for this module.
			if(encryptionFinishedFlag == 1) begin
				receivedFinishedFlag = 1;
				receivedConfigDataFlag = 0;
				state = ENCRYPTION_FINISHED;
			end
		end

		OBTAIN_CONFIG_DATA : begin
			// If the configData has not already been received, as receivedConfigDataFlag is low,
			// transition to RECEIVE_DATA state to collect the corresponding configData.
			if(receivedConfigDataFlag == 0) begin
				state = RECEIVE_DATA;
			end

			// Once the configData is acquired, load the stored from the FIFOBuffers to the
			// corresponding byte in the configData128Bits variable, then transition to OBTAIN_KEY state.
			if(receivedConfigDataFlag == 1) begin
				configData128Bits[7:0]     = FIFOBuffer[0];
				configData128Bits[15:8]    = FIFOBuffer[1];
				configData128Bits[23:16]   = FIFOBuffer[2];
				configData128Bits[31:24]   = FIFOBuffer[3];
				configData128Bits[39:32]   = FIFOBuffer[4];
				configData128Bits[47:40]   = FIFOBuffer[5];
				configData128Bits[55:48]   = FIFOBuffer[6];
				configData128Bits[63:56]   = FIFOBuffer[7];
				configData128Bits[71:64]   = FIFOBuffer[8];
				configData128Bits[79:72]   = FIFOBuffer[9];
				configData128Bits[87:80]   = FIFOBuffer[10];
				configData128Bits[95:88]   = FIFOBuffer[11];
				configData128Bits[103:96]  = FIFOBuffer[12];
				configData128Bits[111:104] = FIFOBuffer[13];
				configData128Bits[119:112] = FIFOBuffer[14];
				configData128Bits[127:120] = FIFOBuffer[15];

				FIFOBuffer[0]  = 8'd0;
				FIFOBuffer[1]  = 8'd0;
				FIFOBuffer[2]  = 8'd0;
				FIFOBuffer[3]  = 8'd0;
				FIFOBuffer[4]  = 8'd0;
				FIFOBuffer[5]  = 8'd0;
				FIFOBuffer[6]  = 8'd0;
				FIFOBuffer[7]  = 8'd0;
				FIFOBuffer[8]  = 8'd0;
				FIFOBuffer[9]  = 8'd0;
				FIFOBuffer[10] = 8'd0;
				FIFOBuffer[11] = 8'd0;
				FIFOBuffer[12] = 8'd0;
				FIFOBuffer[13] = 8'd0;
				FIFOBuffer[14] = 8'd0;
				FIFOBuffer[15] = 8'd0;

				state = OBTAIN_KEY;
			end
		end

		OBTAIN_KEY: begin
			// If the keyData has not already been received, as receivedKeyFlag is low,
			// transition to RECEIVE_DATA state to collect the corresponding keyData.
			if(receivedKeyFlag == 0) begin
				state = RECEIVE_DATA;
			end

			// Once the keyData is acquired, load the stored from the FIFOBuffers to the
			// corresponding byte in the key variable, then transition to RECEIVE_DATA state.
			if(receivedKeyFlag == 1) begin
				key[7:0]     = FIFOBuffer[0];
				key[15:8]    = FIFOBuffer[1];
				key[23:16]   = FIFOBuffer[2];
				key[31:24]   = FIFOBuffer[3];
				key[39:32]   = FIFOBuffer[4];
				key[47:40]   = FIFOBuffer[5];
				key[55:48]   = FIFOBuffer[6];
				key[63:56]   = FIFOBuffer[7];
				key[71:64]   = FIFOBuffer[8];
				key[79:72]   = FIFOBuffer[9];
				key[87:80]   = FIFOBuffer[10];
				key[95:88]   = FIFOBuffer[11];
				key[103:96]  = FIFOBuffer[12];
				key[111:104] = FIFOBuffer[13];
				key[119:112] = FIFOBuffer[14];
				key[127:120] = FIFOBuffer[15];

				FIFOBuffer[0]  = 8'd0;
				FIFOBuffer[1]  = 8'd0;
				FIFOBuffer[2]  = 8'd0;
				FIFOBuffer[3]  = 8'd0;
				FIFOBuffer[4]  = 8'd0;
				FIFOBuffer[5]  = 8'd0;
				FIFOBuffer[6]  = 8'd0;
				FIFOBuffer[7]  = 8'd0;
				FIFOBuffer[8]  = 8'd0;
				FIFOBuffer[9]  = 8'd0;
				FIFOBuffer[10] = 8'd0;
				FIFOBuffer[11] = 8'd0;
				FIFOBuffer[12] = 8'd0;
				FIFOBuffer[13] = 8'd0;
				FIFOBuffer[14] = 8'd0;
				FIFOBuffer[15] = 8'd0;

				state = RECEIVE_DATA;
			end
		end

		RECEIVE_DATA: begin
			if(RXF == 0) begin
			// If data is aviable to be collected from the UM245R device, enable the connection of RD to
			// the 1MHz clock, for the collection of data. The state will loop round until all 16 bytes have been received.
				enableRD = 1;

				// It takes one clock cycle for the UM245R to acknowledge the read requirement, thus the if statement
				// loads the 8 bits to the corresponding FIFOBuffer value, everySecondByte value. This is so due to the
				// first byte being useless as the UM245R has not had enough time to respond for the loading of a single
				// byte. The reason why this is required is because the FPGA receives a single byte at a time not a stream
				// of 16 bytes in one single go.
				if((everySecondByte == 1) & (inputCounter <= 5'd15)) begin

					// Load the values of the 8 bits (a byte) to the corresponding FIFOBuffer value.
					FIFOBuffer[inputCounter] = {bit8, bit7, bit6, bit5, bit4, bit3, bit2, bit1};

					// Increment inputCounter and check if the value is equal to 16, indicating all the 128 bit has been received.
					// Once equal to 16 set enableRD low, thus setting RD pin high through its default value in the tri-state
					// buffer declaration.
					inputCounter = inputCounter + 5'd1;
					if(inputCounter == 5'd16) begin
						inputCounter = 5'd0;
						enableRD = 0;
						// The format of the sent data from the external user application will first be the configData, then
						// the key and followed lastly by the data block. The configData and key have to be only sent once,
						// then after that all received to FSM can only be data blocks, this is so until the module is reset.

						// With the received 16-byte data, if the receivedKeyFlag and receivedConfigDataFlag are high, both were
						// already acquired thus the received data is a data block and the state will transition to LOAD_INPUT_DATA
						// to load the acquired data.
						if((receivedKeyFlag == 1) & (receivedConfigDataFlag == 1)) begin
							state = LOAD_INPUT_DATA;
						end

						// If receivedConfigDataFlag is high but receivedKeyFlag is low, the data is key of the cypher, thus the
						// FSM will transition to OBTAIN_KEY to load the key value from the FIFOBuffers to the variable. The
						// receivedKeyFlag is set high so that for the next time data is received, it has to be a data block for
						// the cypher.
						if((receivedKeyFlag == 0) & (receivedConfigDataFlag == 1)) begin
							receivedKeyFlag = 1;
							state = OBTAIN_KEY;
						end

						// If receivedConfigDataFlag is low, the received data is the configData, thus transition to
						// OBTAIN_CONFIG_DATA to load the FIFOBuffers to the corresponding data variable.
						if(receivedConfigDataFlag == 0) begin
							receivedConfigDataFlag = 1;
							state = OBTAIN_CONFIG_DATA;
						end
					end
				end
				// Togle everySecondByte every clock cycle;
				everySecondByte =~ everySecondByte;
			end
			// If no data is available in UM245R set RD high.
			if(RXF == 1) begin
				enableRD = 0;
			end
		end

		LOAD_INPUT_DATA: begin
				// Load the input received data from the FIFOBuffer to dataIn128Bits and then clear all values
				// in FIFOBuffers.
				dataIn128Bits[7:0]     = FIFOBuffer[0];
				dataIn128Bits[15:8]    = FIFOBuffer[1];
				dataIn128Bits[23:16]   = FIFOBuffer[2];
				dataIn128Bits[31:24]   = FIFOBuffer[3];
				dataIn128Bits[39:32]   = FIFOBuffer[4];
				dataIn128Bits[47:40]   = FIFOBuffer[5];
				dataIn128Bits[55:48]   = FIFOBuffer[6];
				dataIn128Bits[63:56]   = FIFOBuffer[7];
				dataIn128Bits[71:64]   = FIFOBuffer[8];
				dataIn128Bits[79:72]   = FIFOBuffer[9];
				dataIn128Bits[87:80]   = FIFOBuffer[10];
				dataIn128Bits[95:88]   = FIFOBuffer[11];
				dataIn128Bits[103:96]  = FIFOBuffer[12];
				dataIn128Bits[111:104] = FIFOBuffer[13];
				dataIn128Bits[119:112] = FIFOBuffer[14];
				dataIn128Bits[127:120] = FIFOBuffer[15];

				FIFOBuffer[0]  = 8'd0;
				FIFOBuffer[1]  = 8'd0;
				FIFOBuffer[2]  = 8'd0;
				FIFOBuffer[3]  = 8'd0;
				FIFOBuffer[4]  = 8'd0;
				FIFOBuffer[5]  = 8'd0;
				FIFOBuffer[6]  = 8'd0;
				FIFOBuffer[7]  = 8'd0;
				FIFOBuffer[8]  = 8'd0;
				FIFOBuffer[9]  = 8'd0;
				FIFOBuffer[10] = 8'd0;
				FIFOBuffer[11] = 8'd0;
				FIFOBuffer[12] = 8'd0;
				FIFOBuffer[13] = 8'd0;
				FIFOBuffer[14] = 8'd0;
				FIFOBuffer[15] = 8'd0;

				// Set receivedDataFlag, so that the top-level module knows data can now be processed by the
				// AES cypher. Once set, transition to IDLE and await further input.
				receivedDataFlag = 1;
				state = IDLE;
		end

		LOAD_DATA_TO_SEND : begin
			// Load the processed value from dataOut128Bits to the FIFOBuffers and then transition to SEND_DATA so that
			// the data could be transmitted from the FPGA.
			FIFOBuffer[0]  = dataOut128Bits[7:0];
			FIFOBuffer[1]  = dataOut128Bits[15:8];
			FIFOBuffer[2]  = dataOut128Bits[23:16];
			FIFOBuffer[3]  = dataOut128Bits[31:24];
			FIFOBuffer[4]  = dataOut128Bits[39:32];
			FIFOBuffer[5]  = dataOut128Bits[47:40];
			FIFOBuffer[6]  = dataOut128Bits[55:48];
			FIFOBuffer[7]  = dataOut128Bits[63:56];
			FIFOBuffer[8]  = dataOut128Bits[71:64];
			FIFOBuffer[9]  = dataOut128Bits[79:72];
			FIFOBuffer[10] = dataOut128Bits[87:80];
			FIFOBuffer[11] = dataOut128Bits[95:88];
			FIFOBuffer[12] = dataOut128Bits[103:96];
			FIFOBuffer[13] = dataOut128Bits[111:104];
			FIFOBuffer[14] = dataOut128Bits[119:112];
			FIFOBuffer[15] = dataOut128Bits[127:120];
			state = SEND_DATA;
		end

		SEND_DATA: begin
			// Enable the bitN pins as outputs, and connect WR signal to the 1MHz clock signal
			enableWR = 1;
			enableOutputs = 1;
			// If outputCounter is less than 16, set the FIFODataOut to the corresponding FIFOBuffer value. Each individual bit
			// of FIFODataOut is extracted and set to a corresponding bitN pin for the transmission of data. When outputCounter
			// is equal to 16 disable the output pins, reset the counters and WR and RD enable pins and transition to STOP.

			// Unlike RECEIVE_DATA, SEND_DATA does not require the use of everySecondByte, due to the data that is being sent
			// (16 bytes) begin available all at the same time.
			if(outputCounter <= 5'd16) begin
				if(outputCounter == 5'd16) begin
					enableRD = 0;
					enableWR = 0;
					enableOutputs = 0;
					inputCounter = 5'd0;
					outputCounter = 5'd0;
					state = STOP;
				end
				if(outputCounter <= 5'd15) begin
					FIFODataOut = FIFOBuffer[outputCounter];
					FIFOBuffer[outputCounter] = 8'd0;
					outputCounter = outputCounter + 5'd1;
				end
			end
		end

		// Reset all enable pins and counters and transmission to IDLE.
		STOP: begin
			enableRD = 0;
			enableWR = 0;
			enableOutputs = 0;
			inputCounter = 5'd0;
			outputCounter = 5'd0;
			receivedSendDataFlag = 0;
			state = IDLE;
		end

		// Once encryptionFinishedFlag is high and the IDLE state transmission to ENCRYPTION_FINISHED, all values used by
		// the module are reset. Thus the FSM await the next configData, key and data block.
		ENCRYPTION_FINISHED: begin
			key = 128'd0;
			configData128Bits = 128'd0;
			dataIn128Bits = 128'd0;
			receivedKeyFlag = 0;
			receivedConfigDataFlag = 0;
			receivedDataFlag = 0;
			receivedSendDataFlag = 0;
			enableRD = 0;
			enableWR = 0;
			inputCounter = 5'd0;
			outputCounter = 5'd0;
			enableOutputs = 0;
			FIFODataOut = 8'd0;
			receivedNextBlockFlag = 0;
			receivedFinishedFlag = 0;

			FIFOBuffer[0]  = 8'd0;
			FIFOBuffer[1]  = 8'd0;
			FIFOBuffer[2]  = 8'd0;
			FIFOBuffer[3]  = 8'd0;
			FIFOBuffer[4]  = 8'd0;
			FIFOBuffer[5]  = 8'd0;
			FIFOBuffer[6]  = 8'd0;
			FIFOBuffer[7]  = 8'd0;
			FIFOBuffer[8]  = 8'd0;
			FIFOBuffer[9]  = 8'd0;
			FIFOBuffer[10] = 8'd0;
			FIFOBuffer[11] = 8'd0;
			FIFOBuffer[12] = 8'd0;
			FIFOBuffer[13] = 8'd0;
			FIFOBuffer[14] = 8'd0;
			FIFOBuffer[15] = 8'd0;

			state = IDLE;
		end

		default: begin
			state = IDLE;
		end

	endcase
end
endmodule
