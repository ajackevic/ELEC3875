% This function calculates multiplication in gf(2^8) field,
% with modulo 0x11B for overflow of 8 bits.
function value_out = gf_muiltiplication(value1_in, value2_in)

    % Converting hex to decimal to binary
    value1_in = de2bi(hex2dec(value1_in));
    value2_in = de2bi(hex2dec(value2_in));

    % Multiplication of polynomials in GF order 2.
    gf_muil_b = gfconv(value1_in, value2_in,2);

    % Modulos the multipied value with 0x11B(100011011) if value is a 9 bit value.
    if length(gf_muil_b) > 8
        % 0x11B(100011011) is reversed partially as bi2de requires LSB to be LHS and
        % due to gfconv outputting in this format.
        gf_muil_b = bitxor(gf_muil_b, [1 1 0 1 1 0 0 0 1]);
    end

    % Converting binary to decimal to hex.
    value_out = dec2hex(bi2de(gf_muil_b));
end
