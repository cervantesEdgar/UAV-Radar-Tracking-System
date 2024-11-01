% MATLAB script to read a .dat file and plot the wave, including 1D FFT, regular FFT, and 2D FFT visualization
close,clear,clc
% Specify the filename
filename = 'Last_big_metalplate_far_FMCW.dat';

% Open the file for reading in binary mode
fid = fopen(filename, 'r');

if fid == -1
    error('Failed to open the file.');
end

% Read data as complex IQ samples
data = fread(fid, [2, inf], 'int16'); % Read pairs of float values (I and Q values)
data = data(1, :) + 1i * data(2, :);   % Combine into complex numbers (I + jQ)

% Close the file
fclose(fid);

% Assuming the data consists of complex IQ samples
num_samples = length(data);
sampling_rate = 25e6; % Replace this with the correct sampling rate if known
time = (0:num_samples-1) / sampling_rate;

% Plotting the wave (real part for visualization)
figure('Name','Wave Plot');
plot(time, real(data), 'b-', 'LineWidth', 2);
title('Wave Plot');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
legend('Waveform');

%% Dynamic calculation for Nr and Nd based on data length
Nr = 1024; % Number of range cells (can be adjusted as needed)
Nd = floor(num_samples / Nr); % Calculate Nd based on the length of data to fit the data size

% Reshape data to form a matrix for 1D FFT
Mix = reshape(data(1:Nr*Nd), [Nr, Nd]);
sig = Mix(:, 1); % Use the first chirp for range measurement

sig_fft1 = fft(sig, Nr);
sig_fft1 = abs(sig_fft1(1:Nr/2)); % Take only one side of the FFT

figure('Name', '1D FFT Plot (Range Measurement)');
plot(sig_fft1, 'LineWidth', 2);
grid on;
xlabel('Range Bins');
ylabel('Amplitude');
title('1D FFT of the Waveform (Range Measurement)');
legend('FFT Amplitude');

%% Regular FFT Plot
N = length(data);
data_fft = fft(data, N);
data_fft = abs(data_fft(1:N/2)); % Take only one side of the FFT
f = (0:N/2-1) * (sampling_rate / N); % Frequency vector

figure('Name', 'Regular FFT Plot');
plot(f, data_fft, 'LineWidth', 2);
grid on;
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Regular FFT of the Waveform');
legend('FFT Amplitude');

%% 2D FFT Plot (Range-Doppler Map)
% Reshape data to form a matrix for 2D FFT
Mix = reshape(data(1:Nr*Nd), [Nr, Nd]);

% Perform 2D FFT
sig_fft2 = fft2(Mix, Nr, Nd);
sig_fft2 = fftshift(sig_fft2(1:Nr/2, 1:Nd)); % Take only one side and shift zero frequency component to center
RDM = abs(sig_fft2);
RDM = 10*log10(RDM);

% Plot 2D FFT (Range-Doppler Map)
doppler_axis = linspace(-100, 100, Nd);
range_axis = linspace(-200, 200, Nr/2) * ((Nr/2) / 400);
figure('Name', 'Range Doppler Map');
surf(doppler_axis, range_axis, RDM);
xlabel('Doppler (m/s)');
ylabel('Range (m)');
zlabel('Amplitude (dB)');
ti