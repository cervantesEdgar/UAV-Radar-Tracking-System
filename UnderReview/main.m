clear,close,clc
% Define radar parameters
radarParams = Radar();

% Generate the transmitted signal
transmittedSignal = radarParams.transmitSignal();

% Process and plot the transmitted signal
SignalProcessing.processSignal(transmittedSignal, radarParams.samplingRate);

%COPY OF REPO

