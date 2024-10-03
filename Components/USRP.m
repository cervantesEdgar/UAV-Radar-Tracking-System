classdef USRP
    %USRP N210

    properties
        frequency = 4.4e9;         % Center frequency 1 GHz
        bandwidth = 25e6;          % Bandwidth 25 MHz
        sweepTime = 1e-3;          % Sweep time 1 ms
        transmitPower = 1;         % Transmit power in watts (example value)
        antennaGain = 30;          % Antenna gain in dB (example value)
        %samplingRate = 25e6;       % Sampling rate 25 MHz
        samplingRate = 9e9
        systemTemperature = 290;   % System temperature in Kelvin
        noiseFigure = 3;           % Noise figure in dB (example value)
        systemLoss = 6;            % System loss in dB (example value)
        rcs = 1;                   % Radar cross-section (example value)
        numSamples = 1e6;          % Number of Samples For Time Vector
    end

    methods
        function obj = Radar(varargin)
            % Constructor to allow setting specific parameters
            for i = 1:2:length(varargin)
                switch varargin{i}
                    case 'frequency'
                        obj.frequency = varargin{i+1};
                    case 'bandwidth'
                        obj.bandwidth = varargin{i+1};
                    case 'sweepTime'
                        obj.sweepTime = varargin{i+1};
                    case 'transmitPower'
                        obj.transmitPower = varargin{i+1};
                    case 'antennaGain'
                        obj.antennaGain = varargin{i+1};
                    case 'samplingRate'
                        obj.samplingRate = varargin{i+1};
                    case 'systemTemperature'
                        obj.systemTemperature = varargin{i+1};
                    case 'noiseFigure'
                        obj.noiseFigure = varargin{i+1};
                    case 'systemLoss'
                        obj.systemLoss = varargin{i+1};
                    case 'rcs'
                        obj.rcs = varargin{i+1};
                end
            end
        end

        function USRPGeneratedSignal = GenerateSignal(obj,t)
            % Generate FMCW radar signal with up-sweep and reset (no down-sweep)

            %t = (0:obj.numSamples-1) / obj.samplingRate;        % Time vector
            %Time Step 1/25e6 = 40ns
            %Total Duration: 0.04 seconds (40 ms)
            samplesPerSweep = obj.samplingRate * obj.sweepTime;  % Samples per sweep
            numSweeps = floor(length(t) / samplesPerSweep);      % Number of complete sweeps
            totalSamples = numSweeps * samplesPerSweep;          % Total samples generated
            transmittedSignal = zeros(1, totalSamples);          % Preallocate array for efficiency

            % Generate up-sweep for each sweep cycle
            for i = 1:numSweeps
                % Calculate start and end indices for the current sweep
                startIdx = (i - 1) * samplesPerSweep + 1;
                endIdx = startIdx + samplesPerSweep - 1;

                % Generate the up-sweep (from 4.3875 GHz to 4.4125 GHz)
                currentSweep = chirp(t(startIdx:endIdx), ...
                    obj.frequency - obj.bandwidth / 2, ...    % Start at 4.3875 GHz
                    obj.sweepTime, ...
                    obj.frequency + obj.bandwidth / 2);       % End at 4.4125 GHz

                % Store the current sweep in the preallocated array
                transmittedSignal(startIdx:endIdx) = currentSweep;
            end

            % Return only the required number of samples
            USRPGeneratedSignal = transmittedSignal(1:obj.numSamples);
        end
        function sineWave = generateSineWave(obj)
            % Generates a sine wave based on the USRP properties
            
            % Create time vector
            t = (0:obj.numSamples-1) / obj.samplingRate; % Time vector (seconds)
            
            % Generate sine wave
            sineWave = sin(2 * pi * obj.frequency * t);
        end
    end
end

