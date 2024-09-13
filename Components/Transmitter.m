classdef Transmitter
    properties
        Frequency;          % Operating frequency (Hz)
        Power;              % Transmit power (W)
        Bandwidth;          % Bandwidth of chirp signal (Hz)
        ChirpDuration;      % Duration of the chirp signal (s)
    end
    
    methods
        function obj = Transmitter(freq, power, bw, chirpDuration)
            obj.Frequency = freq;
            obj.Power = power;
            obj.Bandwidth = bw;
            obj.ChirpDuration = chirpDuration;
        end
        
        function chirpSignal = generateChirp(obj, t)
            % Generates an FMCW chirp signal
            chirpSignal = obj.Power * cos(2 * pi * (obj.Frequency * t + (obj.Bandwidth/(2*obj.ChirpDuration)) * t.^2));
        end
    end
end
