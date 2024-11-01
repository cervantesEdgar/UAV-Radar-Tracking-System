close, clear, clc
% Specify the filename
filename = 'Last_big_metalplate_far_FMCW.dat';

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

% Begin plotting
figure('Name','All Plots');

% 1. Wave Plot (Real Part)
subplot(3,2,1);
plot(time, real(data), 'b-', 'LineWidth', 2);
title('Wave Plot');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% 2. 1D FFT for Range Measurement
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

% 4. 2D FFT Plot (Range-Doppler Map)
sig_fft2 = fft2(Mix, Nr, Nd);
sig_fft2 = fftshift(sig_fft2(1:Nr/2, 1:Nd)); % Take one side and shift
RDM = abs(sig_fft2);
RDM = 10*log10(RDM);

doppler_axis = linspace(-100, 100, Nd);
range_axis = linspace(-200, 200, Nr/2) * ((Nr/2) / 400);

subplot(3,2,4);
surf(doppler_axis, range_axis, RDM);
xlabel('Doppler (m/s)');
ylabel('Range (m)');
zlabel('Amplitude (dB)');
title('Range Doppler Map');
colorbar;

% 5. Doppler Shift Plot
doppler_fft = fft(Mix, Nd, 2); % FFT along Doppler axis
doppler_fft = fftshift(doppler_fft, 2);
doppler_spectrum = abs(doppler_fft);
doppler_spectrum = 10*log10(doppler_spectrum);

doppler_axis = linspace(-sampling_rate / 2, sampling_rate / 2, Nd);

subplot(3,2,5);
plot(doppler_axis, doppler_spectrum(1, :), 'LineWidth', 2); % Taking one range bin for Doppler shift
title('Doppler Shift');
xlabel('Dop