function value_out = gf_muiltiplication(value1_in, value2_in)
    value1_in = de2bi(hex2dec(value1_in));
    value2_in = de2bi(hex2dec(value2_in));
    gf_muil = gfconv(value1_in, value2_in,2)
end
