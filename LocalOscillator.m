classdef LocalOscillator
    properties
        Name                % Name of the VCO
        FrequencyRange      % Operating frequency range (in GHz)
        PowerOutput         % Output power (in dBm)
        PhaseNoise_10kHz    % SSB phase noise at 10 kHz offset (in dBc/Hz)
        PhaseNoise_100kHz   % SSB phase noise at 100 kHz offset (in dBc/Hz)
        TuneVoltage         % Voltage required for tuning (in volts)
        SupplyCurrent       % Supply current at +5V (in mA)
        TunePortLeakageCurrent % Leakage current at tune port (VTune = 23V) (in μA)
        OutputReturnLoss    % Output return loss (in dB)
        SecondHarmonic      % Level of the second harmonic distortion (in dBc)
        Pulling             % Frequency pulling into a 2.0:1 VSWR (in MHz peak-to-peak)
        VccPushing_20GHz    % Vcc pushing at Vtune = +20V, F = 20 GHz (in MHz/V)
        FreqDriftRate_10GHz % Frequency drift rate at 10 GHz (in MHz/°C)
        FreqDriftRate_20GHz % Frequency drift rate at 20 GHz (in MHz/°C)
    end
    
    methods
        function obj = LocalOscillator()
            % Constructor with default values
            obj.Name = 'HMC733LC4B';         % Name
            obj.FrequencyRange = [10, 20];   % GHz
            obj.PowerOutput = 3;             % dBm
            obj.PhaseNoise_10kHz = -60;      % dBc/Hz
            obj.PhaseNoise_100kHz = -90;     % dBc/Hz
            obj.TuneVoltage = [-0.25, 23];   % V
            obj.SupplyCurrent = 70;          % mA
            obj.TunePortLeakageCurrent = 25; % μA
            obj.OutputReturnLoss = 10;       % dB
            obj.SecondHarmonic = -20;        % dBc
            obj.Pulling = 15;                % MHz pp
            obj.VccPushing_20GHz = -90;      % MHz/V
            obj.FreqDriftRate_10GHz = -0.25; % MHz/°C
            obj.FreqDriftRate_20GHz = -0.80; % MHz/°C
        end
    end
end
