// This is AES KeyCreation module. On the postative edge of startTransition the 
// module will create 11 round keys. Due to roundKey1 equaling roundKeyInput, and
// the duration of two clock cyles per roundKey, with IDLE taken into consideration 
// it will take 21 clock cycles to complet all the roundKeys.

module key_creation #(
	parameter numKeys = 11
)(
	input clock,
	input startTransition,
	input [127:0] roundKeyInput,
	
	output reg [127:0] roundKeyOutput1,
	output reg [127:0] roundKeyOutput2,
	output reg [127:0] roundKeyOutput3,
	output reg [127:0] roundKeyOutput4,
	output reg [127:0] roundKeyOutput5,
	output reg [127:0] roundKeyOutput6,
	output reg [127:0] roundKeyOutput7,
	output reg [127:0] roundKeyOutput8,
	output reg [127:0] roundKeyOutput9,
	output reg [127:0] roundKeyOutput10,
	output reg [127:0] roundKeyOutput11
);


reg [31:0]  shiftedRow;
reg [31:0]  col3out;
reg [31:0]  col2out;
reg [31:0]  col1out;
reg [31:0]  col0out;
reg [31:0]  sboxSubCol;
reg [31:0]  Rcon [0:9];
reg [3:0]   roundCounter;
reg [7:0]   sBoxValue1Input;
reg [7:0]   sBoxValue2Input;
reg [7:0]   sBoxValue3Input;
reg [7:0]   sBoxValue4Input;
reg [127:0] tempKeys [0:10];


wire [7:0]  sBoxValue1Output;
wire [7:0]  sBoxValue2Output;
wire [7:0]  sBoxValue3Output;
wire [7:0]  sBoxValue4Output;


reg [3:0] state;
reg [3:0] IDLE			  		 	  = 4'd0;
reg [3:0] START_CREATE_ROUNDKEY = 4'd1;
reg [3:0] STOP_CREATE_ROUNDKEY  = 4'd2;
reg [3:0] STOP					     = 4'd3;
	
initial begin 
	// Set Rcon values to their corresponding values and
	// all the other variables to an initial value of 0.
	Rcon[0] = 32'h00000001;
	Rcon[1] = 32'h00000002;
	Rcon[2] = 32'h00000004;
	Rcon[3] = 32'h00000008;
	Rcon[4] = 32'h00000010;
	Rcon[5] = 32'h00000020;
	Rcon[6] = 32'h00000040;
	Rcon[7] = 32'h00000080;
	Rcon[8] = 32'h0000001b;
	Rcon[9] = 32'h00000036;
	
	roundCounter = 4'd0;
	shiftedRow = 32'd0;
	sboxSubCol = 32'd0;
	state = 4'd0;
	
	roundKeyOutput1  = 128'd0;
	roundKeyOutput2  = 128'd0;
	roundKeyOutput3  = 128'd0;
	roundKeyOutput4  = 128'd0;
	roundKeyOutput5  = 128'd0;
	roundKeyOutput6  = 128'd0;
	roundKeyOutput7  = 128'd0;
	roundKeyOutput8  = 128'd0;
	roundKeyOutput9  = 128'd0;
	roundKeyOutput10 = 128'd0;
	roundKeyOutput11 = 128'd0;
	
	tempKeys[0]  = 128'd0;
	tempKeys[1]  = 128'd0;
	tempKeys[2]  = 128'd0;
	tempKeys[3]  = 128'd0;
	tempKeys[4]  = 128'd0;
	tempKeys[5]  = 128'd0;
	tempKeys[6]  = 128'd0;
	tempKeys[7]  = 128'd0;
	tempKeys[8]  = 128'd0;
	tempKeys[9]  = 128'd0;
	tempKeys[10] = 128'd0;
end

// Instantiating 4 sBox modules.
s_box value1(
	.inputValue	(sBoxValue1Input),
	.sboxOutput	(sBoxValue1Output)
);

s_box value2(
	.inputValue	(sBoxValue2Input),
	.sboxOutput	(sBoxValue2Output)
);

s_box value3(
	.inputValue	(sBoxValue3Input),
	.sboxOutput	(sBoxValue3Output)
);

s_box value4(
	.inputValue	(sBoxValue4Input),
	.	(sBoxValue4Output)
);


always @(posedge clock) begin
	case(state)
	
	IDLE: begin
	// The state waits till startTransition is equal to 1 before loading the inputs
	// and transitioning to START_CREATE_ROUNDKEY state.
		if(startTransition == 1) begin
			tempKeys[0] = roundKeyInput;
			roundKeyOutput1 = roundKeyInput;
			state = START_CREATE_ROUNDKEY;
		end
	end
	
	START_CREATE_ROUNDKEY: begin
	// First column (96:127) is cyclically shifted and substituted with sBox values.
	// State is transitioned to STOP_CREATE_ROUNDKEY state at the posetive edge of clock.
		shiftedRow = {tempKeys[roundCounter][103:96], tempKeys[roundCounter][127:104]};
		sBoxValue1Input = shiftedRow[7:0];
		sBoxValue2Input = shiftedRow[15:8];
		sBoxValue3Input = shiftedRow[23:16];
		sBoxValue4Input = shiftedRow[31:24];
		state = STOP_CREATE_ROUNDKEY;
	end
	
	STOP_CREATE_ROUNDKEY: begin
	// The substituted value is XOR'd with the corresponding Rcon value, then the remaining
	// tempKey values are XOR'd with the previous created column value. 
		sboxSubCol[7:0]   = sBoxValue1Output;
		sboxSubCol[15:8]  = sBoxValue2Output;
		sboxSubCol[23:16] = sBoxValue3Output;
		sboxSubCol[31:24] = sBoxValue4Output;	
		
		col3out = sboxSubCol ^ tempKeys[roundCounter][31:0] ^ Rcon[roundCounter];
		col2out = col3out ^ tempKeys[roundCounter][63:32];
		col1out = col2out ^ tempKeys[roundCounter][95:64];
		col0out = col1out ^ tempKeys[roundCounter][127:96];
		
		// Attach all the created columns to create the current tempKey.
		tempKeys[roundCounter+1] = {col0out, col1out, col2out, col3out};
		roundCounter = roundCounter + 4'd1;

		// Transfer the tempKey values to the output roundKeys. The transfer of data has been
		// moved from the STOP state to this one, so that the creation of the keys could be 
		// done in parallel to the encryption process, as the duration of a key created is 
		// faster than the duration between one AddRoundKey and the next.
		roundKeyOutput2 = tempKeys[1];
		roundKeyOutput3 = tempKeys[2];
		roundKeyOutput4 = tempKeys[3];
		roundKeyOutput5 = tempKeys[4];
		roundKeyOutput6 = tempKeys[5];
		roundKeyOutput7 = tempKeys[6];
		roundKeyOutput8 = tempKeys[7];
		roundKeyOutput9 = tempKeys[8];
		roundKeyOutput10 = tempKeys[9];
		roundKeyOutput11 = tempKeys[10];
		
		// If the amounf of created roundKeys is less than 10, repeat the next corresponding 
		// key, else transition to the STOP state.
		if(roundCounter <= 4'd9) begin
			state = START_CREATE_ROUNDKEY;
		end else begin 
			state = STOP;
		end
	end
	
	STOP: begin
	// Clear any stored values, then transition to the IDLE state on the posative edge of clock.
		roundCounter = 4'd0;
		shiftedRow = 32'd0;
		sboxSubCol = 32'd0;
		state = IDLE;
	end
	
	default: begin
		state = IDLE;
	end
	
	endcase
end
endmodule

