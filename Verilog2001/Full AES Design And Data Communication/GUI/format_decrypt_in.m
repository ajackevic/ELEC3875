% This function formats the decryption data to an array format
function cipherBlockOutput = format_decrypt_in(userData)   
    userData = char(userData);
    cipherBlockOutput = [];
    for i = 1:2:strlength(userData)
        cipherBlockOutput = [cipherBlockOutput; string(userData(i:i+1))];
    end
end

