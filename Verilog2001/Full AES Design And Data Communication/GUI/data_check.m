% This function checks the entered user data
function dataFlag = data_check(data, dataFormat, keyType, type)
    dataFlag = false;
    data = char(data);
    if isempty(data)
        dataFlag = true;
    end
    
    if dataFormat == "Hex"
        if mod(length(data),2) ~= 0
            dataFlag = true;
        end
        hexValues = ["0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "a"; "b"; "c"; "d"; "e"; "f"; "A"; "B"; "C"; "D"; "E"; "F"]; 
        for i = 1:length(data)
            if ~ismember(string(data(i)),hexValues)
                dataFlag = true;
            end
        end
    end
    
    if type == "decrypt"
        % Check if every character in hex data is a valid value
        if keyType == "Hex"
            hexValues = ["0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "a"; "b"; "c"; "d"; "e"; "f"; "A"; "B"; "C"; "D"; "E"; "F"]; 
            for i = 1:length(data)
                if ~ismember(string(data(i)),hexValues)
                    dataFlag = true;
                end
            end
        end
        % Check if length of data is a multiple of 16
        % Note this will be false if length(data) < 16, hence the <16 length check
        if mod(length(data),16) ~= 0
            dataFlag = true;
        end
        if length(data) < 16
            dataFlag = true;
        end
    end
end