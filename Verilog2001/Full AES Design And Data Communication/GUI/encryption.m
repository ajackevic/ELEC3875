% This function takes input from the GUI, formats the data, creates the
% configData and sends of the informatino to the FPGA.
function encryptOutput = encryption(userData, inputKey, hexCypherMode, dataFormat)
    % Format the user data
    hexUserData = format_encrypt_in(userData, dataFormat);
    % Create the ConfigData data block
    hexConfigData = create_config(hexUserData, hexCypherMode);
    % Convert the key to correct format
    hexKey = convertKeyToHex(inputKey);
    
    % Init send
    % Establish a serial port connection
    % Pause required as MATLAB experiances data loss without it
    FPGAPort = serialport("COM3",115200);
    sendData(hexConfigData, FPGAPort);
    pause(0.5);
    sendData(hexKey, FPGAPort);
    pause(0.5);
    encryptData = [];

    % Send a data block, retrieve the corresponding output from the FPGA, 
    % then send the data to the GUI.
    for i = 1:length(hexUserData)/16
        sendData(hexUserData((16*i)-15:(16*i)), FPGAPort);
        pause(0.5);
        numBytesAvailable = FPGAPort.NumBytesAvailable;
        dataIn = string(dec2hex(read(FPGAPort, numBytesAvailable, "uint8")));
        encryptData = [encryptData; dataIn(1:16)];
    end
    
    % Format the recived data to the required format of the GUI.
    encryptOutput = AES_format(encryptData);
    
end
