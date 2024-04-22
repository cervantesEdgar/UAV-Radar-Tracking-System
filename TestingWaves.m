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


    % Create a single figure
    figure

    % Plot 1: Time Domain Plot
    subplot(3,2,1)
    plot(t,s)
    xlabel('Time (seconds)');
    ylabel('Amplitude');
    title('Time Domain Plot')

    % Plot 2: Signal After Windowing
    s_windowed = s.*hamming(length(s))'; % assuming N is defined somewhere
    subplot(3,2,2)
    plot(s_windowed)
    xlabel('Samples');
    ylabel('Amplitude');
    title('Signal After Windowing')

    % Plot 3: Signal After Zero Padding
    s_padded = [s_windowed zeros(1,2000)];
    subplot(3,2,3)
    plot(s_padded);
    xlabel('Samples');
    ylabel('Amplitude');
    title('Signal After Zero Padding')

    % Plot 4: Frequency Domain Plot
    S = fft(s_padded);
    subplot(3,2,4)
    plot(abs(S))
    xlabel('Samples');
    ylabel('Magnitude');
    title('Frequency Domain Plot')

    % Plot 5: Frequency Domain Plot (Zoomed)
    S_OneSide = S(1:length(S)/2);
    f = fs*(0:length(S)/2-1)/length(S);
    S_meg = abs(S_OneSide)/(length(s)/4);
    subplot(3,2,[5,6])
    plot(f,S_meg)
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
    title('Frequency Domain Plot (Zoomed)')


phase1 = angle(S_OneSide(f1*duration+1))
phase2 = angle(S_OneSide(f2*duration+1))
phase3 = angle(S_OneSide(f3*duration+1))
