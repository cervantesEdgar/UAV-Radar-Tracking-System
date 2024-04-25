clc,clear,close

fs = 40;   % Sampling Frequency
T = 1/fs;  % Sampling Period
N = 40;    % Length of Signal
t = (0:N-1)*T; % Time Vector

fc = 3;    % Frequency
Xn = sin(2*pi*fc*t);

plot(t,Xn,'.-', 'MarkerSize',20);
title("Signal")
xlabel("t (Time)")
ylabel("Xn(t)")

Y = fft(Xn);
k = 0:N/2;
freq = k*fs/N;

figure
stem(freq,abs(Y(1:(N/2)+1)));
title("One Side Absolute Value");
xlabel("Frequency (Hz)");