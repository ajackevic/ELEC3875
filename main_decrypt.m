function plaintext = main_decrypt(userData)
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
    plaintext = [];
    % Call key creation function and format userData
    allKeys = key_creation("encrypt");
    cipherInput = user_input_decrypt(userData);
    blockSize = size(cipherInput,2);
    for cipherBlock = 1:blockSize
        roundKeyOutput = add_round_key(cipherInput(:,cipherBlock),allKeys(:,11));
        invShiftRowOutput = shift_row(roundKeyOutput, "decrypt");
        invSubByteOutput = sub_byte(invShiftRowOutput, "decrypt");
        for rounds = 10:-1:2
            roundKeyOutput = add_round_key(invSubByteOutput,allKeys(:,rounds));
            invMixColumnOutput = mix_column(roundKeyOutput, "decrypt");
            invShiftRowOutput = shift_row(invMixColumnOutput, "decrypt");
            invSubByteOutput = sub_byte(invShiftRowOutput, "decrypt");
        end
        roundKeyOutput = add_round_key(invSubByteOutput, allKeys(:,1));
        plaintext = [plaintext ; roundKeyOutput];
    end
    % Format the output to a readable string
    plaintext = AES_format(char(hex2dec(plaintext)));
end