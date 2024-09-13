classdef TransmittingAntenna
    properties
        antennaType           % Type of the antenna
        gain                  % Gain of the antenna (in dB)
        frequencyResponse     % Frequency response of the antenna
        polarization          % Polarization of the antenna
        beamwidth             % Beamwidth of the antenna (in degrees)
        % Additional properties
        frequencyRange        % Operating frequency range (in GHz)
        powerOutput           % Output power (in dBm)
        phaseNoise_10kHz      % SSB phase noise at 10 kHz offset (in dBc/Hz)
        phaseNoise_100kHz     % SSB phase noise at 100 kHz offset (in dBc/Hz)
        tuneVoltage           % Voltage required for tuning (in volts)
        supplyCurrent         % Supply current at Vcc = +5V (in mA)
        tunePortLeakageCurrent % Leakage current at tune port (Vtune = +23V) (in μA)
        outputReturnLoss      % Output return loss (in dB)
        secondHarmonic        % Level of the second harmonic distortion (in dBc)
        pulling               % Frequency pulling into a 2.0:1 VSWR (in MHz peak-to-peak)
        vccPushing_20GHz      % Vcc pushing at Vtune = +20V, F = 20 GHz (in MHz/V)
        freqDriftRate_10GHz   % Frequency drift rate at 10 GHz (in MHz/°C)
        freqDriftRate_20GHz   % Frequency drift rate at 20 GHz (in MHz/°C)
    end
    
    methods
        function obj = TransmittingAntenna(antennaType, gain, frequencyResponse, polarization, beamwidth, ...
                                            frequencyRange, powerOutput, phaseNoise_10kHz, phaseNoise_100kHz, ...
                                            tuneVoltage, supplyCurrent, tunePortLeakageCurrent, outputReturnLoss, ...
                                            secondHarmonic, pulling, vccPushing_20GHz, freqDriftRate_10GHz, freqDriftRate_20GHz)
            % Constructor
            obj.antennaType = antennaType;
            obj.gain = gain;
            obj.frequencyResponse = frequencyResponse;
            obj.polarization = polarization;
            obj.beamwidth = beamwidth;
            % Additional properties
            obj.frequencyRange = frequencyRange;
            obj.powerOutput = powerOutput;
            obj.phaseNoise_10kHz = phaseNoise_10kHz;
            obj.phaseNoise_100kHz = phaseNoise_100kHz;
            obj.tuneVoltage = tuneVoltage;
            obj.supplyCurrent = supplyCurrent;
            obj.tunePortLeakageCurrent = tunePortLeakageCurrent;
            obj.outputReturnLoss = outputReturnLoss;
            obj.secondHarmonic = secondHarmonic;
            obj.pulling = pulling;
            obj.vccPushing_20GHz = vccPushing_20GHz;
            obj.freqDriftRate_10GHz = freqDriftRate_10GHz;
            obj.freqDriftRate_20GHz = freqDriftRate_20GHz;
        end
        
        function transmitSignal(obj, signal)
            fprintf('Signal transmitted using %s antenna\n', obj.antennaType);
            % Must add code to actually simulate
        end
    end
end
