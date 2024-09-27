classdef Amplify

    properties
        gain1 %gain of amplifier
    end
    methods 
        function obj = Amplify(gain2)
            %Constructor to set the amplifier gain
            obj.gain1 = gain2;
    end

    function amplifiedSignal = amp(obj, inputSignal)
        %Convert gain from dB to linear scale (in power)
        linearGain= 10^(obj.gain1 / 10);
        %Amplify the input signal
        amplifiedSignal = linearGain * inputSignal;
    end 
  end
end
