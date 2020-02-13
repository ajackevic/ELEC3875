% This script formats the continuous hex/plaintext key to the required hex format
function outputKey = key_format(inputData,keyType)
    outputKey = [];
    if keyType == "Hex"
        % Convert continous hex to two byte hex string array
        inputData = char(inputData);
        outputKey = AES_format(inputData);
    end
    if keyType == "Plaintext"
        % Convert string to two byte hex string array
        for i = 1:length(inputData)
            hexCharValue = string(dec2hex(char(inputData(i))));
            outputKey = [outputKey; hexCharValue];
        end
    end
end
