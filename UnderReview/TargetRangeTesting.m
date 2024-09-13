% Define parameters
c = 3e8;  % Speed of light in meters per second (m/s)
fs = 44100;  % Sampling frequency (Hz)
duration = 0.01;  % Duration of the signal (seconds)
distance_to_object = 1;  % Distance to the object in meters (m)
velocity = -8000000;  % Velocity of the object in meters per second (m/s)

% Generate time vector
t = linspace(0, duration, fs*duration);

% Generate original waveform
original_waveform = sin(2*pi*1000*t);  % Example frequency: 1000 Hz

% Calculate time delay for echo
time_delay = 2 * distance_to_object / c;  % Two-way travel time

% Generate received waveform (with echo and Doppler effect)
received_waveform = [zeros(1, round(time_delay*fs)), original_waveform(1:end-round(time_delay*fs))];

% Apply Doppler effect to the received waveform
doppler_shift = velocity / c;  % Relative velocity / speed of light
received_waveform_doppler = received_waveform .* exp(1i * 2*pi*1000*doppler_shift*t);

% Plot original and received waveforms
figure;
plot(t, original_waveform, 'b', 'LineWidth', 1.5); hold on;
plot(t, real(received_waveform_doppler), 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original and Received Waveforms');
legend('Original Waveform', 'Received Waveform (Moving)');
grid on;
