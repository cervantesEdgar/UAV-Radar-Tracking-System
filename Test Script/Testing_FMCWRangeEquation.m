close, clc, clear
% Given parameters
Pave = 10E-3; % (W) average transmit power, for CW radar this is the transmit power
fc = 10E9; % (Hz) transmit frequency
c = 3E8; % (m/s) speed of light
lambda_c = c/fc; % (m) wavelength

% Antenna gains in linear scale
Gtx_dB = 10; % (dBi) measured gain of transmit antenna
Gtx = 10^(Gtx_dB/10); % convert to linear
Grx_dB = 10; % (dBi) measured gain of receive antenna
Grx = 10^(Grx_dB/10); % convert to linear

% Effective aperture of the receive antenna
Arx = Grx * lambda_c^2 / (4 * pi); % assume rho_rx = 1

% Radar cross-section (RCS) of the target of interest
sigma_dB = -20; % (dBsm)
sigma = 10^(sigma_dB/10); % convert to linear

% Miscellaneous system losses
Ls_dB = 6; % (dB)
Ls = 10^(Ls_dB/10); % convert to linear

% Noise figure
Fn_dB = 1.2; % (dB)
Fn = 10^(Fn_dB/10); % convert to linear

% Thermal noise constants
k = 1.38E-23; % (J/K) Boltzmann's constant
To = 290; % (K) standard temperature

% System noise bandwidth
t_sample = 10E-3; % (s) discrete sample length
Bn = 2 / t_sample; % (Hz) system noise bandwidth

% Required SNR for detection
SNR1_dB = 13.4; % (dB) required SNR
SNR1 = 10^(SNR1_dB/10); % convert to linear

% Maximum range calculation using the radar range equation
Rmax = ((Pave * Gtx * Arx * sigma) / ((4 * pi)^2 * k * To * Fn * Bn * SNR1 * Ls))^(1/4);

% Display the result
disp(['The maximum detection range is: ', num2str(Rmax), ' meters']);
