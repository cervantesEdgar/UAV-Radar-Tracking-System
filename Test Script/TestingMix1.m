clear,clc

% Generate USRP signal
usrpObj = USRP();
usrpObj.frequency = 4.4e9;  % Set frequency to 4.4 GHz
usrpObj.bandwidth = 25e6;   % Set bandwidth to 25 MHz
usrpObj.sweepTime = 1e-3;   % Set sweep time to 1 ms
usrpObj.numSamples = 1e6;   % Set number of samples to 1 million
usrpObj.samplingRate = 1e8; % Number of samples
totalTime= (usrpObj.numSamples-1) / usrpObj.samplingRate;
% time vector
t= linspace(0,totalTime, usrpObj.numSamples);

IFsignal= usrpObj.GenerateSignal(t);

% Generate VCO signal
vcoObj= VCO();
LOsignal= vcoObj.createSignal();

% Amplify 
objAmplify =Amplify(14);
LOamplify = objAmplify.amp(LOsignal);

%Split signal
objSplit = Split();
[signalA,signalB]= objSplit.splitSignal(LOamplify);

% Mixer
objMixer= Mix1(IFsignal,signalA);
RFsignal = objMixer.mix();

numSamples= min(1000, length(RFsignal));

figure;
plot(t(1:numSamples), RFsignal(1:numSamples)); 
title('Mixed RF Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% FFT of the RF signal
len = length(RFsignal); 
fft_RFsignal = fft(RFsignal); % Perform the FFT of the mixed RF signal

% Two-sided spectrum
SP2 = abs(fft_RFsignal / len); 
halfLen= floor(len/2)+1;
SP1 = SP2(1:halfLen); 
SP1(2:end-1) = 2 * SP1(2:end-1); % Double amplitudes for positive frequencies

% Frequency axis
f = usrpObj.samplingRate * (0:(halfLen-1)) / len;

% Plot the FFT of the mixed signal
figure;
plot(f, SP1);
title('FFT of the Mixed RF Signal');
xlabel('Frequency (Hz)');
ylabel('|Amplitude|');
grid on;




