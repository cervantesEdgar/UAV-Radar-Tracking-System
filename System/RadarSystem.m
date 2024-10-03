clc,close
% Setup Global Time Vector
samplingRate = 25e6;  % Sampling rate (25 MHz)
numSamples = 1e6;  % Number of samples (1 million)
t = (0:numSamples-1) / samplingRate;

%Signal Processing Setup
signalProccessing = SignalProcessing();

% Step 1: USRP creates signal
usrp = USRP();
usrpSignal = usrp.GenerateSignal(t);
[usrpFreq, usrpPower] = signalProccessing.getSignalCharacteristics('USRP Signal', usrpSignal,samplingRate);

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
mixedSignalA = mixer.upconvert(usrpSignal, test_cosine_signal);

% Plotting the signals
figure;
% Plot USRP signal 
subplot(3, 1, 1);
plot(t, usrpSignal);
title('USRP Generated Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot test cosine signal 
subplot(3, 1, 2);
plot(t, test_cosine_signal);
title('5.5 GHz Test Cosine Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot mixed signal A 
subplot(3, 1, 3);
plot(t, mixedSignalA);
title('Mixed Signal A');
xlabel('Time (s)');
ylabel('Amplitude');

% Create target
% Receive signal from target

% Received signal goes through low Noise Amplifier
% New signal goes into mixer
% Signal B from splitter goes into mixer

% Add code to receive data

% Send final signal to Plot Results Class
