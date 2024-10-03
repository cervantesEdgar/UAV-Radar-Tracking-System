clc,close,clear

%Signal Processing Setup
signalProccessing = SignalProcessing();

% Step 1: USRP creates signal
usrp = USRP();
usrpSignal = usrp.generateSineWave();
[usrpFreq, usrpPower] = signalProccessing.getSignalCharacteristics('USRP Signal', usrpSignal,usrp.samplingRate);

signalProccessing.processSignal(usrpSignal,usrp.samplingRate);

% Add code to transmit

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
