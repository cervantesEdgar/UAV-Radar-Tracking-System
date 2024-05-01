% Clear Everything
clc, clear, close

% Create Generator
usrp = USRPN210();  % Create model for USRP
waveform = usrp.generateWaveform();

% First Amplification
gain1 = 5;  % Initial gain level
amplifier1 = Amplifier(gain1);
amplified_waveform = amplifier1.applyGain(waveform);

% Hit Target
% This is the actual circuit simulation.
