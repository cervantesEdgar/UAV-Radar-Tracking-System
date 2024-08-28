clc; close all; clear;

% Parameters
fs = 1000;                % Sampling frequency (samples per second)
t = 0:1/fs:1-1/fs;        % Time vector (1 second duration)
f = 50;                    % Frequency of the sine wave (Hz)
x = sin(2*pi*f*t);        % Original sine wave

% Simulate the signal hitting a target and receiving it
delay = 0.2;              % Delay in seconds (time for signal to travel to target and back)
delay_samples = round(delay * fs); % Convert delay to number of samples

% Create the received signal
x_received = [zeros(1, delay_samples) x]; % Add delay to the signal
x_received = x_received(1:length(t));    % Ensure length matches the original time vector

% Add noise to the received signal (optional)
noise = 0.1 * randn(size(x_received)); % Generate random noise
x_received = x_received + noise;       % Add noise to the received signal

% Compute the FFT of the transmitted and received signals
n = length(x);                % Number of samples
X = fft(x);                   % FFT of the transmitted signal
X_mag = abs(X/n);             % Magnitude of the FFT
X_mag = X_mag(1:n/2+1);       % Keep only the positive frequencies
frequencies = (0:(n/2))/n*fs; % Frequency vector

X_received = fft(x_received); % FFT of the received signal
X_received_mag = abs(X_received/n); % Magnitude of the FFT
X_received_mag = X_received_mag(1:n/2+1); % Keep only the positive frequencies

% Find the peak frequency in the FFT result
[~, idx] = max(X_mag); % Index of the peak frequency in the transmitted signal
transmitted_freq = frequencies(idx); % Frequency of the transmitted signal

[~, idx_received] = max(X_received_mag); % Index of the peak frequency in the received signal
received_freq = frequencies(idx_received); % Frequency of the received signal

% Calculate the change in frequency (Doppler shift) and distance
doppler_shift = received_freq - transmitted_freq;
velocity = doppler_shift * 343 / transmitted_freq; % Velocity calculation (assuming speed of sound is 343 m/s)

% Calculate distance based on the delay
distance = (delay * 343) / 2; % Distance calculation (round trip)

% Display results
fprintf('Transmitted Frequency: %.2f Hz\n', transmitted_freq);
fprintf('Received Frequency: %.2f Hz\n', received_freq);
fprintf('Doppler Shift: %.2f Hz\n', doppler_shift);
fprintf('Calculated Velocity: %.2f m/s\n', velocity);
fprintf('Calculated Distance: %.2f meters\n', distance);

% Create subplots
figure;

% Original Transmitted Signal
subplot(3,1,1);
plot(t, x);
xlabel('Time (s)');
ylabel('Amplitude');
title('Transmitted Signal');

% Received Signal with Delay and Noise
subplot(3,1,2);
plot(t, x_received);
xlabel('Time (s)');
ylabel('Amplitude');
title('Received Signal with Delay and Noise');

% Frequency Spectrum of the Transmitted Signal
subplot(3,1,3);
plot(frequencies, X_mag);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum of the Transmitted Signal');
