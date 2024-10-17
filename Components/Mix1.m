classdef Mix1
    properties
        IF;
        LO;
    end

    methods
        function obj = Mix1(IFsignal,LOsignal)
            obj.IF= IFsignal;
            obj.LO = LOsignal;
        end
        function RF = mix(obj)

            lenLO=length(obj.LO);
            lenIF=length(obj.IF);

            if lenLO > lenIF
                obj.LO = obj.LO(1:lenIF);  % Chang LO to match IF
            elseif lenIF > lenLO
                obj.IF = obj.IF(1:lenLO);  % Change IF to match LO
            end
            % both signals have A*cos(2pi8f8t) form, when multiplying you
            % get the trig form 1/2 (cos(2pi(Flo+Fid)t) +cos(2pi(Flo -
            % Fif)t)
            RF= obj.IF .* obj.LO;
        end
    end
end