% Define parameters
fs = 1000;      % Sampling frequency (Hz)
duration = 10;  % Duration of the signal (seconds)
t = linspace(0, duration, fs*duration);

% Object moving slowly (low Doppler shift)
f_slow = 1;     % Frequency of the slow-moving object (Hz)
y_slow = sin(2*pi*f_slow*t);

% Object moving faster (higher Doppler shift)
f_fast = 5;     % Frequency of the fast-moving object (Hz)
y_fast = sin(2*pi*f_fast*t);

% Decompose slow-moving object into original waves
y_slow_wave1 = 0.5 * (y_slow + sin(2*pi*(f_slow - f_fast)*t));
y_slow_wave2 = 0.5 * (y_slow - sin(2*pi*(f_slow - f_fast)*t));

% Decompose fast-moving object into original waves
y_fast_wave1 = 0.5 * (y_fast + sin(2*pi*(f_fast - f_slow)*t));
y_fast_wave2 = 0.5 * (y_fast - sin(2*pi*(f_fast - f_slow)*t));

% Plot slow-moving object waves
figure;
subplot(2, 1, 1);
plot(t, y_slow_wave1, 'b', 'LineWidth', 1.5);
hold on;
plot(t, y_slow_wave2, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Decomposition of Slow-Moving Object Waves');
legend('Wave 1', 'Wave 2');
grid on;
hold off;

% Plot fast-moving object waves
subplot(2, 1, 2);
plot(t, y_fast_wave1, 'b', 'LineWidth', 1.5);
hold on;
plot(t, y_fast_wave2, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Decomposition of Fast-Moving Object Waves');
legend('Wave 1', 'Wave 2');
grid on;
hold off;
