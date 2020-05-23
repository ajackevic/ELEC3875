% Function which adds trailing nulls if input is not a muiltiple of 16
function hexBlockOutput = format_inputData(userData)
    hexPlaintext = string(dec2hex(char(userData)));

    % Adds 0x20 (hex space value) to hexPlaintext if array value is not a muilptiple of 16
    if length(hexPlaintext) <= 16
        for i = 1:16-length(hexPlaintext)
            hexPlaintext = [hexPlaintext + "00"];
        end
    else 
        if mod(length(hexPlaintext),16) ~= 0
            for i = 1:16-mod(length(hexPlaintext),16)
                hexPlaintext = [hexPlaintext; "00"];
            end
        end
    end
    hexBlockOutput = string(hexPlaintext); 
end