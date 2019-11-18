% This function creates 10 different round keys from the supplied original key
function roundKeys = key_creation(inputKey, keyType)

    % Thats my Kung Fu
    AESKey = key_format(inputKey, keyType);

    Rcon = ["01"; "02"; "04"; "08"; "10"; "20"; "40"; "80"; "1B"; "36"];
    allKeys = AESKey;

    for rounds = 1:10
        for column = 0:3

            % Acquire the last four values (W[0]) and the column thats three positions further back (W[3])
            lastColumn = allKeys(end-3:end);
            threePosDown = hex2dec(allKeys(end-15:end-12));

            if column == 0
                % Do the following if this is the first column of the key
                % Shift the values to the left by one and s-box substitution
                shiftSub = hex2dec([ ...
                                    s_box(lastColumn(2), "encrypt"); s_box(lastColumn(3), "encrypt"); ...
                                    s_box(lastColumn(4), "encrypt"); s_box(lastColumn(1), "encrypt"); ...
                                   ]);
                newColumn = [...
                          bitxor(threePosDown(1), shiftSub(1)); bitxor(threePosDown(2), shiftSub(2)); ...
                          bitxor(threePosDown(3), shiftSub(3)); bitxor(threePosDown(4), shiftSub(4)); ...
                         ];

                % XOR first value of newColumn with Rcon
                newColumn(1) = bitxor(newColumn(1),hex2dec(Rcon(rounds)));

            else
                % Convert hex to dec for the XOR operation between threePosDown array and lastColumn array
                lastColumn = hex2dec(lastColumn);
                newColumn = [...
                            bitxor(threePosDown(1), lastColumn(1)); bitxor(threePosDown(2), lastColumn(2)); ...
                            bitxor(threePosDown(3), lastColumn(3)); bitxor(threePosDown(4), lastColumn(4)); ...
                            ];
            end

            columnKey = string(dec2hex(newColumn,2));
            allKeys = [allKeys; columnKey];

        end
    end
    % Convert the allKeys array to into a readable and usable format
    roundKeys = reshape(allKeys,16, length(allKeys)/16);

end
