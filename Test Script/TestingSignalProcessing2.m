%% Range-Speed Response Pattern of Moving Target
% This example shows how to visualize the speed and range of a moving
% target in a pulsed radar system that uses a rectangular waveform.
%%
% Place an isotropic antenna element at the global origin
% _(0,0,0)_. Then, place a moving target with a nonfluctuating
% RCS of 5 square meters at an initial position of _(500,500,10)_.
% The target moves along the x-axis with a velocity of 50 m/s.
% Set the operating (carrier) frequency to 10 GHz.
clear,close,clc
antenna = phased.IsotropicAntennaElement(...
    'FrequencyRange', [5e9 15e9]);
transmitter = phased.Transmitter('Gain', 20, 'InUseOutputPort', true);
fc = 10e9;
target = phased.RadarTarget('Model', 'Nonfluctuating',...
    'MeanRCS', 5, 'OperatingFrequency', fc);

txloc = [0;0;0];  % Transmitter location
tgtloc = [500;500;10];  % Initial target location
tgtvelocity = [-10; 0; 0];  % Target velocity (m/s) along x-axis

antennaplatform = phased.Platform('InitialPosition', txloc);
targetplatform = phased.Platform('InitialPosition', tgtloc, 'Velocity', tgtvelocity);

[tgtrng, tgtang] = rangeangle(targetplatform.InitialPosition,...
    antennaplatform.InitialPosition);

%%
% Create a rectangular pulse waveform 2&mu;s in duration with a PRF of
% 10 kHz. Use the radar equation to determine the peak power required to detect
% a target with an RCS of 5 square meters at the maximum unambiguous range.

waveform = phased.RectangularWaveform('PulseWidth', 2e-6,...
    'OutputFormat', 'Pulses', 'PRF', 1e4, 'NumPulses', 1);
c = physconst('LightSpeed');
maxrange = c / (2 * waveform.PRF);
SNR = npwgnthresh(1e-6, 1, 'noncoherent');
lambda = c / target.OperatingFrequency;
tau = waveform.PulseWidth;
Ts = 290;
dbterm = db2pow(SNR - 2 * transmitter.Gain);
Pt = (4 * pi)^3 * physconst('Boltzmann') * Ts / tau / target.MeanRCS / lambda^2 * maxrange^4 * dbterm;

% Set the peak transmit power
transmitter.PeakPower = Pt;

%% Create radiator, channel, collector, and receiver objects
radiator = phased.Radiator(...
    'PropagationSpeed', c,...
    'OperatingFrequency', fc, 'Sensor', antenna);
channel = phased.FreeSpace(...
    'PropagationSpeed', c,...
    'OperatingFrequency', fc, 'TwoWayPropagation', false);
collector = phased.Collector(...
    'PropagationSpeed', c,...
    'OperatingFrequency', fc, 'Sensor', antenna);
receiver = phased.ReceiverPreamp('NoiseFigure', 0,...
    'EnableInputPort', true, 'SeedSource', 'Property', 'Seed', 2e3);

%% Simulate 25 pulses and store the received echoes
numPulses = 25;
rx_puls = zeros(100, numPulses);

for n = 1:numPulses
    % Update the target's position based on its velocity
    [tgtloc, tgtvel] = targetplatform(1/waveform.PRF);  % Update position for each pulse
    
    % Generate waveform
    wf = waveform();
    
    % Transmit waveform
    [wf, txstatus] = transmitter(wf);
    
    % Radiate pulse toward the target
    wf = radiator(wf, tgtang);
    
    % Propagate pulse toward the moving target
    wf = channel(wf, txloc, tgtloc, [0;0;0], [0;0;0]);
    
    % Reflect it off the moving target
    wf = target(wf);
    
    % Propagate the pulse back to the transmitter
    wf = channel(wf, tgtloc, txloc, [0;0;0], [0;0;0]);
    
    % Collect the echo
    wf = collector(wf, tgtang);
    
    % Receive the target echo
    rx_puls(:,n) = receiver(wf, ~txstatus);
end

%% Create a range-Doppler response object to visualize the target's range and speed
rangedoppler = phased.RangeDopplerResponse(...
    'RangeMethod', 'Matched Filter',...
    'PropagationSpeed', c,...
    'DopplerOutput', 'Speed', 'OperatingFrequency', fc);
plotResponse(rangedoppler, rx_puls, getMatchedFilter(waveform))
