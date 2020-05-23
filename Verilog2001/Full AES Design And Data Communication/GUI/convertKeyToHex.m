% Function that converts data to hex 
function hexKey = convertKeyToHex(inputKey)
    hexKey = string(dec2hex(uint8(char(inputKey))));
end