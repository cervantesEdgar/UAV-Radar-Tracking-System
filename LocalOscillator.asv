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
        FreqDriftRate % Frequency drift rate at 10 GHz (in MHz/°C)
        FreqInput
    end

    methods
        function obj = LocalOscillator(freqInput)
            % Constructor with default values
            obj.Name = 'HMC587LC4B';         % Name
            obj.FrequencyRange = [5, 10];    % GHz
            obj.FreqInput = freqInput;
            obj.PowerOutput = 3;             % dBm
            obj.PhaseNoise_10kHz = -65;      % dBc/Hz
            obj.PhaseNoise_100kHz = -95;     % dBc/Hz
            obj.TuneVoltage = [0, 18];       % V
            obj.SupplyCurrent = [40,75];     % mA
            obj.TunePortLeakageCurrent = 10; % μA
            obj.OutputReturnLoss = 7;       % dB
            obj.SecondHarmonic = -15;        % dBc
            obj.Pulling = 4;                % MHz pp
            obj.VccPushing_20GHz = -15;      % MHz/V
            obj.FreqDriftRate = 0.8; % MHz/°C

            obj.checkFrequency();
        end
        function checkFrequency(obj)
            if obj.FreqInput < obj.FrequencyRange(1)
                error('The frequency is too low.');
            elseif obj.FreqInput > obj.FrequencyRange(2)
                error('The frequency is too high.');
            end
        end
        function waveform = createWaveform(obj)
            t = linspace(0, 1, 1000); % Time vector from 0 to 1 second with 1000 samples
            waveform = sin(2*pi*obj.FreqInput*t); % Sinusoidal waveform with frequency of 10 MHz
        end
    end
end
