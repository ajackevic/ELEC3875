
// This module creates the required 1MHz clock signal (through he use of the 50MHz clock signal)
// used by data communication.

module clock_signals(
	input clock50MHz,
	output reg clock1MHz
);

reg [11:0] counter1MHz;

initial begin 
	clock1MHz = 0;
	counter1MHz = 12'd0;
end

// A counter is used to create the 1MHz clock signal. Whilst a PLL could have been used, the 
// data communication script does not require a strict 1MHz clock signal thus this was deemed
// acceptable.
always @(posedge clock50MHz) begin 
	if(counter1MHz == 12'd25) begin
		clock1MHz <= ~clock1MHz;
		counter1MHz <= 12'd0;
	end else begin
		counter1MHz <= counter1MHz + 12'd1;
	end

end

endmodule
