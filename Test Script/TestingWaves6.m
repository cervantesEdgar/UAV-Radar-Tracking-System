close, clear, clc
% Specify the filename
filename = 'big_metalplate_18_ft_2_ft_FMCW.dat';

% Open the file for reading in binary mode
fid = fopen(filename, 'r');

if fid == -1
    error('Failed to open the file.');
end

% Read data as complex IQ samples
data = fread(fid, [2, inf], 'int16');
data = data(1, :) + 1i * data(2, :); % Combine into complex numbers (I + jQ)

% Close the file
fclose(fid);

% Sampling rate (adjust if known)
sampling_rate = 25e6; 
num_samples = length(data);
time = (0:num_samples-1) / sampling_rate;

% Parameters for FFT
Nr = 1024; % Number of range cells (adjust as needed)
Nd = floor(num_samples / Nr); % Calculate Nd based on data length

% Reshape data to matrix form for 2D FFT processing
Mix = reshape(data(1:Nr*Nd), [Nr, Nd]);

% Apply Hamming window to reduce spectral leakage
window = hamming(Nr);
Mix = Mix .* window; % Apply window to each column (range FFT)

% Begin plotting
figure('Name','All Plots');

% 1. Wave Plot (Real Part)
subplot(3,2,1);
plot(time, real(data), 'b-', 'LineWidth', 2);
title('Wave Plot');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% 2. 1D FFT for Range Measurement with Noise Reduction (Windowed)
sig = Mix(:, 1); % Use the first chirp for range measurement
sig_fft1 = fft(sig, Nr);
sig_fft1 = abs(sig_fft1(1:Nr/2)); % Take only one side of the FFT

subplot(3,2,2);
plot(sig_fft1, 'LineWidth', 2);
title('1D FFT (Range Measurement)');
xlabel('Range Bins');
ylabel('Amplitude');
grid on;

% 3. Regular FFT Plot
N = length(data);
data_fft = fft(data, N);
data_fft = abs(data_fft(1:N/2)); % Take only one side of the FFT
f = (0:N/2-1) * (sampling_rate / N); % Frequency vector

subplot(3,2,3);
plot(f, data_fft, 'LineWidth', 2);
title('Regular FFT');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% 4. 2D FFT Plot (Range-Doppler Map) with Thresholding
sig_fft2 = fft2(Mix, Nr, Nd);
sig_fft2 = fftshift(sig_fft2(1:Nr/2, 1:Nd)); % Take one side and shift
RDM = abs(sig_fft2);
RDM = 10*log10(RDM);

% Apply a threshold to reduce noise in the Range-Doppler Map
RDM(RDM < -60) = -60; % Set a minimum threshold (adjust as needed)

doppler_axis = linspace(-100, 100, Nd);
range_axis = linspace(-200, 200, Nr/2) * ((Nr/2) / 400);

subplot(3,2,4);
surf(doppler_axis, range_axis, RDM);
xlabel('Doppler (m/s)');
ylabel('Range (m)');
zlabel('Amplitude (dB)');
title('Range Doppler Map (Thresholded)');
colorbar;

% 5. Doppler Shift Plot with Smoothing
doppler_fft = fft(Mix, Nd, 2); % FFT along Doppler axis
doppler_fft = fftshift(doppler_fft, 2);
doppler_spectrum = abs(doppler_fft);
doppler_spectrum = 10*log10(doppler_spectrum);

doppler_axis = linspace(-sampling_rate / 2, sampling_rate / 2, Nd);

% Smooth Doppler data by averaging across range bins
doppler_spectrum_smoothed = mean(doppler_spectrum, 1);

subplot(3,2,5);
plot(doppler_axis, doppler_spectrum_smoothed, 'LineWidth', 2); % Averaged Doppler spectrum
title('Doppler Shift (Smoothed)');
xlabel('Doppler Frequency (Hz)');
ylabel('Amplitude (dB)');
grid on;

% 6. Range Plot with Low-Pass Filter
range_fft = fft(Mix(:, 1), Nr); % FFT along range axis for first chirp
range_spectrum = abs(range_fft(1:Nr/2));

% Design a simple low-pass filter (adjust cutoff frequency as needed)
cutoff_frequency = 1e6; % Example cutoff frequency (1 MHz)
[b, a] = butter(5, cutoff_frequency / (sampling_rate / 2), 'low'); % 5th-order Butterworth
range_spectrum_filtered = filtfilt(b, a, range_spectrum);

range_axis = (0:Nr/2-1) * (sampling_rate / Nr);

subplot(3,2,6);
plot(range_axis, range_spectrum_filtered, 'LineWidth', 2);
title('Range Plot (Low-Pass Filtered)');
xlabel('Range (m)');
ylabel('Amplitude');
grid on;

% Display all subplots in one figure
sgtitle('Comprehensive FMCW Analysis with Noise Reduction');
