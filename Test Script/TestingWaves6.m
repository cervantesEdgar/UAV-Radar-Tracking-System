%% Signal Processing and Plotting Script for FMCW Data with Separate Transmit and Receive Files

%% 1. Initialization and Data Loading
close all; clear; clc;

% Specify the filenames for transmit and receive files
tx_filename = 'sine.dat';
rx_filename = 'fan_in_room_modified_sine.dat';

% Open the transmit file for reading in binary mode
fid_tx = fopen(tx_filename, 'r');
if fid_tx == -1
    error('Failed to open the transmit file.');
end

% Open the receive file for reading in binary mode
fid_rx = fopen(rx_filename, 'r');
if fid_rx == -1
    error('Failed to open the receive file.');
end

% Read data as complex IQ samples for both transmit and receive signals
tx_data = fread(fid_tx, [2, inf], 'float32=>double');
tx_data = tx_data(1, :) + 1i * tx_data(2, :); % Combine into complex numbers (I + jQ)

rx_data = fread(fid_rx, [2, inf], 'float32=>double');
rx_data = rx_data(1, :) + 1i * rx_data(2, :); % Combine into complex numbers (I + jQ)

% Close the files
fclose(fid_tx);
fclose(fid_rx);

% Sampling rate and capture duration
sampling_rate = 25e6; % 25 MHz for the chosen bandwidth
capture_duration = 0.5; % 500 ms or 0.5 seconds
timeShift = 0.001; %Used to skip beginning of wave
%Skip initial part of wave based on timeShift
num_samples_to_skip = floor(timeShift * sampling_rate);
rx_data = rx_data(num_samples_to_skip + 1:end);
tx_data = tx_data(num_samples_to_skip + 1:end);

% Update the 'time' variable to start from timeShift
time = linspace(timeShift, capture_duration, length(rx_data));

% Ensure the length of the data arrays match
min_samples = min(length(tx_data), length(rx_data));
tx_data = tx_data(1:min_samples);
rx_data = rx_data(1:min_samples);

% Compute the beat frequency signal by multiplying the receive signal with the conjugate of the transmit signal
beat_signal = rx_data .* tx_data;

% Remove the extra 10 kHz component by shifting the signal
beat_signal = beat_signal .* exp(-1i * 2 * pi * 10e3 * time);

% Plot Transmit Wave in Time Domain
figure;
plot(time, real(tx_data), 'b-', 'LineWidth', 1.5);
title('Transmit Wave in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Plot Receive Wave in Time Domain
figure;
plot(time, real(rx_data), 'b-', 'LineWidth', 1.5);
title('Receive Wave in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% 2. Basic Signal Analysis Plots
figure('Name', 'Basic Signal Analysis');

% 2.1. Plot of the Beat Signal in Time Domain
subplot(3,2,1);
plot(time, real(beat_signal), 'b-', 'LineWidth', 1.5);
title('Beat Signal in Time Domain');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% 2.2. Frequency Domain Plot (FFT without Hamming)
N = length(beat_signal);
beat_signal_fft = fft(beat_signal, N);
beat_signal_fft = abs(beat_signal_fft(1:N/2));
f = (0:N/2-1) * (sampling_rate / N);

subplot(3,2,2);
plot(f, beat_signal_fft, 'LineWidth', 1.5);
title('Frequency Domain (No Hamming)');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% 2.3. Frequency Domain Plot (FFT with Hamming Window)
beat_signal_fft_hamming = fft(beat_signal .* hamming(N)', N);
beat_signal_fft_hamming = abs(beat_signal_fft_hamming(1:N/2));

subplot(3,2,3);
plot(f, beat_signal_fft_hamming, 'LineWidth', 1.5);
title('Frequency Domain (With Hamming)');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% 2.4. Power Spectral Density (PSD)
subplot(3,2,4);
[pxx, f_psd] = pwelch(beat_signal, hamming(1024), 512, 1024, sampling_rate);
plot(f_psd, 10*log10(pxx), 'LineWidth', 1.5);
title('Power Spectral Density (PSD)');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
grid on;

% 2.5. Spectrogram
subplot(3,2,5);
spectrogram(beat_signal, hamming(1024), 512, 1024, sampling_rate, 'yaxis');
title('Spectrogram');
colorbar;

%% 3. Advanced Signal Analysis Plots
figure('Name', 'Advanced Signal Analysis');

% Parameters for FFT-based plots
Nr = 1024; % Number of range cells
Nd = floor(length(beat_signal) / Nr); % Calculate Nd based on data length

% Reshape data to matrix form for range-Doppler processing
Mix = reshape(beat_signal(1:Nr*Nd), [Nr, Nd]);

% Apply Hamming window along the range dimension
window = hamming(Nr);
Mix = Mix .* window;

% 3.1. Waterfall Plot
doppler_fft = fft(Mix, Nd, 2);
doppler_fft = fftshift(doppler_fft, 2);
doppler_spectrum = abs(doppler_fft);
doppler_spectrum_dB = 10*log10(doppler_spectrum);
doppler_axis = linspace(-sampling_rate / 2, sampling_rate / 2, Nd);

waterfall(doppler_axis, (1:Nr/2) * (sampling_rate / Nr), doppler_spectrum_dB(1:Nr/2, :));
xlabel('Doppler Frequency (Hz)');
ylabel('Range (m)');
zlabel('Amplitude (dB)');
colorbar;
%title('Waterfall Plot');
view([-30 30]);
grid on;

% Continue with other advanced plots as needed, using `beat_signal` instead of `data`
% RTI Plot, Range-Doppler Plot, etc., will follow similar logic as in the original script.

%sgtitle('Analysis of FMCW Beat Signal');

