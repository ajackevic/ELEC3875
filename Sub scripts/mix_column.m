% This function utilises gf_mul for the AES mix_column operation
function outArray = mix_column(inArray, type)
    outArray = [];
    if type == "encrypt"
        value0E = [0 0 0 0]; value0B = [0 0 0 0]; value0D = [0 0 0 0]; value09 = [0 0 0 0];
    else
        value0E = [0 0 1 1]; value0B = [0 0 0 1]; value0D = [0 0 1 1]; value09 = [0 0 0 1];
    end
    %{
                MDS_matrix(encrypt) |  Inv_MSD_matrix(decrypt)
                [02, 03, 01 ,01]    |  [0E, 0B, 0D, 09]
                [01, 02, 03, 01]    |  [09, 0E, 0B, 0D]
                [01, 01, 02, 03]    |  [0D, 09, 0E, 0B]
                [03, 01, 01, 02]    |  [0B, 0D, 09, 0E]
    These constants are used for XOR operation with gf_mul output values

    For loop which goes thorugh each column [visualised 4x4 input matrix]
    Multiplication and addition in GF(2^8)
    %}
    % row_01 = [inAraay(a00)•02/0E]⊕[inAraay(a10)•03/0B]⊕[inAraay(a20)•01/0D]⊕[inAraay(a30)•01/09].
    % (i*4)+1/2/3/4 selects the required input array value. Binary addition is not converted to hex
    % as gf_mul would just convert it back to binary.
    for i = 0:3
        row_01 = bitxor(...
                       bitxor(gf_mul(inArray((i*4)+1),[0 1 0 0]+value0E),gf_mul(inArray((i*4)+2),[1 1 0 0]+value0B)),...
                       bitxor(gf_mul(inArray((i*4)+3),[1 0 0 0]+value0D),gf_mul(inArray((i*4)+4),[1 0 0 0]+value09))...
                       );
        row_02 = bitxor(...
                       bitxor(gf_mul(inArray((i*4)+1),[1 0 0 0]+value09),gf_mul(inArray((i*4)+2),[0 1 0 0]+value0E)),...
                       bitxor(gf_mul(inArray((i*4)+3),[1 1 0 0]+value0B),gf_mul(inArray((i*4)+4),[1 0 0 0]+value0D))...
                       );
        row_03 = bitxor(...
                       bitxor(gf_mul(inArray((i*4)+1),[1 0 0 0]+value0D),gf_mul(inArray((i*4)+2),[1 0 0 0]+value09)),...
                       bitxor(gf_mul(inArray((i*4)+3),[0 1 0 0]+value0E),gf_mul(inArray((i*4)+4),[1 1 0 0]+value0B))...
                       );
        row_04 = bitxor(...
                       bitxor(gf_mul(inArray((i*4)+1),[1 1 0 0]+value0B),gf_mul(inArray((i*4)+2),[1 0 0 0]+value0D)),...
                       bitxor(gf_mul(inArray((i*4)+3),[1 0 0 0]+value09),gf_mul(inArray((i*4)+4),[0 1 0 0]+value0E))...
                       );
        outArray = [outArray; dec2hex(row_01,2); dec2hex(row_02,2); dec2hex(row_03,2); dec2hex(row_04,2)];
    end
    outArray = string(outArray);
end
