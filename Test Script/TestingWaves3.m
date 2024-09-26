clear; close all; clc;

% Radar parameters
samplingRate = 25e6;  % Sampling rate: 25 MHz
sweepTime = 1e-3;     % Sweep time: 1 ms
frequency = 4.4e9;    % Center frequency: 4.4 GHz
bandwidth = 25e6;     % Bandwidth: 25 MHz
numSamples = samplingRate * sweepTime; % Total number of samples

% Create a time vector
t = (0:numSamples-1) / samplingRate;  % Time vector for one sweep

% Generate a test signal: a chirp (up-sweep)
testSignal = chirp(t, frequency - bandwidth/2, sweepTime, frequency + bandwidth/2);

% Plot the transmitted signal
figure('Name', 'Signal Processing');

% Time-domain plot
subplot(3, 1, 1);
plot(t, testSignal);
xlabel('Time (s)');
ylabel('Amplitude');
title('Transmitted Signal');
grid on;

% Plot the spectrogram
subplot(3, 1, 2);
[S, F, T] = spectrogram(testSignal, 512, 256, 512, samplingRate, 'yaxis');
F = F / 1e9;  % Convert frequency to GHz
imagesc(T, F, 10*log10(abs(S)));  % Convert to dB
axis xy;  % Correct the axis orientation
colorbar;  % Add color bar
ylim([min(F), max(F)]);  % Set y-axis limits based on actual frequency range
title('Spectrogram of the Transmitted Signal');
ylabel('Frequency (GHz)');

waterfall(F,T,abs(S)'.^2)
set(gca,XDir="reverse",View=[30 50])
xlabel("Frequency (Hz)")
ylabel("Time (s)")

% Perform the FFT
fftSignal = fft(testSignal);

% Frequency axis for FFT
N = length(fftSignal);  % Length of the signal
freq = (-N/2:N/2-1) * (samplingRate / N) + frequency;  % Shift by center frequency

% Shift the FFT to center zero frequency
fftShifted = fftshift(fftSignal);

% Create a plot for FFT
subplot(3, 1, 3);
plot(freq/1e9, abs(fftShifted));  % Convert frequency to GHz for plotting
xlim([4.3875 4.4125]);  % Set x-axis limits to GHz
xlabel('Frequency (GHz)');
ylabel('Magnitude');
title('FFT of the Transmitted Signal');
grid on;
