% This function utilises gf_mul for the AES mix_column operation
function outputArray = mix_column(inputArray)
    outputArray = [];

    %{
    MDS_matrix = ...
                [02, 03, 01 ,01];
                [01, 02, 03, 01];
                [01, 01, 02, 03];
                [03, 01, 01, 02];

    These constants are used for XOR operation with gf_mul output values
    %}

    % For loop which goes thorugh each column [visualised 4x4 input matrix]
    for i = 0:3
        % Multiplication and addition in GF(2^8)

        row_01 = bitxor(...
                       bitxor(gf_mul(inputArray((i*4)+1),'02'),gf_mul(inputArray((i*4)+2),'03')),...
                       bitxor(gf_mul(inputArray((i*4)+3),'01'),gf_mul(inputArray((i*4)+4),'01'))...
                       );
        row_02 = bitxor(...
                       bitxor(gf_mul(inputArray((i*4)+1),'01'),gf_mul(inputArray((i*4)+2),'02')),...
                       bitxor(gf_mul(inputArray((i*4)+3),'03'),gf_mul(inputArray((i*4)+4),'01'))...
                       );
        row_03 = bitxor(...
                       bitxor(gf_mul(inputArray((i*4)+1),'01'),gf_mul(inputArray((i*4)+2),'01')),...
                       bitxor(gf_mul(inputArray((i*4)+3),'02'),gf_mul(inputArray((i*4)+4),'03'))...
                       );
        row_04 = bitxor(...
                       bitxor(gf_mul(inputArray((i*4)+1),'03'),gf_mul(inputArray((i*4)+2),'01')),...
                       bitxor(gf_mul(inputArray((i*4)+3),'01'),gf_mul(inputArray((i*4)+4),'02'))...
                       );
        outputArray = [outputArray; dec2hex(row_01,2); dec2hex(row_02,2); dec2hex(row_03,2); dec2hex(row_04,2)];
    end
    outputArray = string(outputArray);
end