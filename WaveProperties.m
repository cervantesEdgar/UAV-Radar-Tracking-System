classdef WaveProperties
    %WAVEPROPERTIES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        waveform

    end
    
    methods
        function obj = WaveProperties(wave)
            %WAVEPROPERTIES Construct an instance of this class
            %   Detailed explanation goes here
            obj.waveform = wave;
        end
        
    end
end

