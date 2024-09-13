classdef Target
    properties
        distance % Distance of the target from the radar
        velocity % Velocity of the target
        rcs
    end
    
    methods
        function obj = Target(distance, velocity)
            % Constructor
            obj.distance = distance;
            obj.velocity = velocity;
            obj.rcs = rcs;
            %Add extra properties
        end
    end
end
