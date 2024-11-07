close all; clear; clc;

% Specify the filename
filename = 'joeseph_is_holding_the_big_metalplate_and_is_walking_towards_the_fan_SINE.dat';

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

% Sampling rate (adjust if known)
sampling_rate = 25e6; 
num_samples = length(data);
time = (0:num_samples-1) / sampling_rate;

% Parameters for FFT
Nr = 1024; % Number of range cells (adjust as needed)
Nd = floor(num_samples / Nr); % Calculate Nd based on data length

% Reshape data to matrix form for FFT processing
Mix = reshape(data(1:Nr*Nd), [Nr, Nd]);

% Apply Hamming window to reduce spectral leakage
window = hamming(Nr);
Mix = Mix .* window; % Apply window to each column (range FFT)

% Begin plotting
figure('Name','Comprehensive Analysis of Received Signal');

% 1. Wave Plot (Real Part)
subplot(3,2,1);
plot(time, real(data), 'b-', 'LineWidth', 2);
title('Wave Plot of Received Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% 2. FFT with Hamming (Frequency Analysis)
N = length(data);
data_fft = fft(data .* hamming(N)', N); % Apply Hamming before FFT
data_fft = abs(data_fft(1:N/2)); % Take only one side of the FFT
f = (0:N/2-1) * (sampling_rate / N); % Frequency vector

subplot(3,2,2);
plot(f, data_fft, 'LineWidth', 2);
title('Hamming FFT of Received Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% 3. Power Spectral Density (PSD) of Received Signal
subplot(3,2,3);
[pxx, f_psd] = pwelch(data, hamming(1024), 512, 1024, sampling_rate);
plot(f_psd, 10*log10(pxx), 'LineWidth', 2);
title('Power Spectral Density (PSD) of Received Signal');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
grid on;

% 4. Spectrogram of Received Signal
subplot(3,2,4);
spectrogram(data, hamming(1024), 512, 1024, sampling_rate, 'yaxis');
title('Spectrogram of Received Signal');
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
title('Doppler Shift (Smoothed) of Received Signal');
xlabel('Doppler Frequency (Hz)');
ylabel('Amplitude (dB)');
grid on;

% 6. Waterfall Plot of Doppler Spectrum
subplot(3,2,6);
waterfall(doppler_axis, (1:Nr/2) * (sampling_rate / Nr), doppler_spectrum(1:Nr/2, :));
xlabel('Doppler Frequency (Hz)');
ylabel('Range (m)');
zlabel('Amplitude (dB)');
title('Waterfall Plot of Received Signal');
view([-30 30]);
grid on;

% Display all subplots in one figure
sgtitle('Analysis of FMCW Received Signal');
