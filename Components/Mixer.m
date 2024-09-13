classdef Mixer
    properties
        name                   % Name of the mixer
        frequencyRange         % Operating frequency range of the mixer (in GHz)
        localOscillatorRange   % Operating frequency range of the local oscillator (in GHz)
        intermediateFrequencyRange % Operating frequency range of the intermediate frequency (in GHz)
        loDriveLevelRange      % Range of LO drive level (in dBm)
        conversionLossAt10dBm % Conversion loss at LO drive level = 10 dBm (in dB)
        conversionLossAt13dBm % Conversion loss at LO drive level = 13 dBm (in dB)
    end
    
    methods
        function obj = Mixer()
            % Constructor
            obj.name = 'XM-B1H6-0404D';
            obj.frequencyRange = [5, 12];
            obj.localOscillatorRange = [5, 12];
            obj.intermediateFrequencyRange = [0, 4];
            obj.loDriveLevelRange = [7, 10];
            obj.conversionLossAt10dBm = [9.5, 12];
            obj.conversionLossAt13dBm = [9, 13];
        end
    end
end
