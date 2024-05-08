clear, close, clc

Fs = 2000;
t = 0:1/Fs:1;
f = 200;

figure
subplot(2,1,1)

s1 = sin(2*pi*f*t);
plot(t,s1)
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Time Domain Plot')

subplot(2,1,2)
spectrogram(s1,256,250,260,2E3,'yaxis')