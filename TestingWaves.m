% Define parameters
carrierFrequency = 1e6;     % Carrier frequency of the sinusoidal waveform (1 MHz)
samplingFrequency = 1.00001e6;   % Sampling frequency (10 MS/s)
duration = 0.5;             % Duration of the waveform (100 ms)
amplitude = 1;              % Amplitude of the sinusoidal waveform

% Time vector
t = linspace(0, duration, samplingFrequency * duration);

% Generate transmitted sinusoidal waveform
transmittedWaveform = amplitude * sin(2*pi*carrierFrequency*t);

% Simulate channel effects or noise (for demonstration)
% For simplicity, let's add Gaussian noise to the transmitted waveform
noisePower = 0.1; % Adjust noise power as needed
receivedWaveform = transmittedWaveform + sqrt(noisePower) * randn(size(t));

% Plot transmitted waveform
subplot(2, 1, 1);
plot(t, transmittedWaveform, 'b', 'LineWidth', 1.5);  % Transmitted waveform
xlabel('Time (s)');
ylabel('Amplitude');
title('Transmitted Waveform');

% Plot received waveform
subplot(2, 1, 2);
plot(t, receivedWaveform, 'r', 'LineWidth', 1.5);  % Received waveform
xlabel('Time (s)');
ylabel('Amplitude');
title('Received Waveform');
