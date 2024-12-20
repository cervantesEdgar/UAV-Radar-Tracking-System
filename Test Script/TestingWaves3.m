clear, close, clc

% Open the transmit file for reading
fid_tx = fopen('FMCW_20MHz_4us.dat', 'r');
tx_data = fread(fid_tx, [2, inf], 'float32=>double');
tx_data = tx_data(1, :) + 1i * tx_data(2, :);  % Combine I and Q into complex numbers
fclose(fid_tx);

% Open the receive file for reading
fid_rx = fopen('metal_plate_in_room_20MHz_4us.dat', 'r');
rx_data = fread(fid_rx, [2, inf], 'float32=>double');
rx_data = rx_data(1, :) + 1i * rx_data(2, :);  % Combine I and Q into complex numbers
fclose(fid_rx);

% Sampling rate and bandwidth
sampling_rate = 25e6; % 25 MHz
bandwidth = 20e6; % 20 MHz
chirp_duration = 4e-6; % 4 us

% Trim longer sample to get both in the same length
min_samples = min(length(tx_data), length(rx_data));
tx_data = tx_data(1:min_samples);
rx_data = rx_data(1:min_samples);

% Calculate the beat signal
beat_signal = rx_data .* conj(tx_data);

% Remove DC component using high-pass filter
[b, a] = butter(1, 0.01, 'high'); % First-order high-pass filter with low cutoff frequency
beat_signal = filter(b, a, beat_signal);

% Perform FFT to analyze the beat signal
N = length(beat_signal);
beat_signal_fft = fft(beat_signal, N);
beat_signal_fft = abs(beat_signal_fft(1:N/2));  % Take one side of the FFT (single-sided)
f = (0:N/2-1) * (sampling_rate / N);

% Calculate the range for each frequency component
c = 3e8; % Speed of light (m/s)
ranges = (c * chirp_duration * f) / (2 * bandwidth);

% Limit the range profile to the expected room size
max_range = 50; % Limit to the expected room size (50 meters)
valid_indices = ranges <= max_range;

% Plot the beat frequency spectrum
figure;
plot(f, beat_signal_fft);
title('Beat Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% Plot the range profile (limited to expected room size)
figure;
plot(ranges(valid_indices), beat_signal_fft(valid_indices));
title('Range Profile (Limited to Expected Room Size)');
xlabel('Range (m)');
ylabel('Amplitude');
grid on;

% Plot Power Spectral Density (PSD) with adjusted parameters
figure;
window_length = 2048; % Increased window length for better frequency resolution
[pxx, f_psd] = pwelch(beat_signal, hamming(window_length), window_length/2, window_length, sampling_rate);
plot(f_psd, 10*log10(pxx), 'LineWidth', 1.5);
title('Power Spectral Density (PSD)');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
grid on;
