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
            obj.originalCarrierFrequency = 1e9;   % 1 HHz
            obj.originalPhase = 0;                % 0 radians
            obj.originalAmplitude = 1;            % Amplitude of 1 
            obj.originalSamplingFrequency = 25e6; % 10 MS/s
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
            s = receivedWaveform;
            t = (0:length(s)-1)/fs; % assuming fs is defined somewhere
        
            % Create a single figure
            figure
        
            % Plot 1: Time Domain Plot
            subplot(3,2,1)
            plot(t,s)
            xlabel('Time (seconds)');
            ylabel('Amplitude');
            title('Time Domain Plot')
        
            % Plot 2: Signal After Windowing
            s_windowed = s.*hamming(length(s))';
            subplot(3,2,2)
            plot(s_windowed)
            xlabel('Samples');
            ylabel('Amplitude');
            title('Signal After Windowing')
        
            % Plot 3: Signal After Zero Padding
            s_padded = [s_windowed zeros(1,2000)];
            subplot(3,2,3)
            plot(s_padded);
            xlabel('Samples');
            ylabel('Amplitude');
            title('Signal After Zero Padding')
        
            % Plot 4: Frequency Domain Plot
            S = fft(s_padded);
            subplot(3,2,4)
            plot(abs(S))
            xlabel('Samples');
            ylabel('Magnitude');
            title('Frequency Domain Plot')
        
            % Plot 5: Frequency Domain Plot (Zoomed)
            S_OneSide = S(1:length(S)/2);
            f = fs*(0:length(S)/2-1)/length(S);
            S_meg = abs(S_OneSide)/(length(s)/4);
            subplot(3,2,[5,6])
            plot(f,S_meg)
            xlabel('Frequency (Hz)');
            ylabel('Amplitude');
            title('Frequency Domain Plot (Zoomed)')
        end

    end
end
