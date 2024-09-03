classdef Radar
    properties
        % Radar parameters with predefined values
        frequency = 1e9;           % Center frequency 1 GHz
        bandwidth = 25e6;          % Bandwidth 25 MHz
        sweepTime = 1e-3;          % Sweep time 1 ms
        transmitPower = 1;         % Transmit power in watts (example value)
        antennaGain = 30;          % Antenna gain in dB (example value)
        samplingRate = 25e6;       % Sampling rate 25 MHz
        systemTemperature = 290;   % System temperature in Kelvin
        noiseFigure = 3;           % Noise figure in dB (example value)
        systemLoss = 6;            % System loss in dB (example value)
        rcs = 1;                   % Radar cross-section (example value)
        numSamples = 1e6;
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
        
        function transmittedSignal = transmitSignal(obj)
            t = (0:obj.numSamples-1) / obj.samplingRate;
            samplesPerSweep = obj.samplingRate * obj.sweepTime;
            numSweeps = floor(length(t) / samplesPerSweep);
            transmittedSignal = [];
            
            for i = 1:numSweeps
                if mod(i, 2) == 1
                    sweep = chirp(t(1:samplesPerSweep), obj.frequency - obj.bandwidth/2, obj.sweepTime, obj.frequency + obj.bandwidth/2);
                else
                    sweep = chirp(t(1:samplesPerSweep), obj.frequency + obj.bandwidth/2, obj.sweepTime, obj.frequency - obj.bandwidth/2);
                end
                transmittedSignal = [transmittedSignal, sweep];
            end
            
            transmittedSignal = transmittedSignal(1:obj.numSamples);
        end
        
        function receivedSignal = receiveSignal(obj, target)
            % Method to simulate the received signal after reflecting off the target
            % Implementation here (placeholder for now)
            transmittedSignal = obj.transmitSignal();
            noise = 0.1 * randn(size(transmittedSignal));
            receivedSignal = transmittedSignal + noise;
        end
        
        function Rmax = calculateMaxRange(obj)
            % Method to calculate the maximum range using the radar range equation
            lambda = Constants.c / obj.frequency; % Wavelength
            k = 1.38e-23; % Boltzmann constant (J/K)
            Rmax = ((obj.transmitPower * db2pow(obj.antennaGain)^2 * lambda^2 * obj.rcs) / ...
                   ((4 * pi)^3 * k * obj.systemTemperature * db2pow(obj.noiseFigure) * obj.bandwidth * db2pow(obj.systemLoss)))^(1/4);
        end
    end
end
