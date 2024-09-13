close,clear,clc
% Test_Transmitter.m
freq = 10e9; % 10 GHz
power = 1; % 1 Watt
bw = 200e6; % 200 MHz
chirpDuration = 0.001; % 1 ms

transmitter = Transmitter(freq, power, bw, chirpDuration);
t = linspace(0, chirpDuration, 1000); % Time vector for 1 ms
chirpSignal = transmitter.generateChirp(t);

figure;
plot(t, chirpSignal);
title('FMCW Chirp Signal');
xlabel('Time (s)');
ylabel('Amplitude');
