close all; clear; clc;

% Specify the filename
filename = 'Last_big_metalplate_far_FMCW!.dat';

% Open the file for reading in binary mode
fid = fopen(filename, 'r');
if fid == -1
    error('Failed to open the file.');
end

% Read data as complex IQ samples
data = fread(fid, [2, inf], 'float32'); % Adjust to 'int16' or other if needed
data = data(1, :) + 1i * data(2, :);   % Combine into complex numbers (I + jQ)
fclose(fid);

% Sampling rate and time
sampling_rate = 25e6; % Adjust to actual rate if known
num_samples = length(data);
time = (0:num_samples-1) / sampling_rate;

% Radar parameters (adjust BW based on actual bandwidth)
Nr = 1024; % Suggested number of range cells
Nd = floor(num_samples / Nr); % Doppler bins (number of chirps)
BW = 300e6; % Example bandwidth in Hz, adjust to your actual bandwidth
c = 3e8; % Speed of light
range_res = c / (2 * 12.5e6); % Range resolution
max_range = 25; % Set maximum range to 25 meters
range_idx_limit = find((0:Nr/2 - 1) * range_res >= max_range, 1); % Index up to 25 m range

% Reshape data for RTI processing
Mix = reshape(data(1:Nr*Nd), [Nr, Nd]);

%% RTI Plot Without Clutter Rejection
% Perform FFT on each pulse along range dimension
RTI = fft(Mix, Nr, 1);
RTI = abs(RTI(1:Nr/2, :)); % Take only positive frequencies
RTI_dB = 10 * log10(RTI); % Convert to dB

% Limit range axis to 25 meters
range_bins = (0:Nr/2 - 1) * range_res;
range_axis = range_bins(1:range_idx_limit); % Range up to 25 m
RTI_dB = RTI_dB(1:range_idx_limit, :); % Limit RTI to 25 m range

% Plot RTI without clutter rejection
figure('Name', 'RTI without Clutter Rejection');
imagesc(time, range_axis, RTI_dB, [-80, 0]); % Adjust dB range as needed
xlabel('Time (s)');
ylabel('Range (m)');
title('RTI Plot without Clutter Rejection');
colorbar;

%% RTI Plot with 2-Pulse Canceller (Clutter Rejection)
% Apply 2-pulse canceller by subtracting each pulse from the previous one
sif2 = Mix(:, 2:end) - Mix(:, 1:end-1); % 2-pulse canceller
RTI_clutter_rejected = fft(sif2, Nr, 1);
RTI_clutter_rejected = abs(RTI_clutter_rejected(1:Nr/2, :)); % Take only positive frequencies
RTI_clutter_rejected_dB = 10 * log10(RTI_clutter_rejected); % Convert to dB

% Limit RTI to 25 m range
RTI_clutter_rejected_dB = RTI_clutter_rejected_dB(1:range_idx_limit, :);

% Plot RTI with 2-pulse canceller
figure('Name', 'RTI with 2-Pulse Canceller (Clutter Rejection)');
imagesc(time(1:end-1), range_axis, RTI_clutter_rejected_dB, [-80, 0]); % Adjust dB range as needed
xlabel('Time (s)');
ylabel('Range (m)');
title('RTI Plot with 2-Pulse Canceller (Clutter Rejection)');
colorbar;

%% Additional Optional Plots (Range-Doppler, 1D FFT, etc.) if needed
% Range-Doppler, 1D FFT, Regular FFT, etc. can be added here if required
