function outputArray = shift_row(inputArray)
    temp = inputArray(14);
    inputArray(14) = inputArray(2);
    inputArray(2) = inputArray(6);
    inputArray(6) = inputArray(10);
    inputArray(10) = temp;


    inputArray(3) = inputArray(11);
    inputArray(11) = temp;
    inputArray(7) = inputArray(15);
    temp = inputArray(3);
    inputArray(11) = temp;
    temp = inputArray(7);
    inputArray(15) = temp;

    disp(inputArray)
end
