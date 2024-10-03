classdef SignalProcessing
    methods (Static)
        function processSignal(transmittedSignal, samplingRate)
            % Method to process and plot the transmitted signal
            % Create a time vector
            t = (0:length(transmittedSignal)-1) / samplingRate;

            % Create a 3x2 figure layout for the plots
            figure('Name', 'Signal Processing and RTI Plots');

            % ------------------ Column 1: Time Domain, Spectrogram, FFT ------------------ %

            % Plot the transmitted signal (original)
            subplot(3, 2, 1);
            plot(t, transmittedSignal);
            xlabel('Time (s)');
            ylabel('Amplitude');
            title('Transmitted Signal');
            grid on;

            % Plot the spectrogram (original)
            subplot(3, 2, 3);
            spectrogram(transmittedSignal, 256, 250, 256, samplingRate, 'yaxis');
            title('Spectrogram of the Transmitted Signal');

            % Perform the FFT (original)
            fftSignal = fft(transmittedSignal);
            N = length(fftSignal);  % Length of the signal

            % Frequency axis for FFT (not shifted by center frequency)
            freq = (-N/2:N/2-1) * (samplingRate / N);  % Frequency axis in Hz

            % Shift the FFT to center zero frequency
            fftShifted = fftshift(fftSignal);

            % Create a plot for the magnitude of the FFT
            subplot(3, 2, 5);
            plot(freq / 1e9, abs(fftShifted));  % Convert frequency to GHz for plotting
            xlabel('Frequency (GHz)');
            ylabel('Magnitude');
            title('FFT of the Transmitted Signal');
            grid on;

            % ------------------ Column 2: RTI Plots (Without and With Clutter Rejection) ------------------ %

            % RTI plot without clutter rejection
            subplot(3, 2, 2);
            rtiDataWithoutClutter = SignalProcessing.generateRTI(transmittedSignal, samplingRate, false);  % No clutter rejection
            imagesc(rtiDataWithoutClutter);
            title('RTI Without Clutter Rejection');
            xlabel('Time');
            ylabel('Range');
            colorbar;

            % RTI plot with clutter rejection
            subplot(3, 2, 4);
            rtiDataWithClutter = SignalProcessing.generateRTI(transmittedSignal, samplingRate, true);  % With clutter rejection
            imagesc(rtiDataWithClutter);
            title('RTI With Clutter Rejection');
            xlabel('Time');
            ylabel('Range');
            colorbar;

            % Calculate and display the center frequency and power
            [centerFrequency, powerDBm] = SignalProcessing.getSignalCharacteristics('Processed Signal', transmittedSignal, samplingRate);
            disp(['Center Frequency: ', num2str(centerFrequency), ' Hz']);
            disp(['Signal Power: ', num2str(powerDBm), ' dBm']);
        end

        function [centerFrequency, powerDBm] = getSignalCharacteristics(signalName, signal, samplingRate)
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

        function rtiData = generateRTI(signal, fs, applyClutterRejection)
            % Generate RTI plot data based on the transmitted signal
            % Parameters:
            %   - signal: transmitted or received radar signal
            %   - fs: sampling rate (Hz)
            %   - applyClutterRejection: boolean to apply clutter rejection

            % Parameters for range processing
            c = 3e8;  % Speed of light in m/s
            pulseWidth = 1e-6;  % Pulse width in seconds (example value)
            rangeResolution = c / (2 * fs);  % Range resolution (meters)
            numPulses = 100;  % Number of pulses (example value)
            numSamplesPerPulse = length(signal) / numPulses;

            % Reshape the signal into a matrix (pulses x samples)
            signalMatrix = reshape(signal, numSamplesPerPulse, numPulses);

            % If clutter rejection is enabled, apply a high-pass filter
            if applyClutterRejection
                signalMatrix = signalMatrix - mean(signalMatrix, 2);  % Subtract the mean (simple clutter rejection)
            end

            % Compute the RTI data (power of the signal in dB)
            rtiData = 20 * log10(abs(signalMatrix));

            % Note: x-axis will represent time, and y-axis will represent range.
        end
    end
end
