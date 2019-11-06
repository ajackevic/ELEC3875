function roundKeys = key_creation()

    AESKey = ["54"; "68"; "61"; "74"; "73"; "20"; "6D"; "79"; "20"; "4B"; "75"; "6E"; "67"; "20"; "46"; "75"];
    Rcon = ["01"; "02"; "04"; "08"; "10"; "20"; "40"; "80"; "1B"; "36"];
    allKeys = AESKey;

    for column = 0:3
        % This gives the last four values of allKeys
        lastColumn = allKeys(end-3:end);
        shiftSub = [s_box(lastColumn(2)); s_box(lastColumn(3)); s_box(lastColumn(4)); s_box(lastColumn(1))];
        threePosDown = allKeys(end-15:end-12);

        output = [...
                 string(dec2hex(bitxor(hex2dec(threePosDown(1)), hex2dec(shiftSub(1))),2));...
                 string(dec2hex(bitxor(hex2dec(threePosDown(2)), hex2dec(shiftSub(2))),2));...
                 string(dec2hex(bitxor(hex2dec(threePosDown(3)), hex2dec(shiftSub(3))),2));...
                 string(dec2hex(bitxor(hex2dec(threePosDown(4)), hex2dec(shiftSub(4))),2));...
                 ];
    end
end
