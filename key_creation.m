function roundKeys = key_creation()
    AESKey = ["54"; "68"; "61"; "74"; "73"; "20"; "6D"; "79"; "20"; "4B"; "75"; "6E"; "67"; "20"; "46"; "75"];
    Rcon = ["01"; "02"; "04"; "08"; "10"; "20"; "40"; "80"; "1B"; "36"];


    for i = 0:3
        temp_key = [AESKey((i*4)+1); AESKey((i*4)+2); AESKey((i*4)+3); AESKey((i*4)+4)];
        disp(temp_key)
    end
end
