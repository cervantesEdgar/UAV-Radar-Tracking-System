% Create an instance of LocalOscillator
oscillator = LocalOscillator(7); % Specify the frequency as 7 GHz

% Generate waveform
waveform = oscillator.createWaveform();

% Plot the waveform
figure;
plot(waveform);
xlabel('Sample');
ylabel('Amplitude');
title('Generated Waveform');
