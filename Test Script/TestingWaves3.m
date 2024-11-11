% MATLAB Script to simulate a wave and its waterfall plot, specifically showing a target reflection
clear,close all,clc
% Parameters for the wave simulation
fs = 1000; % Sampling frequency in Hz
duration = 2; % Duration in seconds
t = 0:1/fs:duration-1/fs; % Time vector from 0 to 2 seconds
f0 = 100; % Carrier frequency in Hz
velocity_target = 20; % Velocity of the target in m/s (affects Doppler shift)
c = 340; % Speed of sound in air in m/s
f_doppler = (velocity_target / c) * f0; % Doppler frequency shift

% Generate the original transmitted wave
transmitted_wave = cos(2 * pi * f0 * t);

% Simulate the reflected signal with Doppler shift
doppler_wave = cos(2 * pi * (f0 + f_doppler) * t);
delay_samples = round(0.2 * fs); % Delay in samples to simulate target distance
reflected_wave = [zeros(1, delay_samples), doppler_wave(1:end-delay_samples)];

% Add noise to the received signal to simulate realistic conditions
noise = 0.1 * randn(size(reflected_wave)); % Generate random noise with standard deviation of 0.1
received_signal = reflected_wave + noise;

% Create a combined received signal including both transmitted and reflected components
combined_signal = transmitted_wave + received_signal;

% Plot the time domain of the combined signal
figure;
plot(t, combined_signal);
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Add figure caption
disp('Fig. 1. Combined transmitted and received signal with target reflection and noise.');

% Plot the waterfall plot (or spectrogram) to visualize target reflection
figure;
window_size = 256; % Size of the window for the spectrogram
overlap = 200; % Overlap between windows
nfft = 512; % Number of FFT points
spectrogram(combined_signal, window_size, overlap, nfft, fs, 'yaxis');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

% Add figure caption for waterfall plot
disp('Fig. 2. Waterfall plot of the received signal showing the frequency shift due to target reflection.');
