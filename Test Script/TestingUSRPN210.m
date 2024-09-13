% Create an instance of the USRPN210 class
usrp = USRPN210();

% Generate the original waveform
originalWaveform = usrp.generateWaveform();

% Simulate receiving the waveform 
receivedWaveform = originalWaveform;

% Plot the original and received waveforms
usrp.receiveWaveform(receivedWaveform);
