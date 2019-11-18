% This function shifts certain rows by a certain amount of times
% Argument "type" determines whether its left shift (encrypt) or right shift (decrypt)
function outputBlock = shift_row(inputBlock, type)
    inputBlock = reshape(inputBlock,4,4);
    % Repeat left/right shift once for row 2, twice for row 3 and four times for row 4
    for row = [2 3 3 4 4 4]
        if type == "encrypt"
            [inputBlock(row,1), inputBlock(row,2)] = deal(inputBlock(row,2), inputBlock(row,1));
            [inputBlock(row,2), inputBlock(row,3)] = deal(inputBlock(row,3), inputBlock(row,2));
            [inputBlock(row,3), inputBlock(row,4)] = deal(inputBlock(row,4), inputBlock(row,3));
        end
        if type == "decrypt"
            [inputBlock(row,4), inputBlock(row,3)] = deal(inputBlock(row,3), inputBlock(row,4));
            [inputBlock(row,3), inputBlock(row,2)] = deal(inputBlock(row,2), inputBlock(row,3));
            [inputBlock(row,2), inputBlock(row,1)] = deal(inputBlock(row,1), inputBlock(row,2));
        end
    end
    outputBlock = reshape(inputBlock,16,1);
end
%{
       Shifting operation for encryption    |      Shifting operation for decryption
    [  1,  5,  9, 13]    [  1,  5,  9, 13]  |    [  1,  5,  9, 13]    [  1,  5,  9, 13]
    [  2,  6, 10, 14] => [  6, 10, 14,  2]  |    [  2,  6, 10, 14] => [ 14,  2,  6, 10]
    [  3,  7, 11, 15] => [ 11, 15,  3,  7]  |    [  3,  7, 11, 15] => [ 11, 15,  3,  7]
    [  4,  8, 12, 16]    [ 16,  4,  8, 12]  |    [  4,  8, 12, 16]    [  8, 12, 16,  4]
%}
    
