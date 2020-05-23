% A script for the formatting of the AES data from a stream to an array.
function outputData = AES_format(inputData)
    outputData = [];
    % If inputData is string array
    if size(inputData,1) > 1
        for i = 1:length(inputData)
            outputData = [outputData, char(inputData(i))];
        end 
    % If inputData is a continuous value
    else
        for i = 1:length(inputData)/2
            % Format values from inputData to a two byte hex string
            % Hence 1a2b3c becomes "1a" "2b" "3c"
            hexValue = string([char(inputData((i*2)-1)),char(inputData((i*2)))]);
            outputData = [outputData; hexValue];
        end
    end
end
