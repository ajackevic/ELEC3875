 module inv_s_box(
	input  [7:0] inputValue,
	output reg [7:0] outputValue
);

always @(inputValue) begin 
	case(inputValue)
		8'h00 : outputValue = 8'h52;  
		8'h01 : outputValue = 8'h09;  
		8'h02 : outputValue = 8'h6a;  
		8'h03 : outputValue = 8'hd5;  
		8'h04 : outputValue = 8'h30;  
		8'h05 : outputValue = 8'h36;  
		8'h06 : outputValue = 8'ha5; 
		8'h07 : outputValue = 8'h38;  
		8'h08 : outputValue = 8'hbf;  
		8'h09 : outputValue = 8'h40;  
		8'h0a : outputValue = 8'ha3;  
		8'h0b : outputValue = 8'h9e;  
		8'h0c : outputValue = 8'h81;  
		8'h0d : outputValue = 8'hf3;  
		8'h0e : outputValue = 8'hd7;  
		8'h0f : outputValue = 8'hfb;
		8'h10 : outputValue = 8'h7c;  
		8'h11 : outputValue = 8'he3;  
		8'h12 : outputValue = 8'h39;  
		8'h13 : outputValue = 8'h82;  
		8'h14 : outputValue = 8'h9b;  
		8'h15 : outputValue = 8'h2f;  
		8'h16 : outputValue = 8'hff;  
		8'h17 : outputValue = 8'h87;  
		8'h18 : outputValue = 8'h34;  
		8'h19 : outputValue = 8'h8e;  
		8'h1a : outputValue = 8'h43;  
		8'h1b : outputValue = 8'h44;  
		8'h1c : outputValue = 8'hc4; 
		8'h1d : outputValue = 8'hde;  
		8'h1e : outputValue = 8'he9;  
		8'h1f : outputValue = 8'hcb;
		8'h20 : outputValue = 8'h54;  
		8'h21 : outputValue = 8'h7b;  
		8'h22 : outputValue = 8'h94;  
		8'h23 : outputValue = 8'h32;  
		8'h24 : outputValue = 8'ha6;  
		8'h25 : outputValue = 8'hc2;  
		8'h26 : outputValue = 8'h23;  
		8'h27 : outputValue = 8'h3d;  
		8'h28 : outputValue = 8'hee;  
		8'h29 : outputValue = 8'h4c;  
		8'h2a : outputValue = 8'h95;  
		8'h2b : outputValue = 8'h0b;  
		8'h2c : outputValue = 8'h42; 
		8'h2d : outputValue = 8'hfa;  
		8'h2e : outputValue = 8'hc3;  
		8'h2f : outputValue = 8'h4e;
		8'h30 : outputValue = 8'h08;  
		8'h31 : outputValue = 8'h2e;  
		8'h32 : outputValue = 8'ha1;  
		8'h33 : outputValue = 8'h66;  
		8'h34 : outputValue = 8'h28;  
		8'h35 : outputValue = 8'hd9;  
		8'h36 : outputValue = 8'h24;  
		8'h37 : outputValue = 8'hb2;  
		8'h38 : outputValue = 8'h76;  
		8'h39 : outputValue = 8'h5b;  
		8'h3a : outputValue = 8'ha2;  
		8'h3b : outputValue = 8'h49;  
		8'h3c : outputValue = 8'h6d;
		8'h3d : outputValue = 8'h8b;  
		8'h3e : outputValue = 8'hd1;  
		8'h3f : outputValue = 8'h25;
		8'h40 : outputValue = 8'h72;  
		8'h41 : outputValue = 8'hf8;  
		8'h42 : outputValue = 8'hf6;  
		8'h43 : outputValue = 8'h64;  
		8'h44 : outputValue = 8'h86;  
		8'h45 : outputValue = 8'h68;  
		8'h46 : outputValue = 8'h98;  
		8'h47 : outputValue = 8'h16;  
		8'h48 : outputValue = 8'hd4;  
		8'h49 : outputValue = 8'ha4;  
		8'h4a : outputValue = 8'h5c;  
		8'h4b : outputValue = 8'hcc;  
		8'h4c : outputValue = 8'h5d; 
		8'h4d : outputValue = 8'h65;  
		8'h4e : outputValue = 8'hb6;  
		8'h4f : outputValue = 8'h92;
		8'h50 : outputValue = 8'h6c;  
		8'h51 : outputValue = 8'h70;  
		8'h52 : outputValue = 8'h48;  
		8'h53 : outputValue = 8'h50;  
		8'h54 : outputValue = 8'hfd;  
		8'h55 : outputValue = 8'hed;  
		8'h56 : outputValue = 8'hb9;  
		8'h57 : outputValue = 8'hda;  
		8'h58 : outputValue = 8'h5e;  
		8'h59 : outputValue = 8'h15;  
		8'h5a : outputValue = 8'h46;  
		8'h5b : outputValue = 8'h57;  
		8'h5c : outputValue = 8'ha7; 
		8'h5d : outputValue = 8'h8d;  
		8'h5e : outputValue = 8'h9d;  
		8'h5f : outputValue = 8'h84;
		8'h60 : outputValue = 8'h90;  
		8'h61 : outputValue = 8'hd8;  
		8'h62 : outputValue = 8'hab;  
		8'h63 : outputValue = 8'h00;  
		8'h64 : outputValue = 8'h8c;  
		8'h65 : outputValue = 8'hbc;  
		8'h66 : outputValue = 8'hd3;  
		8'h67 : outputValue = 8'h0a;  
		8'h68 : outputValue = 8'hf7;  
		8'h69 : outputValue = 8'he4;  
		8'h6a : outputValue = 8'h58;  
		8'h6b : outputValue = 8'h05;  
		8'h6c : outputValue = 8'hb8; 
		8'h6d : outputValue = 8'hb3;  
		8'h6e : outputValue = 8'h45;  
		8'h6f : outputValue = 8'h06;
		8'h70 : outputValue = 8'hd0;  
		8'h71 : outputValue = 8'h2c;  
		8'h72 : outputValue = 8'h1e;  
		8'h73 : outputValue = 8'h8f;  
		8'h74 : outputValue = 8'hca;  
		8'h75 : outputValue = 8'h3f;  
		8'h76 : outputValue = 8'h0f;  
		8'h77 : outputValue = 8'h02;  
		8'h78 : outputValue = 8'hc1;  
		8'h79 : outputValue = 8'haf;  
		8'h7a : outputValue = 8'hbd;  
		8'h7b : outputValue = 8'h03;  
		8'h7c : outputValue = 8'h01; 
		8'h7d : outputValue = 8'h13;  
		8'h7e : outputValue = 8'h8a;  
		8'h7f : outputValue = 8'h6b;
		8'h80 : outputValue = 8'h3a;  
		8'h81 : outputValue = 8'h91;  
		8'h82 : outputValue = 8'h11;  
		8'h83 : outputValue = 8'h41;  
		8'h84 : outputValue = 8'h4f;  
		8'h85 : outputValue = 8'h67;  
		8'h86 : outputValue = 8'hdc;  
		8'h87 : outputValue = 8'hea;  
		8'h88 : outputValue = 8'h97;  
		8'h89 : outputValue = 8'hf2;  
		8'h8a : outputValue = 8'hcf;  
		8'h8b : outputValue = 8'hce;  
		8'h8c : outputValue = 8'hf0; 
		8'h8d : outputValue = 8'hb4;  
		8'h8e : outputValue = 8'he6;  
		8'h8f : outputValue = 8'h73;
		8'h90 : outputValue = 8'h96;  
		8'h91 : outputValue = 8'hac;  
		8'h92 : outputValue = 8'h74;  
		8'h93 : outputValue = 8'h22;  
		8'h94 : outputValue = 8'he7;  
		8'h95 : outputValue = 8'had;  
		8'h96 : outputValue = 8'h35;  
		8'h97 : outputValue = 8'h85;  
		8'h98 : outputValue = 8'he2;  
		8'h99 : outputValue = 8'hf9;  
		8'h9a : outputValue = 8'h37;  
		8'h9b : outputValue = 8'he8;  
		8'h9c : outputValue = 8'h1c; 
		8'h9d: outputValue = 8'h75;  
		8'h9e : outputValue = 8'hdf;  
		8'h9f : outputValue = 8'h6e;
		8'ha0 : outputValue = 8'h47;  
		8'ha1 : outputValue = 8'hf1;  
		8'ha2 : outputValue = 8'h1a;  
		8'ha3 : outputValue = 8'h71;  
		8'ha4 : outputValue = 8'h1d;  
		8'ha5 : outputValue = 8'h29;  
		8'ha6 : outputValue = 8'hc5;  
		8'ha7 : outputValue = 8'h89;  
		8'ha8 : outputValue = 8'h6f;  
		8'ha9 : outputValue = 8'hb7;  
		8'haa : outputValue = 8'h62;  
		8'hab : outputValue = 8'h0e;  
		8'hac : outputValue = 8'haa; 
		8'had : outputValue = 8'h18;  
		8'hae : outputValue = 8'hbe;  
		8'haf : outputValue = 8'h1b;
		8'hb0 : outputValue = 8'hfc;  
		8'hb1 : outputValue = 8'h56;  
		8'hb2 : outputValue = 8'h3e;  
		8'hb3 : outputValue = 8'h4b;  
		8'hb4 : outputValue = 8'hc6;  
		8'hb5 : outputValue = 8'hd2;  
		8'hb6 : outputValue = 8'h79;  
		8'hb7 : outputValue = 8'h20;  
		8'hb8 : outputValue = 8'h9a;  
		8'hb9 : outputValue = 8'hdb;  
		8'hba : outputValue = 8'hc0;  
		8'hbb : outputValue = 8'hfe;  
		8'hbc : outputValue = 8'h78; 
		8'hbd : outputValue = 8'hcd;  
		8'hbe : outputValue = 8'h5a;  
		8'hbf : outputValue = 8'hf4;
		8'hc0 : outputValue = 8'h1f;  
		8'hc1 : outputValue = 8'hdd;  
		8'hc2 : outputValue = 8'ha8;  
		8'hc3 : outputValue = 8'h33;  
		8'hc4 : outputValue = 8'h88;  
		8'hc5 : outputValue = 8'h07;  
		8'hc6 : outputValue = 8'hc7;  
		8'hc7 : outputValue = 8'h31;  
		8'hc8 : outputValue = 8'hb1;  
		8'hc9 : outputValue = 8'h12;  
		8'hca : outputValue = 8'h10;  
		8'hcb : outputValue = 8'h59;  
		8'hcc : outputValue = 8'h27; 
		8'hcd : outputValue = 8'h80;  
		8'hce : outputValue = 8'hec;  
		8'hcf : outputValue = 8'h5f;
		8'hd0 : outputValue = 8'h60;  
		8'hd1 : outputValue = 8'h51;  
		8'hd2 : outputValue = 8'h7f;  
		8'hd3 : outputValue = 8'ha9;  
		8'hd4 : outputValue = 8'h19;  
		8'hd5 : outputValue = 8'hb5;  
		8'hd6 : outputValue = 8'h4a;  
		8'hd7 : outputValue = 8'h0d;  
		8'hd8 : outputValue = 8'h2d;  
		8'hd9 : outputValue = 8'he5;  
		8'hda : outputValue = 8'h7a;  
		8'hdb : outputValue = 8'h9f;  
		8'hdc : outputValue = 8'h93; 
		8'hdd : outputValue = 8'hc9;  
		8'hde : outputValue = 8'h9c;  
		8'hdf : outputValue = 8'hef;
		8'he0 : outputValue = 8'ha0;  
		8'he1 : outputValue = 8'he0;  
		8'he2 : outputValue = 8'h3b;  
		8'he3 : outputValue = 8'h4d;  
		8'he4 : outputValue = 8'hae;  
		8'he5 : outputValue = 8'h2a;  
		8'he6 : outputValue = 8'hf5;  
		8'he7 : outputValue = 8'hb0;  
		8'he8 : outputValue = 8'hc8;  
		8'he9 : outputValue = 8'heb;  
		8'hea : outputValue = 8'hbb;  
		8'heb : outputValue = 8'h3c;  
		8'hec : outputValue = 8'h83; 
		8'hed : outputValue = 8'h53;  
		8'hee : outputValue = 8'h99;  
		8'hef : outputValue = 8'h61;
		8'hf0 : outputValue = 8'h17;  
		8'hf1 : outputValue = 8'h2b;  
		8'hf2 : outputValue = 8'h04;  
		8'hf3 : outputValue = 8'h7e;  
		8'hf4 : outputValue = 8'hba;  
		8'hf5 : outputValue = 8'h77;  
		8'hf6 : outputValue = 8'hd6;  
		8'hf7 : outputValue = 8'h26;  
		8'hf8 : outputValue = 8'he1;  
		8'hf9 : outputValue = 8'h69;  
		8'hfa : outputValue = 8'h14;  
		8'hfb : outputValue = 8'h63;  
		8'hfc : outputValue = 8'h55; 
		8'hfd : outputValue = 8'h21;  
		8'hfe : outputValue = 8'h0c;  
		8'hff : outputValue = 8'h7d;
	endcase
end
endmodule