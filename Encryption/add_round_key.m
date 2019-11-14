% This funciton adds the roundKey to the hexData
function output = add_round_key(hexData, roundKey)

    output = [];
    % Variable type conversion
    hexData = hex2dec(hexData);
    roundKey = hex2dec(roundKey);

    for i = 1:16
        temp = bitxor(hexData(i),roundKey(i));
        output = [output; string(dec2hex(temp,2))];
    end
end
