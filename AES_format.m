% This function formats the string array to a continuous char value
function outputData = AES_format(inputData)
    outputData = [];
    % If inputData is string array 
    if size(inputData,1) > 1
        for i = 1:length(inputData)
            outputData = [outputData, char(inputData(i))];
        end
    end
end
