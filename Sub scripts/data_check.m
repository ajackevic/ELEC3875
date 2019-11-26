function dataFlag = data_check(data, keyType)
    dataFlag = false;

    if isempty(char(data))
        dataFlag = true;
    end
    if keyType == "Hex"
        % Check if every character in hex data is a valid value
        hexValues = ["0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "a"; "b"; "c"; "d"; "e"; "f"; "A"; "B"; "C"; "D"; "E"; "F"];
        for i = 1:length(inputKey)
            if ~ismember(string(inputKey(i)),hexValues)
                dataFlag = true;
            end
        end
        % Check if length of data is a multiple of 16
        % Note this will be false if length(data) < 16, hence the <16 length check
        if mod(length(char(data)),16) ~= 0
            dataFlag = true;
        end
        if length(char(data)) < 16
            dataFlag = true;
        end
    end
end
