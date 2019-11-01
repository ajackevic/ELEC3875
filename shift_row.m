% This function shifts certain rows by a certain amount as required for AES
function outputBlock = shift_row(inputBlock)
%{
    The required shifting operation for AES
    [  1,  5,  9, 13]    [  1,  5,  9, 13]
    [  2,  6, 10, 14] => [  6, 10, 14,  2]
    [  3,  7, 11, 15] => [ 11, 15,  3,  7]
    [  4,  8, 12, 16]    [ 16,  4,  8, 12]
%}

    % Shift second row to the left by one
    temp1 = inputBlock(14);
    inputBlock(14) = inputBlock(2);
    inputBlock(2) = inputBlock(6);
    inputBlock(6) = inputBlock(10);
    inputBlock(10) = temp1;

    % Shift third row to the left by one
    temp1 = inputBlock(7);
    temp2 = inputBlock(3);
    inputBlock(3) = inputBlock(11);
    inputBlock(7) = inputBlock(15);
    inputBlock(15) = temp1;
    inputBlock(11) = temp2;

    % Shift fourth row to the left by one
    temp1 = inputBlock(8);
    inputBlock(8) = inputBlock(4);
    inputBlock(4) = inputBlock(16);
    inputBlock(16) = inputBlock(12);
    inputBlock(12) = temp1;

    outputBlock = inputBlock;
end
