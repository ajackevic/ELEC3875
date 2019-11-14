% This function substitutes an input 16-byte string array with its corresponding inverse s-box values
function invSBoxOutput = inv_sub_byte(invSBoxInput)
    invSBoxOutput = [];
    for i = 1:length(invSBoxInput)
        % Inverse S-box substituting by proving the value to the inv_s_box function
        invSBoxValue = inv_s_box(invSBoxInput(i));
        % Adding the variable invSBoxValue to the invSBoxOutput array
        invSBoxOutput = [invSBoxOutput ; invSBoxValue];
    end
end
