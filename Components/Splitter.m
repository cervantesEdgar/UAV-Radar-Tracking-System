classdef Splitter
    properties
        name                     % Name of the splitter
        frequencyRange           % Frequency range of the splitter (in GHz)
        insertionLoss            % Insertion loss of the splitter (in dB)
        isolation                % Isolation of the splitter (in dB)
        returnLoss               % Return loss of the splitter (in dB)
        phaseUnbalance           % Phase unbalance of the splitter (in degrees)
        amplitudeUnbalance       % Amplitude unbalance of the splitter (in dB)

        usedFreq                 % Frequency used for setting properties
        usedInsertionLoss        % Used insertion loss value
        usedIsolation            % Used isolation value
        usedReturnLoss           % Used return loss value
        usedPhaseUnbalance       % Used phase unbalance value
        useAmplitudeUnbalance    % Used amplitude unbalance value
    end

    methods
        function obj = Splitter(usedFreq)
            % Constructor
            obj.name = 'XM-B8U3-0404D';
            obj.usedFreq = usedFreq;
            obj.frequencyRange = {[2, 5], [5, 10], [10, 18], [18, 26.5]}; % Frequency range (in GHz)
            obj.insertionLoss = {[0.65, 0.75], [1.05, 1.40], [1.55, 2.70], [3.25, 6.30]}; % Insertion loss (in dB)
            obj.isolation = {[20, 20], [16, 19], [15, 21], [16, 23]}; % Isolation (in dB)
            obj.returnLoss = {[22, 22], [24, 24], [16, 16], [11, 11]}; % Return loss (in dB)
            obj.phaseUnbalance = {[0.40, 0.80], [0.15, 0.50], [0.50, 0.70], [2.25, 3.95]}; % Phase unbalance (in degrees)
            obj.amplitudeUnbalance = {[0, 0], [0.10, 0.15], [0.05, 0.15], [0.40, 1.05]}; % Amplitude unbalance (in dB)
            obj = setUsedProperties(obj);
        end

        function obj = setUsedProperties(obj)
            % Display the used frequency
            disp(['Used frequency: ' num2str(obj.usedFreq)]);

            % Check if the frequency is out of bounds
            if obj.usedFreq < obj.frequencyRange{1}(1)
                error('Frequency is too small.');
            elseif obj.usedFreq > obj.frequencyRange{end}(2)
                error('Frequency is too large.');
            end

            % Find the index corresponding to the used frequency
            freqRanges = cellfun(@(x) x(1), obj.frequencyRange);
            idx = find(obj.usedFreq >= freqRanges, 1, 'last');
            if isempty(idx)
                idx = 1;
            end
            disp(['Index found: ' num2str(idx)]);

            % Set used properties based on the index
            % Randomly choose a value within the specified range for each property
            obj.usedInsertionLoss = rand(1) * (obj.insertionLoss{idx}(2) - obj.insertionLoss{idx}(1)) + obj.insertionLoss{idx}(1);
            obj.usedIsolation = rand(1) * (obj.isolation{idx}(2) - obj.isolation{idx}(1)) + obj.isolation{idx}(1);
            obj.usedReturnLoss = rand(1) * (obj.returnLoss{idx}(2) - obj.returnLoss{idx}(1)) + obj.returnLoss{idx}(1);
            obj.usedPhaseUnbalance = rand(1) * (obj.phaseUnbalance{idx}(2) - obj.phaseUnbalance{idx}(1)) + obj.phaseUnbalance{idx}(1);
            obj.useAmplitudeUnbalance = rand(1) * (obj.amplitudeUnbalance{idx}(2) - obj.amplitudeUnbalance{idx}(1)) + obj.amplitudeUnbalance{idx}(1);
        end

        function powerSplitRatio = calculatePowerSplit(obj, numOutputs, desiredPowerDivision)
            % Calculate power split ratio for each output port
            % numOutputs: Number of output ports
            % desiredPowerDivision: Desired power division among output ports
            totalPower = sum(desiredPowerDivision);
            powerSplitRatio = desiredPowerDivision ./ totalPower;
        end

        function plotFrequencyResponse(obj)
            % Define frequency points for evaluation
            frequencies = linspace(obj.frequencyRange{1}(1), obj.frequencyRange{end}(2), 100);

            % Initialize arrays to store insertion loss and return loss values
            insertionLossValues = zeros(size(frequencies));
            returnLossValues = zeros(size(frequencies));

            % Use saved insertion loss and return loss values at each frequency point
            for i = 1:numel(frequencies)
                insertionLossValues(i) = obj.usedInsertionLoss;
                returnLossValues(i) = obj.usedReturnLoss;
            end

            % Plot the frequency response
            figure;
            subplot(2, 1, 1);
            plot(frequencies, insertionLossValues);
            xlabel('Frequency (GHz)');
            ylabel('Insertion Loss (dB)');
            title('Frequency Response - Insertion Loss');

            subplot(2, 1, 2);
            plot(frequencies, returnLossValues);
            xlabel('Frequency (GHz)');
            ylabel('Return Loss (dB)');
            title('Frequency Response - Return Loss');
        end
        function splitWaveform = splitWaveform(obj, inputWaveform, numOutputs, powerSplitRatio)
            % Split the input waveform based on specified parameters
            % inputWaveform: Input waveform from the local oscillator (VCO)
            % numOutputs: Number of output ports
            % powerSplitRatio: Power split ratio for each output port

            % Check if the number of output ports matches the length of power split ratio
            if numel(powerSplitRatio) ~= numOutputs
                error('Number of power split ratios must match the number of output ports.');
            end

            % Normalize power split ratio to ensure it sums to 1
            powerSplitRatio = powerSplitRatio / sum(powerSplitRatio);

            % Split the input waveform based on power split ratio
            splitWaveform = cell(1, numOutputs);
            for i = 1:numOutputs
                splitWaveform{i} = inputWaveform * sqrt(powerSplitRatio(i));
            end
        end
    end
end
