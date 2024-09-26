clear,close,clc
% Define radar parameters
radarParams = USRP();
oneSignal = radarParams.GenerateSignal();

% Process and plot the transmitted signal
SignalProcessing.processSignal(oneSignal, radarParams.samplingRate,radarParams.frequency);

usrp = USRP();


filename = 'signal_output.dat';
% Generate the signal
signal = usrp.GenerateSignal();

% Open the file for writing in binary mode
fileID = fopen(filename, 'w');  % 'w' for writing, binary by default

if fileID == -1
    error('Failed to open the file.');
end

% Write the signal data to the file in binary format
fwrite(fileID, signal, 'double');  % Writing the signal as double precision values

% Close the file
fclose(fileID);

disp(['Signal saved to ', filename]);

% Open the .dat file for reading in binary mode
fileID = fopen('signal_output.dat', 'r');

% Read the raw bytes as uint8 (unsigned 8-bit integers)
rawData = fread(fileID, '*uint8');  % Read as unsigned 8-bit integers

% Close the file
fclose(fileID);

% Initialize an empty string to store the binary representation
binaryRepresentation = '';

% Convert each byte to its binary representation
for i = 1:length(rawData)
    % Convert each byte to a binary string of length 8
    binaryString = dec2bin(rawData(i), 8);

    % Append the binary string to the representation
    binaryRepresentation = [binaryRepresentation, binaryString];
end

% Display the binary representation
disp('Binary representation of the .dat file:');
disp(binaryRepresentation);
