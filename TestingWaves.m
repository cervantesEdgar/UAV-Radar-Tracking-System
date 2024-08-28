% Basic Radar Signal Simulation
clc
close all;
clear all;

% Number of samples
N = 1e6;

% Parameters for the transmitted signal
fc = 1E9; % Carrier frequency (Hz)
Fs = 2.5E7; % Sampling frequency (Hz)
A = 1; % Amplitude of the signal

% Time vector
t = (0:N-1)/Fs;

% Generate transmitted signal (1 GHz sine wave)
transmitted_signal = A * sin(2 * pi * fc * t);

% Read the received signal from the file
fid = fopen("C:\Users\edgar.cervantes\OneDrive - Vallarta Food Enterprises, Inc\Documents\MATLAB\UAV Radar\UAV-Radar-Tracking-System\test8.dat","r");
data = fread(fid,[N/2,2],'int16'); % Read 1e6 samples
fclose(fid);

% Convert the read data to a complex signal
received_signal = reshape(data,2,[])' * [1; 1i];

% Plot the transmitted signal
figure;
subplot(2,1,1);
plot(t(1:1000) * 1E6, transmitted_signal(1:1000)); % Plot a small portion for clarity
title('Transmitted Signal (1 GHz Sine Wave)');
xlabel('Time (microseconds)');
ylabel('Amplitude');

% Plot the received signal
subplot(2,1,2);
plot(t(1:1000) * 1E6, real(received_signal(1:1000))); % Plot real part for comparison
title('Received Signal');
xlabel('Time (microseconds)');
ylabel('Amplitude');
