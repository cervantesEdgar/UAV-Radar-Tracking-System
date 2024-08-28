% Parameters
Fs = 1000;          % Sampling frequency (Hz)
f0 = 600;            % Center frequency of radar signal (Hz)
T = 1;              % Duration of signal (s)
t = 0:1/Fs:T-1/Fs;  % Time vector

% Generate input signal (Radar pulse)
x = cos(2*pi*f0*t);

% Simulate target (Adding some delay and attenuation)
delay = 0.1;        % Delay in seconds
attenuation = 0.5;  % Attenuation factor
target_response = [zeros(1, round(delay*Fs)), x(1:end-round(delay*Fs))] * attenuation;

% Add noise (optional)
noise_power = 0.1;
noise = sqrt(noise_power) * randn(size(x));

% Combine input signal with target response
received_signal = x + target_response + noise;

% Plot input and received signals
figure;
subplot(3,1,1);
plot(t, x);
title('Input Radar Signal');

subplot(3,1,2);
plot(t, target_response);
title('Simulated Target Response');

subplot(3,1,3);
plot(t, received_signal);
title('Received Signal');

% Analyze frequency and amplitude
received_fft = fft(received_signal);
frequencies = linspace(0, Fs, length(received_fft));

figure;
plot(frequencies, abs(received_fft));
title('Frequency Spectrum of Received Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

% Analyze range
% (Add range analysis code here)
