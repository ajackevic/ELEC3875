%{
This function is responsible for the multiplication of two bytes in GF(2^8)
Note that both inputs require 8-bit values. Byte = [LSB -> MSB]

The first step is to create a matrix that contains all the polynomial degrees
separately from the inputMSDValue. From there these values should be separately
multiplied with the inputValue.
1*inputValue = inputValue
10*inputValue = 1>>inputValue
100*inputValue = 2>>inputValue
They should then be made the same length and XOR'd together to acquire the
multiplication in GF(2)
%}

function output = gf_conv(inputValue, inputMSDValue)
    inputValue = num2str(inputValue);
    %{
    Create a matrix that contains all the polynomial degrees separately.
    Hence 10110001 would become:
    [
      10000000
      00100000
      00010000
      00000001
    ]
    %}
    zeroPosCounter = 0;
    nZeroMatrix = [];
    nZeroValue = "";
    for binaryValue = inputMSDValue
        if binaryValue == 1
            % Add bit 0's before bit 1
            for i = 1:zeroPosCounter
                nZeroValue = nZeroValue + char("0");
            end
            % Add bit 1
            nZeroValue = nZeroValue + char("1");
            % Add bit 0's after bit 1
            for bitAdd = 1:8 - zeroPosCounter - 1
                nZeroValue = nZeroValue + char("0");
            end
            nZeroMatrix = [nZeroMatrix; nZeroValue];
            zeroPosCounter = zeroPosCounter + 1;
            nZeroValue = "";
        else
            zeroPosCounter = zeroPosCounter + 1;
        end
    end

    % Checks first bit of the first nZeroMatrix value. If 1 (10000000) add first
    % nZeroMatrix value to answerMatrix and delete first nZeroMatrix value.
    % Muiltiplication of 1st degree polynomial is the same as 1 * x = x
    answerMatrix = [];
    firstDegree = char(nZeroMatrix(1));
    if firstDegree(1) == '1'
        answerMatrix = [answerMatrix; inputValue];
        nZeroMatrix(1) = [];
        tempAnswer = str2num(inputValue);
    end

    % Do the following if inputMSDValue is greater than 10000000
    if ~isempty(nZeroMatrix)
        % Depending on how many bit 0's are before the bit 1, shift inputValue to the
        % right by the amount of bit 0's. Repeat this for all nZeroMatrix values
        % and add the outputs to the answerMatrix.
        for row = 1:size(nZeroMatrix,1)
            xDegree = nZeroMatrix(row);
            zeroCounter = 0;
            bitShiftValue = string(inputValue);
            for bitValue = char(xDegree)
                if bitValue == '1'
                    for i = 1:zeroCounter
                        bitShiftValue = ["0  " + bitShiftValue];
                    end
                    answerMatrix = [answerMatrix; bitShiftValue];
                else
                    zeroCounter = zeroCounter + 1;
                end
            end
        end

        % Find the largest length of all the values in answerMatrix
       maxLength = 0;
       for row = 1:size(answerMatrix)
           if maxLength < length(char(answerMatrix(row)))
               maxLength = length(char(answerMatrix(row)));
           end
       end

       % Add padding(0) to any answerMatrix values that are not equal to the largest
       % length(maxLength). Required as XOR needs equal length in variables
       for row = 1:size(answerMatrix,1)
           temp = "";
           for b = 0:3:maxLength-length(char(answerMatrix(row)))
               temp = [temp + "  0"];
           end
           answerMatrix(row) = [answerMatrix(row) + temp];
       end

       % Store the converted numbers in tempMatrix from the string values in answerMatrix
       tempMatrix = [];
       for row = 1:size(answerMatrix,1)
           tempMatrix = [tempMatrix; str2num(answerMatrix(row))];
       end

       % XOR all the values in tempMatrix to acquire the GF(2) multiplication
       tempAnswer = tempMatrix(1,:);
       for row = 2:size(tempMatrix,1)
           tempAnswer = bitxor(tempAnswer,tempMatrix(row,:));
       end

       % Remove any MSB 0's
       if length(tempAnswer) > 8
           while tempAnswer(end) ~= 1 && length(tempAnswer) > 8
               tempAnswer(end) = [];
           end
       end
    end

   output = tempAnswer;
end
