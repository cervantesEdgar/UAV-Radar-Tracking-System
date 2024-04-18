clear,clc,close
% Define parameters
Fs = 1000; % Sampling frequency (Hz)
T = 1; % Duration of signal (s)
t = 0:1/Fs:T-1/Fs; % Time vector

% Generate low-amplitude background signal
background_signal = 0.1 * randn(size(t)); % Low-amplitude random noise

% Generate echoes for the two objects at different ranges
range1 = 50; % Range of object 1 (m)
range2 = 100; % Range of object 2 (m)

% Generate echoes for the two objects
echo1 = exp(-(t - 2*range1/(3e8)).^2 / (2*(1/(3e8))^2)); % Gaussian pulse for object 1
echo2 = exp(-(t - 2*range2/(3e8)).^2 / (2*(1/(3e8))^2)); % Gaussian pulse for object 2

% Combine the echoes with the background to simulate radar data
signal = background_signal + echo1 + echo2;

% Plot the simulated radar data
figure;
plot(t, signal);
title('Simulated Radar Data');
xlabel('Time (s)');
ylabel('Amplitude');

% Perform FFT to convert signal to frequency domain
fft_signal = fft(signal);
frequencies = fftshift((-length(signal)/2:length(signal)/2-1)*(Fs/length(signal)));

% Plot FFT of radar signal
figure;
plot(frequencies, abs(fft_signal));
title('FFT of Radar Data');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Find peaks corresponding to object ranges
[~, peak_locs] = findpeaks(abs(fft_signal)); % Find all peaks

if ~isempty(peak_locs) % Check if peaks are found
    % Extract peak frequencies
    peak_frequencies = frequencies(peak_locs);

    % Calculate ranges of the objects
    speed_of_light = 3e8; % Speed of light (m/s)
    range_objects = speed_of_light ./ (2 * peak_frequencies);

    % Plot the ranges of the objects
    figure;
    stem(1:numel(range_objects), range_objects, 'filled');
    title('Ranges of Detected Objects');
    xlabel('Object Index');
    ylabel('Range (m)');
else
    disp('No peaks detected in the FFT signal.');
end
