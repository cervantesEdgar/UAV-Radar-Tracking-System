% Signal Processing and Plotting Script for FMCW Data
% This script reads .dat data, processes it, and generates various analysis plots.

%% 1. Initialization and Data Loading
close all; clear; clc;

% Specify the filename
filename = 'cars_in_parking_lot_500ms_50kHzSweep.dat';

% Open the file for reading in binary mode
fid = fopen(filename, 'r');
if fid == -1
    error('Failed to open the file.');
end

% Read data as complex IQ samples
data = fread(fid, [2, inf], 'float32');
data = data(1, :) + 1i * data(2, :); % Combine into complex numbers (I + jQ)

% Close the file
fclose(fid);

% Sampling rate
sampling_rate = 1e6; % 1 MHz for 50 kHz bandwidth
num_samples = length(data);
%time = (0:num_samples-1) / sampling_rate;

% Given that the signal is 500 ms long
capture_duration = 0.5; % 500 ms or 0.5 seconds
time = linspace(0, capture_duration, num_samples);



%% 2. First Figure: Basic Signal Analysis Plots
figure('Name', 'Basic Signal Analysis');

% 2.1. Plot of the Signal in Time Domain
subplot(3,2,1);
plot(time, real(data), 'b-', 'LineWidth', 1.5);
title('Time Domain Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% 2.2. Frequency Domain Plot (FFT without Hamming)
N = length(data);
data_fft = fft(data, N); % No windowing
data_fft = abs(data_fft(1:N/2)); % Take only one side of the FFT
f = (0:N/2-1) * (sampling_rate / N); % Frequency vector

subplot(3,2,2);
plot(f, data_fft, 'LineWidth', 1.5);
title('Frequency Domain (No Hamming)');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% 2.3. Frequency Domain Plot (FFT with Hamming Window)
data_fft_hamming = fft(data .* hamming(N)', N);
data_fft_hamming = abs(data_fft_hamming(1:N/2));

subplot(3,2,3);
plot(f, data_fft_hamming, 'LineWidth', 1.5);
title('Frequency Domain (With Hamming)');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% 2.4. Power Spectral Density (PSD)
subplot(3,2,4);
[pxx, f_psd] = pwelch(data, hamming(1024), 512, 1024, sampling_rate);
plot(f_psd, 10*log10(pxx), 'LineWidth', 1.5);
title('Power Spectral Density (PSD)');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
grid on;

% 2.5. Spectrogram
subplot(3,2,5);
spectrogram(data, hamming(1024), 512, 1024, sampling_rate, 'yaxis');
title('Spectrogram');
colorbar;

%% 3. Second Figure: Advanced Signal Analysis Plots
figure('Name', 'Advanced Signal Analysis');

% Parameters for FFT-based plots
Nr = 1024; % Number of range cells
Nd = floor(num_samples / Nr); % Calculate Nd based on data le