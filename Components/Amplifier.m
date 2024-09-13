classdef Amplifier
    properties
        name                % Name or model number of the amplifier
        frequency           % Operating frequency (in GHz)
        gain                % Gain of the amplifier (in dB)
        noiseFigure         % Noise figure of the amplifier (in dB)
        % Add other properties as needed
    end
    properties (Constant)
        frequencyRange1 = [5, 15]; % Frequency range 1 (in GHz)
        frequencyRange2 = [15, 18]; % Frequency range 2 (in GHz)
        frequencyRange3 = [18, 20]; % Frequency range 3 (in GHz)
    end
    methods
        function obj = Amplifier(freq)
            % Constructor
            if freq < obj.frequencyRange1(1) || freq > obj.frequencyRange3(2)
                error('Frequency must be between 5 GHz and 20 GHz.');
            end
            obj.name = 'HMC451LC3';  % Predefined name
            obj.frequency = freq; % Operating frequency (in GHz)
            obj.gain = obj.calculateGain(); % Calculate gain based on frequency
            obj.noiseFigure = obj.calculateNoiseFigure(); % Calculate noise figure based on frequency
        end
        function gain = calculateGain(obj)
            % Calculate gain based on the specified frequency range
            if obj.frequency >= obj.frequencyRange1(1) && obj.frequency <= obj.frequencyRange1(2)
                gain = [16, 19]; % Gain range for frequency range 1
            elseif obj.frequency >= obj.frequencyRange2(1) && obj.frequency <= obj.frequencyRange2(2)
                gain = [15, 18]; % Gain range for frequency range 2
            else
                gain = [14, 17]; % Gain range for frequency range 3
            end
        end
        function nf = calculateNoiseFigure(obj)
            % Calculate noise figure based on the specified frequency range
            if obj.frequency >= obj.frequencyRange1(1) && obj.frequency <= obj.frequencyRange1(2)
                nf = 7; % Noise figure for frequency range 1
            elseif obj.frequency >= obj.frequencyRange2(1) && obj.frequency <= obj.frequencyRange2(2)
                nf = 6.5; % Noise figure for frequency range 2
            else
                nf = 7; % Noise figure for frequency range 3
            end
        end
        function Amplify = amplify(waveform, desiredGain)
            % Amplify the input waveform with the desired gain
            % if desiredGain < min(obj.gain) || desiredGain > max(obj.gain)
            %     error(['Desired gain must be within the specified gain range: ' num2str(obj.gain(1)) ' dB to ' num2str(obj.gain(end)) ' dB.']);
            % end
            % Implement amplification process here
            % You would apply the desired gain to the waveform
            Amplify = desiredGain * waveform;
        end


    end
end
