clear, close, clc
amplifier1 = Amplifier(6);
t = linspace(0, 1, 1000); % Time vector from 0 to 1 second with 1000 samples
waveform = sin(2*pi*10e6*t); % Sinusoidal waveform with frequency of 10 MHz
amplifiedWaveform = amplifier1.amplify(waveform, 18);

% Plot original and amplified waveforms
figure;
plot(t, waveform, 'b', 'LineWidth', 1.5);
hold on;
plot(t, amplifiedWaveform, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original and Amplified Waveforms');
legend('Original', 'Amplified');
hold off;

