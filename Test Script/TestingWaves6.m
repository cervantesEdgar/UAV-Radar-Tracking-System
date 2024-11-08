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
Nd = floor(num_samples / Nr); % Calculate Nd based on data length

% Reshape data to matrix form for range-Doppler processing
Mix = reshape(data(1:Nr*Nd), [Nr, Nd]);

% Apply Hamming window along the range dimension
window = hamming(Nr);
Mix = Mix .* window;

% 3.1. Waterfall Plot
doppler_fft = fft(Mix, Nd, 2); % Doppler FFT
doppler_fft = fftshift(doppler_fft, 2); % Shift zero frequency to center
doppler_spectrum = abs(doppler_fft);
doppler_spectrum_dB = 10*log10(doppler_spectrum);
doppler_axis = linspace(-sampling_rate / 2, sampling_rate / 2, Nd);

subplot(3,2,1);
waterfall(doppler_axis, (1:Nr/2) * (sampling_rate / Nr), doppler_spectrum_dB(1:Nr/2, :));
xlabel('Doppler Frequency (Hz)');
ylabel('Range (m)');
zlabel('Amplitude (dB)');
title('Waterfall Plot');
view([-30 30]);
grid on;

% 3.2. Range-Time Intensity (RTI) Plot
rti_data = 20 * log10(abs(Mix));
subplot(3,2,2);
imagesc(time, (1:Nr) * (sampling_rate / Nr), rti_data);
axis xy;
title('RTI Plot');
xlabel('Time (s)');
ylabel('Range (m)');
colorbar;

% 3.3. RTI with Clutter Rejection (2-Pulse Canceller)
rti_clutter_rejected = abs(Mix(:, 2:end) - Mix(:, 1:end-1));
rti_clutter_dB = 20 * log10(rti_clutter_rejected);

subplot(3,2,3);
imagesc(time(1:end-1), (1:Nr) * (sampling_rate / Nr), rti_clutter_dB);
axis xy;
title('RTI with Clutter Rejection (2-Pulse Canceller)');
xlabel('Time (s)');
ylabel('Range (m)');
colorbar;

% 3.4. Range-Doppler Plot
range_doppler_spectrum = fftshift(fft2(Mix), 2); % 2D FFT for range-Doppler plot
range_doppler_dB = 20 * log10(abs(range_doppler_spectrum));

subplot(3,2,4);
imagesc(doppler_axis, (1:Nr) * (sampling_rate / Nr), range_doppler_dB);
axis xy;
title('Range-Doppler Plot');
xlabel('Doppler Frequency (Hz)');
ylabel('Range (m)');
colorbar;

% 3.5. Wavelet Transform Plot (Downsampled Data)
% Downsample data to reduce memory requirements for CWT
downsample_factor = 10; % Adjust this factor to balance resolution and memory usage
data_downsampled = downsample(real(data), downsample_factor);
sampling_rate_ds = sampling_rate / downsample_factor;
time_ds = (0:length(data_downsampled)-1) / sampling_rate_ds;

[wt, f_wt] = cwt(data_downsampled, 'amor', sampling_rate_ds); % 'amor' wavelet
subplot(3,2,5);
imagesc(time_ds, f_wt, abs(wt));
axis xy;
title('Wavelet Transform (CWT) on Downsampled Data');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

%% End of Script
sgtitle('Analysis of FMCW Received Signal');
