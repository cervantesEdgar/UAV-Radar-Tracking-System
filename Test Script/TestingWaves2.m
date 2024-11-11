%% Radar Specifications 
clear;
close;
clc;

max_range = 200;
range_resolution = 1;
max_velocity = 70;
c = 3e8;  % Speed of light

%% User Defined Target Parameters (Fan Properties)
target_range = 3;      % Distance from radar to the fan center (meters)
r_fan = 0.5;           % Radius of the fan blades (meters)
omega = 30;            % Angular velocity of fan (radians/second)
num_blades = 3;        % Number of blades on the fan

%% FMCW Waveform Generation
B = c /(2*range_resolution);
Tchirp= (5.5*2*max_range)/c;
slope = B/Tchirp;

fc = 10e9;  % Carrier frequency

Nd = 128;  % Number of doppler cells
Nr = 1024; % Number of range cells

t = linspace(0, Nd * Tchirp, Nr * Nd); % Total time for samples

Tx = zeros(1, length(t)); % Transmitted signal
Rx = zeros(1, length(t)); % Received signal
Mix = zeros(1, length(t)); % Beat signal

%% Signal Generation and Fan Blade Simulation
for i = 1:length(t)
    % Calculate position and Doppler shift for each fan blade
    Rx_sum = 0;  % Initialize received signal sum from each blade

    for blade = 1:num_blades
        % Angular position of each blade (blades are evenly spaced)
        angle = omega * t(i) + (blade - 1) * 2 * pi / num_blades;
        
        % Radial velocity of the blade (projected along the line of sight)
        radial_velocity = omega * r_fan * cos(angle);  
        
        % Instantaneous range from radar to each blade
        blade_range = target_range + r_fan * sin(angle);
        time_delay = 2 * blade_range / c;

        % Update transmitted and received signals for each blade
        Tx(i) = cos(2 * pi * (fc * t(i) + (slope * t(i)^2) / 2));
        Rx_blade = cos(2 * pi * (fc * (t(i) - time_delay) + ...
                   (slope * (t(i) - time_delay)^2) / 2 - ...
                   radial_velocity * t(i) * fc / c));
        
        Rx_sum = Rx_sum + Rx_blade;  % Summing contributions from each blade
    end

    Rx(i) = Rx_sum;  % Total received signal is the sum of all blades' signals
    Mix(i) = Tx(i) .* Rx(i);  % Beat signal (mixed transmitted and received signals)
end

%% RANGE MEASUREMENT
sig = reshape(Mix, [Nr, Nd]);
sig_fft1 = fft(sig, Nr);
sig_fft1 = abs(sig_fft1 ./ Nr); % Normalize
sig_fft1 = sig_fft1(1:(Nr / 2)); % Single-sided spectrum

figure('Name', 'Range from First FFT');
plot(sig_fft1, "LineWidth", 2);
grid on;
axis([0 200 0 0.5]);
xlabel('Range (m)');
%title('Range Plot');

%% RANGE DOPPLER RESPONSE
Mix = reshape(Mix, [Nr, Nd]);
sig_fft2 = fft2(Mix, Nr, Nd);
sig_fft2 = fftshift(sig_fft2(1:Nr / 2, 1:Nd));
RDM = abs(sig_fft2);
RDM = 10 * log10(RDM);

doppler_axis = linspace(-100, 100, Nd);
range_axis = linspace(-200, 200, Nr / 2) * ((Nr / 2) / 400);
figure, surf(doppler_axis, range_axis, RDM);
xlabel('Doppler (m/s)');
ylabel('Range (m)');
zlabel('Amplitude (dB)');
%title('Range Doppler Map with Fan Simulation');

%% CFAR Implementation
Tr = 8;
Td = 4;
Gr = 4;
Gd = 2;
offset = 1.4;

RDM = RDM / max(max(RDM));
for i = Tr + Gr + 1 : Nr/2 - (Gr + Tr)
    for j = Td + Gd + 1 : Nd - (Gd + Td)
        noise_level = zeros(1, 1);
        for p = i - (Tr + Gr) : i + (Tr + Gr)
            for q = j - (Td + Gd) : j + (Td + Gd)
                if (abs(i - p) > Gr || abs(j - q) > Gd)
                    noise_level = noise_level + db2pow(RDM(p, q));
                end
            end
        end
        threshold = pow2db(noise_level / (2 * (Td + Gd + 1) * 2 * (Tr + Gr + 1) - (Gr * Gd) - 1));
        threshold = threshold + offset;
        CUT = RDM(i, j);
        if CUT < threshold
            RDM(i, j) = 0;
        else
            RDM(i, j) = 1;
        end
    end
end

RDM(RDM ~= 0 & RDM ~= 1) = 0;
figure('Name', 'CFAR');
surf(doppler_axis, range_axis, RDM);
colorbar;
%title('CFAR with Fan Blades Detection');
