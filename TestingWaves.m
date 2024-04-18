close; clear; clc;
fs = 500; %Sampling Frequency (Hz)
duration = 0.65; %Duration (Seconds)

N = fs*duration; %Total number of samples
t = 0:1/fs:duration-1/fs; % Time Vector

a1 = 3; f1 = 30; phi1 = 0.6;
a2 = 2; f2 = 45; phi2 = -0.8;
a3 = 1; f3 = 70; phi3 = 2;

s1 = a1*cos(2*pi*f1*t + phi1);
s2 = a2*cos(2*pi*f2*t + phi2);
s3 = a3*cos(2*pi*f3*t + phi3);

s = s1 + s2 + s3;

figure
plot(t,s)
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Time Domain Plot')

s = s.*hamming(N)';
figure
plot(s)
xlabel('Samples');
ylabel('Amplitude');
title('Signal After Windowing')

s = [s zeros(1,2000)];

N2 = length(s);
figure
plot(s);
xlabel('Samples');
ylabel('Amplitude');
title('Signal After Zero Padding')

S = fft(s);
figure
plot(abs(S))
xlabel('Samples');
ylabel('Magnitude');
title('Frequency Domain Plot')

S_OneSide = S(1:N2/2);
f = fs*(0:N2/2-1)/N2;
S_meg = abs(S_OneSide)/(N/4);
figure
plot(f,S_meg)
xlabel('Frequenzy (Hz)');
ylabel('Amplitude');
title('Frequency Domain Plot')

phase1 = angle(S_OneSide(f1*duration+1))
phase2 = angle(S_OneSide(f2*duration+1))
phase3 = angle(S_OneSide(f3*duration+1))
