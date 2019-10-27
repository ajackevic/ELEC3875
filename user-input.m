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

% create a function that would take the hex_plaintext as an input
% add spacebar hex values to the end of the array if the input
% has a non-zero modulo (use mod function) then seperate the array
% to 16 bytes

disp(hex_plaintext(1,:));      % displays the first hex value
