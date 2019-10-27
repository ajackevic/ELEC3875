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
%%disp(string_plaintext);

for i = 1:length(string_plaintext)
    hex_str = dec2hex(char(string_plaintext(i)));
    hex_plaintext = [hex_plaintext; hex_str];
end

disp(hex_plaintext(1,:));      % displays the first hex value
disp(hex_plaintext)
disp("-------------")


%Adds 0x20 (hex space value) to hex_plaintext if value is below 16, to make it
%a block of 16 bytes
if length(hex_plaintext) < 16
    for i = 1:16-length(hex_plaintext)
        hex_plaintext = [hex_plaintext; "20"];
    end

%Adds 0x20 (hex space value) to hex_plaintext if value is above 16, to make is
%a muiltiple of 16
elseif mod(length(hex_plaintext),16) ~= 0
    disp("condition has been met")
    for i = 1:16-mod(length(hex_plaintext),16)
        hex_plaintext = [hex_plaintext; "20"];
    end
end

disp(hex_plaintext)
