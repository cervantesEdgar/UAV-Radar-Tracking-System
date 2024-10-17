classdef VCO

    properties
        startFreq %Start frequency of linear ramp modulated VCO
        chirp_rate % radar chirp rate
        time %duration
        FreqSamp; %sampling freq
    end

    methods
        function obj = VCO()
            obj.startFreq =7.6e6; % 7.6Mghz initalize starting frequency from input
            obj.chirp_rate = 1e-3; %set the chirp rate
            obj.time = linspace(0, 50, 1000); % set time vector
            obj.FreqSamp = 1/(obj.time(2)-obj.time(1));
        end
        function VCO_signal= createSignal(obj)
            %find frequency
            freq= obj.startFreq + obj.chirp_rate*obj.time;
            % plug values into equation for FMCW radar that uses linearly
            % modulated VCO Tx(t)= cos(2pi*t*freq)
            VCO_signal= cos(2*pi*obj.time.*freq);
        end
            function plotVCO(obj)
                VCO_signal = obj.createSignal();
                len= length(obj.time);
                fft_signal= fft(VCO_signal);

                % Two side spectrum
                % spectrum containing bothe positive and negatives freq
                SP2= abs(fft_signal / len); 
                %select first half of FFT (positive side)
                SP1= SP2(1:len/2+1); 
                % double the amplitude 
                SP1(2:end-1) = 2 * SP1(2:end-1);

                %freq axis
                f= obj.FreqSamp * (0:(len/2))/len;

                %plot fft
                figure;
                plot(f,SP1);
                title('FFT Signal');
                xlabel('Freq (MHz)');
                ylabel('Amplitude');
                grid on;

                figure;
                plot(obj.time, VCO_signal);
                title('VCO Signal');
                xlabel('Time (s)');
                ylabel('Amplitude');
                grid on;
            end
        end
end
