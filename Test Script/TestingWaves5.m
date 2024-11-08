% MATLAB script to read a .dat file and plot the wave, including 1D FFT, regular FFT, and 2D FFT visualization
close all; clear; clc;

% Specify the filename
filename = 'Last_big_metalplate_far_FMCW.dat';

% Open the file and check for errors
fid = fopen(filename, 'r');
if fid == -1
    error('Failed to open the file.');
end

% Read data as complex IQ samples directly
data = fread(fid, 'int16=>double'); % Convert directly to double for better performance with complex
fclose(fid);
data = data(1:2:end) + 1i * data(2:2:end); % Create complex IQ samples

% Set parameters
num_samples = length(data);
sampling_rate = 25e6; % Replace with correct sampling rate if known
time = (0:num_samples-1) / sampling_rate;

% Plotting the wave (real part for visualization)
figure('Name','Wave Plot');
plot(time, real(data), 'b-', 'LineWidth', 2);
title('Wave Plot');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
legend('Waveform');

% FFT settings based on data length
Nr = 1024; % Number of range cells (adjust as needed)
Nd = floor(num_samples / Nr); % Calculate Nd based on the data length

% Reshape data for 1D FFT and 2D FFT
Mix = reshape(data(1:Nr*Nd), [Nr, Nd]);
sig = Mix(:, 1); % Use the first chirp for range measurement

% 1D FFT (Range Measurement)
sig_fft1 = abs(fft(sig, Nr));
sig_fft1 = sig_fft1(1:Nr/2); % Take only one side of the FFT

figure('Name', '1D FFT Plot (Range Measurement)');
plot(sig_fft1, 'LineWidth', 2);
grid on;
xlabel('Range Bins');
ylabel('Amplitude');
title('1D FFT of the Waveform (Range Measurement)');
legend('FFT Amplitude');

% Regular FFT Plot
N = length(data);
data_fft = abs(fftshift(fft(data, N)));
f = (-N/2:N/2-1) * (sampling_rate / N); % Frequency vector centered at 0

figure('Name', 'Regular FFT Plot');
plot(f, data_fft, 'LineWidth', 2);
grid on;
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Regular FFT of the Waveform');
legend('FFT Amplitude');

% 2D FFT (Range-Doppler Map)
sig_fft2 = abs(fftshift(fft2(Mix, Nr, Nd)));
RDM = 10*log10(sig_fft2(1:Nr/2, :)); % Range-Doppler Map in dB

% Plot 2D FFT (Range-Doppler Map)
doppler_axis = linspace(-100, 100, Nd);
range_axis = linspace(-200, 200, Nr/2) * ((Nr/2) / 400);

figure('Name', 'Range Doppler Map');
surf(doppler_axis, range_axis, RDM, 'EdgeColor', 'none');
xlabel('Doppler (m/s)');
ylabel('Range (m)');
zlabel('Amplitude (dB)');
title('Range Doppler Map');
colorba