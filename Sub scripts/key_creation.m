% This function creates the required amount of key for the selected AES mode
function roundKeys = key_creation(inputKey, keyType, AESMode)
    roundKeys = [];
    AESKey = key_format(inputKey, keyType);
    Rcon = ["01"; "02"; "04"; "08"; "10"; "20"; "40"; "80"; "1B"; "36"];
    % Declaration of different variables for 128 or 196 bit AES
    if AESMode == "128-bit"
        roundsLimit = 11; columnLimit = 4; blockLimit = 44; iLimit = 10;
    end
    if  AESMode == "192-bit"
        roundsLimit = 13; columnLimit = 6; blockLimit = 52; iLimit = 8;
    end
    if AESMode == "256-bit"
        roundsLimit = 15; columnLimit = 8; blockLimit = 60; iLimit = 7;
    end

    % Create a 4x4(128-bit)/4x6(192-bit) matrix
    allKeys = reshape(AESKey,4,columnLimit);
    for i = 1:iLimit
        for column = 1:columnLimit
            % Shift the values to the left by one and s-box substitution if this is the first column
            % of the key/round key
            if column == 1
                shiftSub = [...
                          s_box(allKeys(2,end), "encrypt"); s_box(allKeys(3,end), "encrypt"); ...
                          s_box(allKeys(4,end), "encrypt"); s_box(allKeys(1,end), "encrypt"); ...
                          ];
                newColumn = [...
                          bitxor(hex2dec(allKeys(1,end-(columnLimit-1))), hex2dec(shiftSub(1))); ...
                          bitxor(hex2dec(allKeys(2,end-(columnLimit-1))), hex2dec(shiftSub(2))); ...
                          bitxor(hex2dec(allKeys(3,end-(columnLimit-1))), hex2dec(shiftSub(3))); ...
                          bitxor(hex2dec(allKeys(4,end-(columnLimit-1))), hex2dec(shiftSub(4))); ...
                          ];

                % XOR first value of newColumn with corresponding Rcon value
                newColumn(1) = bitxor(newColumn(1),hex2dec(Rcon(i)));
            elseif column == 5 && AESMode == "256-bit"
                % For 256-bit, XOR s-box(last column) and column 8 possitions down (7 as we include last colmn as 1).
                % Only do this when column is equal to 4 (5 as we start from 1)
                subColumn = [...
                          s_box(allKeys(1,end), "encrypt"); s_box(allKeys(2,end), "encrypt"); ...
                          s_box(allKeys(3,end), "encrypt"); s_box(allKeys(4,end), "encrypt"); ...
                          ];
                newColumn = [...
                          bitxor(hex2dec(allKeys(1,end-(columnLimit-1))), hex2dec(subColumn(1))); ...
                          bitxor(hex2dec(allKeys(2,end-(columnLimit-1))), hex2dec(subColumn(2))); ...
                          bitxor(hex2dec(allKeys(3,end-(columnLimit-1))), hex2dec(subColumn(3))); ...
                          bitxor(hex2dec(allKeys(4,end-(columnLimit-1))), hex2dec(subColumn(4))); ...
                          ];
            else
                % XOR operation between 3pos down(128-bit)/5pos down (192-bit)/7pos down (256-bit)
                % column and current last column

                newColumn = [...
                          bitxor(hex2dec(allKeys(1,end-(columnLimit-1))), hex2dec(allKeys(1,end))); ...
                          bitxor(hex2dec(allKeys(2,end-(columnLimit-1))), hex2dec(allKeys(2,end))); ...
                          bitxor(hex2dec(allKeys(3,end-(columnLimit-1))), hex2dec(allKeys(3,end))); ...
                          bitxor(hex2dec(allKeys(4,end-(columnLimit-1))), hex2dec(allKeys(4,end)));
                          ];
            end
            % Add the new column to the allKey matrix
            newColumnKey = string(dec2hex(newColumn,2));
            allKeys = [allKeys reshape(newColumnKey,4,1)];
        end
    end
    % Delete any unnecessary keys. 192-bit creates 54 column keys but only needs
    % 52. 256-bit creates 64 but only requires 60.
    blockKey = allKeys(:,1:blockLimit);
    for rounds = 1:roundsLimit
        % Reshape the 44(128-bit)/52(192-bit)/60(256-bit) column of keys to 16x11(128-bit)/16x13(192-bit)/16x15(256-bit)

        roundKeys = [roundKeys reshape(blockKey(1:16),16,1)];
        if length(blockKey) > 4
            blockKey = blockKey(:,5:end);
        end
    end
end
