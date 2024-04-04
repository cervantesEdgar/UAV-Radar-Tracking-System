classdef USRPN210
    properties
        % Properties for the original waveform parameters
        originalCarrierFrequency % The carrier frequency of the original waveform in Hertz (Hz)
        originalPhase            % The phase offset of the original waveform in radians
        originalAmplitude        % The maximum amplitude of the original waveform
        originalSamplingFrequency % The sampling frequency of the original waveform, in samples per second (Hz)
        originalDuration         % The duration of the original waveform in seconds
        
        ReceivedWaveformParameters   % Properties of the received waveform
    end
    
    methods
        function obj = USRPN210()
            % Constructor (optional)
            % Set example values for the properties
            obj.originalCarrierFrequency = 1e6;   % 1 MHz
            obj.originalPhase = 0;                % 0 radians
            obj.originalAmplitude = 1;            % Amplitude of 1
            obj.originalSamplingFrequency = 1.01e6; % 10 MS/s
            obj.originalDuration = 1e-3;          % 1 millisecond
        end
        
        function waveform = generateWaveform(obj)
            % Generate waveform using the USRP N210
            
            % Time vector
            t = linspace(0, obj.originalDuration, obj.originalSamplingFrequency * obj.originalDuration);
            
            % Generate continuous sinusoidal waveform
            waveform = obj.originalAmplitude * sin(2*pi*obj.originalCarrierFrequency*t + obj.originalPhase);
        end
        
        function receiveWaveform(obj, receivedWaveform)
            % Compare received waveform with the original generated waveform
            originalWaveform = obj.generateWaveform();
            
            % Time vector for plotting
            t = linspace(0, obj.originalDuration, numel(receivedWaveform));
            
            % Plot both waveforms
            plot(t, originalWaveform, 'b', 'LineWidth', 1.5);  % Original waveform
            hold on;
            plot(t, receivedWaveform, 'r', 'LineWidth', 1.5);  % Received waveform
            hold off;
            
            % Add labels and legend
            xlabel('Time (s)');
            ylabel('Amplitude');
            title('Original and Received Waveforms');
            legend('Original', 'Received');
        end
    end
end
