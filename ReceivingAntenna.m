classdef ReceivingAntenna
    properties
        antennaType
        gain
        frequencyResponse
        polarization
        beamwidth
        % Add other properties
    end
    
    methods
        function obj = ReceivingAntenna(antennaType, gain, frequencyResponse, polarization, beamwidth)
            % Constructor
            obj.antennaType = antennaType;
            obj.gain = gain;
            obj.frequencyResponse = frequencyResponse;
            obj.polarization = polarization;
            obj.beamwidth = beamwidth;
        end
        
        function receivedSignal = receiveSignal(obj)

            fprintf('Signal received using %s antenna\n', obj.antennaType);
            
            receivedSignal = randn(1, 100); 
        end
    end
end
