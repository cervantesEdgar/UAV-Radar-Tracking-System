clc,close
% Setup Global Time Vector
samplingRate = 25e6;  % Sampling rate (25 MHz)
numSamples = 1e6;  % Number of samples (1 million)
t = (0:numSamples-1) / samplingRate;
vcoChrip = 1;       % What device is handling the chirp? (1 = VCO, 0 = USRP)
txFilename = "tx_samples.dat";  % Specify file name to save generated waveform to (only used if vcoChirp = 0)
rxFilename = "rx_samples.dat";  % Specify file name to save received waveform to

%Signal Processing Setup
signalProccessing = SignalProcessing();

% Create USRP object
usrp = USRP();


% Create USRP command
if(vcoChirp == 1)
    usrpCommand = "txrx_loopback_to_file --tx-freq " + num2str(usrp.frequency) + " --rx-freq " + num2str(usrp.frequency)...
        + " --tx-rate " + num2str(usrp.samplingRate) + " --rx-rate " + num2str(usrp.samplingRate)...
        + " --tx-gain " + num2str(usrp.antennaGain) + " --rx-gain " + num2str(usrp.antennaGain)...
        + " --file " + rxFilename + "--nsamps" + num2str(usrp.numSamples) + " --repeat";
else
    % Generate signal to be transmitted
    usrpSignal = usrp.GenerateSignal(t);
    [usrpFreq, usrpPower] = signalProccessing.getSignalCharacteristics('USRP Signal', usrpSignal,samplingRate);
    
    % prep data for writing
    signalIQ = [real(usrpSignal) imag(usrpSignal)];
    
    % Write the signal data to the tx file in binary format
    fileID = fopen(txFilename, 'w');  % 'w' for writing, binary by default
    fwrite(fileID, signalIQ, 'float');  % Writing the signal as double precision values
    fclose(fileID);
    disp(['Signal saved to ', txFilename]);
    
    % create USRP command
    usrpCommand = "**ENTER .exe NAME** --tx-freq " + num2str(usrp.frequency) + " --rx-freq " + num2str(usrp.frequency)...
        + " --tx-rate " + num2str(usrp.samplingRate) + " --rx-rate " + num2str(usrp.samplingRate)...
        + " --tx-gain " + num2str(usrp.antennaGain) + " --rx-gain " + num2str(usrp.antennaGain)...
        + " --tx-file " + txFilename + " --rx-file " + rxFilename + "--nsamps" + num2str(usrp.numSamples) + " --repeat";
end

% Issue USRP command
system(usrpCommand);

% VCO creates signal
vco = VCO();
vcoSignal = vco.createSignal();
% Amplifier amplifies signal of VCO
% Amplified signal goes to 2 way splitter
% 2 way splitter creates two signals
% Signal A and Signal B

% USRP Signal passes to Mixer
% Signal A from splitter also passes to mixer
mixer = Mixer();

% Upconvert USRP signal with the test cosine signal
%mixedSignalA = mixer.upconvert(usrpSignal, test_cosine_signal);

% Plotting the signals

% Create target
% Receive signal from target

% Received signal goes through low Noise Amplifier
% New signal goes into mixer
% Signal B from splitter goes into mixer

% Add code to receive data

% Send final signal to Plot Results Class
