% This function checks the whether the input key is a valid input
function keyFlag = key_check(inputKey, keyType, AESMode)
    inputKey = char(inputKey);
    % Set flag to false, if criteria is not met set flag to true
    if AESMode == "128-bit"
        hexKeyLength = 32;
        plaintextKeyLength = 16;
    end
    if AESMode == "192-bit"
        hexKeyLength = 48;
        plaintextKeyLength = 24;
    end
    if AESMode == "256-bit"
        hexKeyLength = 64;
        plaintextKeyLength = 32;

    keyFlag = false;
    if keyType == "Hex"
        hexValues = ["0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "a"; "b"; "c"; "d"; "e"; "f"; "A"; "B"; "C"; "D"; "E"; "F"];
        % Check length of key is 32/48 bits
        if length(inputKey) ~= hexKeyLength
            keyFlag = true;
        end
        % Check if every character in key is a valid hex value
        for i = 1:length(inputKey)
            if ~ismember(string(inputKey(i)),hexValues)
                keyFlag = true;
            end
        end
    end
    if keyType == "Plaintext"
        % Check if key length is a 16/24 byte value
        if length(inputKey) ~= plaintextKeyLength
            keyFlag = true;
        end
    end
end
