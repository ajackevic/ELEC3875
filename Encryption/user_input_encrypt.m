% Should add a condition that decides what happens if user does
% enter anything or if he closes the dialog box

% This function acquires user input and format it into hex 16 byte blocks
function hexBlockOutput = user_input()
    hexPlaintext = [];
    hexChar = [];

    % Setting the dialog box parameters
    dlgTask = "Enter plaintext:";
    dlgTitle = "Plaintext dialog";
    dlgDim = [20 100];

    % Request user input from dialog box and then converting cell to char to cell array
    userInput = inputdlg(dlgTask, dlgTitle, dlgDim);
    stringPlaintext = num2cell(char(userInput));

    % Converts ASCII to hex and stored in hexPlaintext array
    for i = 1:length(stringPlaintext)
        hexChar = dec2hex(char(stringPlaintext(i)));
        hexPlaintext = [hexPlaintext; hexChar];
    end
    
    % Adds 0x20 (hex space value) to hexPlaintext if array value is not a muilptiple of 16
    if length(hexPlaintext) <= 16
        hexBlockOutput = hexPlaintext;
        for i = 1:16-length(hexPlaintext)
            hexBlockOutput = [hexBlockOutput; "20"];
        end
    elseif mod(length(hexPlaintext),16) ~= 0
        for i = 1:16-mod(length(hexPlaintext),16)
            hexPlaintext = [hexPlaintext; "20"];
        end
        % Convert the hexPlaintext array to a matrix
        hexBlockOutput = reshape(hexPlaintext,16, length(hexPlaintext)/16);
    end
    hexBlockOutput = string(hexBlockOutput);
end
