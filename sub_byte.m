% This function substitutes an input 16-byte string array with its corresponding s-box values
function sBoxOutput = sub_byte(sBoxInput, type)
    sBoxOutput = [];
    for i = 1:length(sBoxInput)
        % S-box substituting by proving the value to the s_box function
        sBoxValue = s_box(sBoxInput(i), type);
        % Adding the variable sBoxValue to the sBoxOutput array
        sBoxOutput = [sBoxOutput ; sBoxValue];
    end
end
