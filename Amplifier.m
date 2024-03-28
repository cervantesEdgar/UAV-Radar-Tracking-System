classdef Amplifier
    properties
        gain % Amplification factor
    end
    
    methods
        function obj = Amplifier(g)
            % Constructor
            obj.gain = g;
        end
        
        function amplifiedSignal = amplify(obj, signal)
            % Amplify input signal
            amplifiedSignal = obj.gain * signal;
        end
    end
end
