% Config/component_specs.m
% Component specifications for the FMCW radar simulation

% Transmitter specifications
TransmitterAntennaSpecs = struct( ...
    'Frequency', 10e9, ...             % Operating frequency in Hz (X-band)
    'Power', 1, ...                    % Transmit power in Watts
    'Bandwidth', 200e6, ...            % Bandwidth of the chirp signal in Hz
    'ChirpDuration', 1e-3, ...         % Duration of the chirp signal in seconds (1 ms)
    'AntennaGain', 30 ...              % Gain of the transmitting antenna in dB
);

% Receiver specifications
ReceiverAntennaSpecs = struct( ...
    'NoiseFigure', 3, ...              % Noise figure of the receiver in dB
    'AntennaGain', 30, ...             % Gain of the receiving antenna in dB
    'Bandwidth', 200e6, ...            % Receiver bandwidth in Hz (matches the chirp bandwidth)
    'Sensitivity', -100 ...            % Receiver sensitivity in dBm
);

% Antenna specifications
AntennaSpecs = struct( ...
    'Gain', 30, ...                    % Antenna gain in dB
    'Beamwidth', 10, ...               % Antenna beamwidth in degrees
    'Polarization', 'linear' ...       % Antenna polarization (e.g., linear, circular)
);

% Mixer specifications
MixerSpecs = struct( ...
    'ConversionLoss', 5 ...            % Conversion loss of the mixer in dB
);

% Amplifier specifications
AmplifierSpecs = struct( ...
    'Gain', 20, ...                    % Gain of the amplifier in dB
    'NoiseFigure', 3 ...               % Noise figure of the amplifier in dB
);

% Signal processor specifications
SignalProcessorSpecs = struct( ...
    'FFTLength', 1024, ...             % Length of the FFT for range processing
    'WindowFunction', 'hann' ...       % Windowing function to reduce spectral leakage
);

% You can add other components such as filters, delay lines, etc.
