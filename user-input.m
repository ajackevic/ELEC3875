% Deleration of veriables
char user_plaintext;
hex_plaintext = [];
hex_str = [];

% setting the dialog box parameters
dlg_task = "Enter plaintext:";
dlg_title = "Plaintext dialog";
dlg_dim = [20 100];


user_input = inputdlg(dlg_task, dlg_title, dlg_dim);    % user input from dialog box
string_plaintext = num2cell(char(user_input));          % converting cell to char to cell array

for i = 1:length(string_plaintext)
    hex_str = dec2hex(char(string_plaintext(i)));
    hex_plaintext = [hex_plaintext; hex_str];
end

%Adds 0x20 (hex space value) to hex_plaintext if value if below 16
if length(hex_plaintext) < 16
    for i = 1:16-length(hex_plaintext)
        hex_plaintext = [hex_plaintext; "20"];
    end

elseif mod(length(hex_plaintext),16) ~= 0
    for i = 1:16-mod(length(hex_plaintext),16)
        hex_plaintext = [hex_plaintext; "20"];
    end
end

%Convert the hex_plaintext array to a matrix
AES_block_input = reshape(hex_plaintext,16, length(hex_plaintext)/16)
