classdef SignalProcessing
    methods (Static)
        function processSignal(transmittedSignal, samplingRate, centerFrequency)
            % Method to process and plot the transmitted signal
            %clc, close;

            % Create a time vector
            t = (0:length(transmittedSignal)-1) / samplingRate;

            % Plot the transmitted signal
            figure('Name', 'Signal Processing');
            subplot(3, 1, 1);
            plot(t, transmittedSignal);
            xlabel('Time (s)');
            ylabel('Amplitude');
            title('Transmitted Signal');
            grid on;

            % Plot the spectrogram
            subplot(3, 1, 2);
            spectrogram(transmittedSignal, 256, 250, 256, samplingRate, 'yaxis');
            title('Spectrogram of the Transmitted Signal');
            %ylabel('Frequency (GHz)');

            %ylim([4.3875e9 4.4125e9]);  % Set y-axis limits to actual frequency range

            % Perform the FFT
            fftSignal = fft(transmittedSignal);

            % Frequency axis
            N = length(fftSignal);  % Length of the signal
            freq = (-N/2:N/2-1) * (samplingRate / N) + centerFrequency;  % Shift by center frequency

            % Shift the FFT to center zero frequency
            fftShifted = fftshift(fftSignal);

            % Create a plot
            subplot(3, 1, 3);
            plot(freq/1e9, abs(fftShifted));  % Convert frequency to GHz for plotting

            % Adjust the axes and labels
            %xlim([4.3875 4.4125]);  % Set x-axis limits to GHz
            xlabel('Frequency (GHz)');
            ylabel('Magnitude');
            title('FFT of the Transmitted Signal');
            grid on;
        end


        function [range, velocity] = processReceivedSignal(receivedSignal)
            % Method to process the received signal to extract range and velocity
            % This can include matched filtering, range-Doppler processing, etc.
            % Implementation details would depend on the radar system's specifics.
        end
    end
end
