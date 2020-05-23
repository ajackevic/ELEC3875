% Send serial data one byte at a time
function sendData(userData, serialPort)
    for i = 1:16
        % Convert hex value to decimal, for transmission of value
        byteToSend = hex2dec(userData(i));
        % Send decimal value through serial communication
        write(serialPort, byteToSend, "uint8");
    end
end