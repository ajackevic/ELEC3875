% This function acquires user input and format it into hex 16 byte blocks
function hexBlockOutput = format_encrypt_in(userData)
    hexPlaintext = [];
    hexChar = [];

    % Converts ASCII to hex and stored in hexPlaintext array
    for i = 1:length(userData)
        hexChar = dec2hex(char(userData(i)));
        hexPlaintext = [hexPlaintext; hexChar];
    end

    % Adds 0x20 (hex space value) to hexPlaintext if array value is not a muilptiple of 16
    if length(hexPlaintext) <= 16
        hexBlockOutput = hexPlaintext;
        for i = 1:16-length(hexPlaintext)
            hexBlockOutput = [hexBlockOutput; "00"];
        end
    elseif mod(length(hexPlaintext),16) ~= 0
        for i = 1:16-mod(length(hexPlaintext),16)
            hexPlaintext = [hexPlaintext; "00"];
        end
        % Convert the hexPlaintext array to a matrix
        hexBlockOutput = reshape(hexPlaintext,16, length(hexPlaintext)/16);
    end
    hexBlockOutput = string(hexBlockOutput);
end
