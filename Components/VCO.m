classdef VCO 

    properties 
        startFreq %Start frequency of linear ramp modulated VCO
        chirp_rate % radar chirp rate
        time %duration
    end

    methods
        function obj = VCO()
            obj.startFreq = 1e6; %initalize starting frequency from input
            obj.chirp_rate = 1e-3; %set the chirp rate
            obj.time = linspace(0, 75, 1000); % set time vector
        end
        function VCO_signal= createSignal(obj)
            %find frequency
            freq= obj.startFreq + obj.chirp_rate*obj.time;
            % plug values into equation for FMCW radar that uses linearly
            % modulated VCO Tx(t)= cos(2pi*t*freq)
            VCO_signal= cos(2*pi*obj.time.*freq);
        end
    end
end