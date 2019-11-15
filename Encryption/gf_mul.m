% This function calculates multiplication in gf(2^8) field, with modulo 0x11B for any 8 bit overflow
% Note: output is a decimal value not hex
function value_out = gf_mul(value1_in, value2_in)

    % Converting hex to decimal to binary for gfconv()
    value1_in = de2bi(hex2dec(value1_in));
    value2_in = de2bi(hex2dec(value2_in));
    % Multiplication of polynomials in GF order 2.
    gf_muil_b = gfconv(value1_in, value2_in,2);
    gf_muil_d = bi2de(gf_muil_b);

    % Whilst gf_muil_d is above GF(2^8)(overflow), XOR with 0x11B starting from MSB
    % Note: decimal values are used instead of binary mainly due to bitxor requiring the array size to
    % be identical (between gf_muil and 0x11b) and the fact that once XOR'd MSB will still be 0 instead
    % of reducing array size automatically. Hence another function would have to find an MSB that is a 1.
    while gf_muil_d >= 256
        % If gf_muil_d is of 10th order, XOR with [1 0 0 0 1 1 0 1 1 0 0](1132)
        if gf_muil_d >= 1024 % 10th order
            gf_muil_d = bitxor(gf_muil_d, 1132);
        end
        % If gf_muil_d is of 9th order, XOR with [1 0 0 0 1 1 0 1 1 0](566)
        if gf_muil_d >= 512 & gf_muil_d <= 1023
            gf_muil_d = bitxor(gf_muil_d, 566);
        end
        % If gf_muil_d is of 8th order, XOR with [1 0 0 0 1 1 0 1 1 ](283)
        if gf_muil_d >= 256 & gf_muil_d <= 511
            gf_muil_d = bitxor(gf_muil_d, 283);
        end
    end
    value_out = gf_muil_d;
end
