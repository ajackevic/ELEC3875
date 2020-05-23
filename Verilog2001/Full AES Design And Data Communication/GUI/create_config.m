% This function create the configData format depending on the supplied
% inputs
function hexConfigData = create_config(hexUserData, hexCypherMode)
    hexConfigData = [hexCypherMode; "00"; "00"];
    configDataLength = string(length(hexUserData)/16);
    
    if str2num(char(configDataLength)) < 10
        configDataLength = "0" + configDataLength;
    end

    for i = 1:32-strlength(configDataLength)
        configDataLength = configDataLength + "0";
    end

    configDataLength = char(configDataLength);
    for j = 1:2:32
        hexConfigData = [hexConfigData; configDataLength(j:j + 1)];
    end
end