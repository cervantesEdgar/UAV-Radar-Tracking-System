% Parameters
Fs = 1e6;  % Sampling frequency (1 MHz)
T = 1e-3;  % Pulse duration (1 ms)
PRT = 1e-3;  % Pulse Repetition Time (1 ms)
numPulses = 100;  % Number of pulses
c = 3e8;  % Speed of light (m/s)

% Radar signal parameters
fc = 10e9;  % Carrier frequency (10 GHz)
BW = 25e6;  % Bandwidth (25 MHz)

% Target parameters (moving and stationary)
targetRanges = [5, 50, 100];  % Target ranges in meters
targetVelocities = [10, 0, 5]; % Target velocities in m/s (2nd target is stationary)

% Time and Range Calculation
t = (0:1/Fs:T-1/Fs);  % Time vector for one pulse
rangeMax = c * T / 2; % Max unambiguous range
rangeBins = linspace(0, rangeMax, length(t)); % Range bins

% Initialize signal matrix (range-time signal matrix)
rti_no_clutter_rejection = zeros(numPulses, length(t));
rti_with_clutter_rejection = zeros(numPulses, length(t));

% Loop over pulses to simulate moving targets
for pulseIdx = 1:numPulses
    % Initialize pulse for this time
    pulseSignal = zeros(1, length(t));
    
    % Simulate each target
    for targetIdx = 1:length(targetRanges)
        % Target range based on velocity (simple constant velocity model)
        targetRange = targetRanges(targetIdx) + targetVelocities(targetIdx) * (pulseIdx * PRT);
        
        % Round-trip delay
        delay = 2 * targetRange / c;
        
        % If the target is within the pulse duration, simulate the return
        if delay < T
            % Find the sample index for this delay
            delaySample = round(delay * Fs);
            
            % Add return signal (simulated as cosine wave)
            pulseSignal = pulseSignal + cos(2 * pi * fc * (t - delay)) .* exp(-((t - delay) / (T / 4)).^2);
        end
    end
    
    % Add clutter (stationary targets)
    clutterSignal = 0.3 * cos(2 * pi * fc * t); % Clutter with lower amplitude
    
    % Combine pulse signal and clutter
    rti_no_clutter_rejection(pulseIdx, :) = pulseSignal + clutterSignal;
    
    % Apply 2-pulse canceller for clutter rejection
    if pulseIdx > 1
        rti_with_clutter_rejection(pulseIdx, :) = rti_no_clutter_rejection(pulseIdx, :) - rti_no_clutter_rejection(pulseIdx - 1, :);
    end
end

% Plot RTI without clutter rejection
figure;
subplot(2, 1, 1);
imagesc(rangeBins, (1:numPulses) * PRT, abs(rti_no_clutter_rejection));
xlabel('Range (m)');
ylabel('Time (s)');
title('RTI Without Clutter Rejection');
colorbar;

% Plot RTI with 2-pulse canceller clutter rejection
subplot(2, 1, 2);
imagesc(rangeBins, (1:numPulses) * PRT, abs(rti_with_clutter_rejection));
xlabel('Range (m)');
ylabel('Time (s)');
title('RTI With Clutter Rejection (2-Pulse Canceller)');
colorbar;
