classdef SignalProcessing
    methods (Static)
        function processSignal(transmittedSignal, samplingRate)
            % Method to process and plot the transmitted signal
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

            % Calculate and display the center frequency and power
            [centerFrequency, powerDBm] = SignalProcessing.getSignalCharacteristics(transmittedSignal, samplingRate);
            disp(['Center Frequency: ', num2str(centerFrequency), ' Hz']);
            disp(['Signal Power: ', num2str(powerDBm), ' dBm']);

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
            xlabel('Frequency (GHz)');
            ylabel('Magnitude');
            title('FFT of the Transmitted Signal');
            grid on;
        end

        function [centerFrequency, powerDBm] = getSignalCharacteristics(signalName,signal, samplingRate)
            % Calculate the power of the signal
            power = mean(signal.^2);  % Mean square of the signal
            powerDBm = 10 * log10(power * 1000);  % Convert to dBm

            % Calculate the FFT of the signal to find the frequency components
            fftSignal = fft(signal);
            N = length(fftSignal);
            f = (0:N-1) * (samplingRate / N);  % Frequency vector

            % Get the magnitude of the FFT
            magnitude = abs(fftSignal);
            [~, maxIndex] = max(magnitude);  % Find index of the maximum magnitude
            centerFrequency = f(maxIndex);  % Center frequency (Hz)

            % Display the center frequency and power
            disp(['Signal: ', signalName]);
            disp(['Center Frequency: ', num2str(centerFrequency), ' Hz']);
            disp(['Signal Power: ', num2str(powerDBm), ' dBm']);
            disp(['']);
        end

        function [range, velocity] = processReceivedSignal(receivedSignal)
            % Method to process the received signal to extract range and velocity
            % This can include matched filtering, range-Doppler processing, etc.
            % Implementation details would depend on the radar system's specifics.
        end
    end
end
