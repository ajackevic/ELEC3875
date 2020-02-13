% This function checks the entered IV value
function IVFlag = IV_check(IVValue)
    IVFlag = false;
    % The check parameters of IV are the same as the Hex key 128-bit check
    IVFlag = key_check(IVValue, "Hex", "128-bit");
    if IVValue == ""
        IVFlag = 0;
    end
end
