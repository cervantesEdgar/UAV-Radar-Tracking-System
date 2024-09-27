classdef Mixer
    properties
        conversion_loss_dB % Conversion loss of the mixer in dB
    end
    
    methods
        % Constructor
        function obj = Mixer(conversion_loss_dB)
            if nargin > 0
                obj.conversion_loss_dB = conversion_loss_dB;
            else
                obj.conversion_loss_dB = 10; % Default conversion loss in dB
            end
        end
        
        % Convert dBm to watts
        function power_watts = dBm_to_watts(~, power_dBm)
            power_watts = (10^(power_dBm / 10)) / 1000;
        end
        
        % Convert watts to dBm
        function power_dBm = watts_to_dBm(~, power_watts)
            power_dBm = 10 * log10(power_watts * 1000);
        end
        
        % Upconversion (IF to RF)
        function RF_signal = upconvert(obj, IF_signal, LO_signal)
            % Mix IF signal with LO signal to upconvert
            mixed_signal = IF_signal .* LO_signal;
            % Calculate the output power after conversion loss
            IF_power_watts = mean(IF_signal.^2); % Average power of the input signal
            RF_power_watts = IF_power_watts * 10^(-obj.conversion_loss_dB / 10);
            % Recompute RF signal with adjusted power
            RF_signal = sqrt(RF_power_watts) * mixed_signal;
        end
        
        % Downconversion (RF to IF)
        function IF_signal = downconvert(obj, RF_signal, LO_signal)
            % Mix RF signal with LO signal to downconvert
            mixed_signal = RF_signal .* LO_signal;
            % Calculate the output power after conversion loss
            RF_power_watts = mean(RF_signal.^2); % Average power of the input signal
            IF_power_watts = RF_power_watts * 10^(-obj.conversion_loss_dB / 10);
            % Recompute IF signal with adjusted power
            IF_signal = sqrt(IF_power_watts) * mixed_signal;
        end
    end
end
