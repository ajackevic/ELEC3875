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

% Call key creation function and request user input by calling user_input_decrypt
allKeys = key_creation();
cipherInput = user_input_decrypt();
blockSize = size(cipherInput,2);
for cipherBlock = 1:blockSize

end
