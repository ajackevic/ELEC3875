function plaintext = main_decrypt(userData, dataFormat, inputKey, keyType, AESMode, AESType, IVValue)
    % This script calls all the different steps/functions that are required by AES for decryption
    %{
      AES proccess:
        1)KeyExpansion
        2)AddRoundKey
          InvShiftRow
          InvSubByte
        3)AddRoundKey   ---
          InvMixColumns    | Repeat this proccess for x9, x11, x13 time
          InvShiftRow      |  Depends on AES bit length
          InvSubByte    ---
        4)AddRoundKey
    Note: Keys used are in reverse order to that of encryption, hence 11, 10, 9 ...
    %}
    addpath('./Sub scripts/');
    plaintext = [];
    % Call key creation function and format userData
    allKeys = key_creation(inputKey, keyType, AESType);
    cipherInput = format_decrypt_in(userData);
    blockSize = size(cipherInput,2);
    if AESType == "128-bit"
        numbRounds = 10;
    end
    if AESType == "192-bit"
        numbRounds = 12;
    end
    if AESType == "256-bit"
        numbRounds = 14;
    end
    for cipherBlock = 1:blockSize
        roundKeyOutput = add_round_key(cipherInput(:,cipherBlock),allKeys(:,numbRounds+1));
        invShiftRowOutput = shift_row(roundKeyOutput, "decrypt");
        invSubByteOutput = sub_byte(invShiftRowOutput, "decrypt");
        for rounds = numbRounds:-1:2
            roundKeyOutput = add_round_key(invSubByteOutput,allKeys(:,rounds));
            invMixColumnOutput = mix_column(roundKeyOutput, "decrypt");
            invShiftRowOutput = shift_row(invMixColumnOutput, "decrypt");
            invSubByteOutput = sub_byte(invShiftRowOutput, "decrypt");
        end
        roundKeyOutput = add_round_key(invSubByteOutput, allKeys(:,1));
        plaintext = [plaintext ; roundKeyOutput];

        if AESMode == "CBC"
            if cipherBlock == 1
                % If IV text box is left empty assign empty values
                if IVValue == ""
                    IVValue = "00000000000000000000000000000000";
                end
                % XOR(IV value, first plaintext decrypted block)
                IVState = bitxor(hex2dec(AES_format(char(IVValue))),hex2dec(plaintext));
                IVState = string(dec2hex(IVState));
                plaintext = IVState;
            else
                % XOR(decrypted block, past cipher block)
                cbcState = bitxor(hex2dec(roundKeyOutput),hex2dec(cipherInput(:,cipherBlock-1)));
                cbcState = string(dec2hex(cbcState));
                % Replace plaintext output with XOR output
                plaintext(end-15:end) = cbcState;
            end
        end

    end
    if dataFormat == "Hex"
        plaintext = AES_format(plaintext);
    else
        % Format the output to a readable string
        plaintext = AES_format(char(hex2dec(plaintext)));
    end

end
