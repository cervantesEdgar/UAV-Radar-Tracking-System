clc; close all; clear;

% Parameters
fs = 1000;                % Sampling frequency (samples per second)
t = 0:1/fs:1-1/fs;        % Time vector (1 second duration)

% Simulate the signal hitting a target and receiving it
delay = 0.2;              % Delay in seconds (time for signal to travel to target and back)
delay_samples = round(delay * fs); % Convert delay to number of samples

% Frequency increases linearly from 50 Hz to 100 Hz over 1 second
f_start = 50;            % Starting frequency (Hz)
f_end = 100;            % Ending frequency (Hz)
f_shifted = f_start + (f_end - f_start) * t; % Linearly increasing frequency

% Generate the received signal with time-varying frequency
x_received = sin(2*pi*cumsum(f_shifted)/fs); % Integrate frequency to get phase

% Add delay to the signal
x_received = [zeros(1, delay_samples) x_received]; % Add delay to the signal
x_received = x_received(1:length(t));    % Ensure length matches the original time vector

% Add noise to the received signal (optional)
noise = 0.1 * randn(size(x_received)); % Generate random noise
x_received = x_received + noise;       % Add noise to the received signal

% Compute the FFT of the transmitted and received signals
n = length(t);                % Number of samples
X = fft(x_received);          % FFT of the received signal
X_mag = abs(X/n);             % Magnitude of the FFT
X_mag = X_mag(1:n/2+1);       % Keep only the positive frequencies
frequencies = (0:(n/2))/n*fs; % Frequency vector

% Find the peak frequency in the FFT result
[~, idx_received] = max(X_mag); % Index of the peak frequency in the received signal
received_freq = frequencies(idx_received); % Frequency of the received signal

% Calculate the change in frequency (Doppler shift) and distance
doppler_shift = received_freq - f_start;
velocity = doppler_shift * 343 / f_start; % Velocity calculation (assuming speed of sound is 343 m/s)

% Calculate distance based on the delay
distance = (delay * 343) / 2; % Distance calculation (round trip)

% Display results
fprintf('Transmitted Frequency: %.2f Hz\n', f_start);
fprintf('Received Frequency: %.2f Hz\n', received_freq);
fprintf('Doppler Shift: %.2f Hz\n', doppler_shift);
fprintf('Calculated Velocity: %.2f m/s\n', velocity);
fprintf('Calculated Distance: %.2f meters\n', distance);

% Create subplots
figure;

% Received Signal with Delay and Noise
subplot(3,2,1);
plot(t, x_received);
xlabel('Time (s)');
ylabel('Amplitude');
title('Received Signal with Increasing Frequency');

% Frequency Spectrum of the Received Signal
subplot(3,2,2);
plot(frequencies, X_mag); % Plot the magnitude of the received signal's FFT
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum of the Received Signal');

subplot(3,2,3)
spectrogram(x_received, 256, 250, 256, fs, 'yaxis');
title('Spectrogram of Received Signal');
colorbar;

subplot(3,2,4)
psd = abs(X).^2 / length(x_received);
plot(frequencies, 10*log10(psd(1:n/2+1)));
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of Received Signal');

subplot(3,2,5)
[cfs, frequencies] = cwt(x_received, fs);
surf(t, frequencies, abs(cfs), 'EdgeColor', 'none');
axis tight;
view(0, 90);
title('Wavelet Transform of Received Signal');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
