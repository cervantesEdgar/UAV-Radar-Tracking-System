clear,close,clc
% Define radar parameters
radarParams = Radar('frequency', 1e9, 'bandwidth', 25e6, 'sweepTime', 1e-3, 'samplingRate', 25e6);

% Generate the transmitted signal
transmittedSignal = radarParams.transmitSignal();

% Process and plot the transmitted signal
SignalProcessing.processSignal(transmittedSignal, radarParams.samplingRate);
