%% Radar Specifications 
clear;
close;
clc;

% Constants
max_range = 200;
range_resolution = 1;
max_velocity = 70;
c = 3e8; % speed of light

%% User Defined Range and Velocity of targets
% Define initial positions and velocities for two targets
target1_range = 60;      % Initial range for target 1
target1_velocity = 50;  % Velocity for target 1

target2_range = 150;    % Initial range for target 2
target2_velocity = -40; % Velocity for target 2

%% FMCW Waveform Generation

% Calculate the Bandwidth (B), Chirp Time (Tchirp), and Slope (slope)
B = c / (2 * range_resolution);
Tchirp = (5.5 * 2 * max_range) / c;
slope = B / Tchirp;

% Operating carrier frequency of Radar 
fc = 10e9; % carrier frequency in Hz

% Number of chirps and samples
Nd = 128; % number of Doppler cells (number of chirps)
Nr = 1024; % number of range cells (samples per chirp)

% Total time for samples
t = linspace(0, Nd * Tchirp, Nr * Nd);

% Initialize signals
Tx = zeros(1, length(t)); % transmitted signal
Rx = zeros(1, length(t)); % received signal
Mix = zeros(1, length(t)); % beat signal

% Initialize range and time delay vectors for both targets
r_t1 = zeros(1, length(t));
td1 = zeros(1, length(t));

r_t2 = zeros(1, length(t));
td2 = zeros(1, length(t));

%% Signal generation and Moving Target simulation
for i = 1:length(t)
    % Update the range of each target for constant velocity
    r_t1(i) = target1_range + target1_velocity * t(i);
    td1(i) = 2 * r_t1(i) / c;
    
    r_t2(i) = target2_range + target2_velocity * t(i);
    td2(i) = 2 * r_t2(i) / c;
    
    % Generate the transmitted signal
    Tx(i) = cos(2 * pi * (fc * t(i) + (slope * t(i)^2) / 2));
    
    % Generate the received signals for each target and combine them
    Rx1 = cos(2 * pi * (fc * (t(i) - td1(i)) + (slope * (t(i) - td1(i))^2) / 2));
    Rx2 = cos(2 * pi * (fc * (t(i) - td2(i)) + (slope * (t(i) - td2(i))^2) / 2));
    
    % Combined received signal
    Rx(i) = Rx1 + Rx2;
    
    % Generate the beat signal by mixing the Tx and combined Rx
    Mix(i) = Tx(i) .* Rx(i);
end

%% RANGE MEASUREMENT
% Reshape vector into Nr*Nd array
sig = reshape(Mix, [Nr, Nd]);

% Run FFT on the beat signal along the range bins dimension (Nr)
sig_fft1 = fft(sig, Nr);
sig_fft1 = abs(sig_fft1(1:Nr/2)); % Take only one side of the FFT
sig_fft1 = sig_fft1 / max(sig_fft1); % Normalize

% Plotting the range
figure('Name', 'Range from First FFT')
plot(sig_fft1, "LineWidth", 2);
grid on;
axis([0 200 0 1]);
xlabel('Range');
ylabel('Normalized Amplitude');
title('Range Plot');

%% RANGE DOPPLER RESPONSE
Mix = reshape(Mix, [Nr, Nd]);

% 2D FFT using the FFT size for both dimensions
sig_fft2 = fft2(Mix, Nr, Nd);

% Taking just one side of the signal from Range dimension
sig_fft2 = sig_fft2(1:Nr/2, 1:Nd);
sig_fft2 = fftshift(sig_fft2);
RDM = abs(sig_fft2);
RDM = 10 * log10(RDM);

% Plot Range Doppler Map
doppler_axis = linspace(-100, 100, Nd);
range_axis = linspace(-200, 200, Nr/2) * ((Nr/2) / 400);
figure, surf(doppler_axis, range_axis, RDM);
colorbar;
xlabel('Doppler (m/s)');
ylabel('Range (m)');
zlabel('Amplitude (dB)');
%title('Range Doppler Map');

%% CFAR implementation

% Slide Window through the complete Range Doppler Map

% Define Training and Guard Cells
Tr = 8;
Td = 4;
Gr = 4;
Gd = 2;
offset = 1.4;

% Normalize RDM
RDM = RDM / max(max(RDM));

for i = Tr+Gr+1 : Nr/2-(Gr+Tr)
    for j = Td+Gd+1 : Nd-(Gd+Td)
        noise_level = zeros(1,1);
        
        % Loop through Training Cells
        for p = i-(Tr+Gr): i+(Tr+Gr)
            for q = j-(Td+Gd): j+(Td+Gd)
                if (abs(i-p) > Gr || abs(j-q) > Gd)
                    noise_level = noise_level + db2pow(RDM(p, q));
                end
            end
        end
        
        % Average and convert back to dB
        threshold = pow2db(noise_level / (2 * (Td+Gd+1) * 2 * (Tr+Gr+1) - (Gr*Gd) - 1));
        threshold = threshold + offset;
        
        % Apply thresholding
        CUT = RDM(i, j);
        if (CUT < threshold)
            RDM(i, j) = 0;
        else
            RDM(i, j) = 1;
        end
    end
end

% Set all non-thresholded values to 0
RDM(RDM ~= 0 & RDM ~= 1) = 0;

% Plot CFAR Output
figure('Name', 'CFAR Detection')
surf(doppler_axis, range_axis, RDM);
colorbar;
title('CFAR Detection with Offset 1.4');
xlabel('Doppler (m/s)');
ylabel('Range (m)');
zlabel('CFAR Output');
