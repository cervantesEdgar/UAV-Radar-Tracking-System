classdef Target
    properties
        Range                % Distance from the radar to the target (in meters)
    end
    
    methods
        % Constructor
        function obj = Target()
            obj.Range = 500;  % Example value: 500 meters
        end
    end
end
