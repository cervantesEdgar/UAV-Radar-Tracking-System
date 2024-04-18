classdef Target
    properties
        Range                % Distance from the radar to the target (in meters)
    end
    
    methods
        % Constructor
        function obj = Target()
            obj.Range = 500;  % Example value: 500 meters
        end
        
        % Function to simulate target hit with Doppler effect
        function [dopplerShift, rangeInfo] = TargetHit(obj, radarVelocity, radarFrequency)
            % Doppler shift calculation
            speedOfLight = 3e8;  % Speed of light in meters per second
            dopplerShift = 2 * radarVelocity * (obj.Range / speedOfLight) * radarFrequency;
            
            % Information on target range
            rangeInfo = sprintf('Target range: %d meters', obj.Range);
        end
    end
end
