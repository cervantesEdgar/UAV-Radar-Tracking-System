classdef Splitter
    properties
        frequencyRange   % Frequency range of the splitter (in GHz)
        insertionLoss    % Insertion loss of the splitter (in dB)
        isolation        % Isolation of the splitter (in dB)
        returnLoss       % Return loss of the splitter (in dB)
        phaseUnbalance   % Phase unbalance of the splitter (in degrees)
        amplitudeUnbalance % Amplitude unbalance of the splitter (in dB)
    end
    
    methods
        function obj = Splitter()
            % Constructor
            obj.frequencyRange = {[2, 5], [5, 10], [10, 18], [18, 26.5]}; % Frequency range (in GHz)
            obj.insertionLoss = {[0.65, 0.75], [1.05, 1.40], [1.55, 2.70], [3.25, 6.30]}; % Insertion loss (in dB)
            obj.isolation = {[20, 20], [16, 19], [15, 21], [16, 23]}; % Isolation (in dB)
            obj.returnLoss = {[22, 22], [24, 24], [16, 16], [11, 11]}; % Return loss (in dB)
            obj.phaseUnbalance = {[0.40, 0.80], [0.15, 0.50], [0.50, 0.70], [2.25, 3.95]}; % Phase unbalance (in degrees)
            obj.amplitudeUnbalance = {[0, 0], [0.10, 0.15], [0.05, 0.15], [0.40, 1.05]}; % Amplitude unbalance (in dB)
        end
    end
end
