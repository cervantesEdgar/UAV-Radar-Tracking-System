classdef system_params

    properties
        CenterFrequency = 10E9;
        NoiseFigureStages;
        TotalNoiseRatio = 1.2;
        RCS_dB = -20; % dB
        Attenuation = 0;
        SpeedOfLight = 3E8;
        K = 1.38E-23; % (J/K) Boltzmann's constant
        To = 290; % (K) standard temperature
        Bandwidth;
        Pavg;
    end

    methods
        function obj = system_params(vargin)
            %SYSTEM_PARAMS Can be overwritten through vargin
            %Ex. vargin = ['CenterFrequency',10e9]
            for i = 1:2:length(vargin)
                switch vargin{i}
                    case 'CenterFrequency'
                        obj.CenterFrequency = vargin{i+1};
                    case 'TotalNoiseRatio'
                        obj.TotalNoiseRatio = vargin{i+1};
                    case 'RCSdB'
                        obj.RCS_dB = vargin{i+1};
                    case 'Attenuation'
                        obj.Attenuation = vargin{i+1};
                    case 'SpeedOfLight'
                        obj.SpeedOfLight = vargin{i+1};
                    case 'K'
                        obj.K = vargin{i+1};
                    case 'To'
                        obj.To = vargin{i+1};
                    case 'Bandwidth'
                        obj.Bandwidth = vargin{i+1};
                    case 'Pavg'
                        obj.Pavg = vargin{i+1};
                    otherwise
                        error('Unknown parameter: %s', vargin{i});
                end
            end
            obj.NoiseFigureStages = [];
        end
        function obj = AddToNoiseFigureStages(obj, componentNoiseFigure_linear, componentGain_linear)
            % Add a new component's noise figure and gain to the stages
            % componentNoiseFigure: Noise figure of the component in linear terms
            % componentGain: Gain of the component in linear terms

            % Create a new row with the component's noise figure and gain
            newStage = [componentNoiseFigure_linear, componentGain_linear];

            % Append the new stage to the existing NoiseFigureStages
            obj.NoiseFigureStages = [obj.NoiseFigureStages; newStage];
            % Display the added noise figure and gain
            disp(['Noise figure added: ', num2str(componentNoiseFigure_linear), ' (linear value)']);
            disp(['Component gain added: ', num2str(componentGain_linear), ' (linear value)']);
            disp('----------------------------------------');
        end
        function noiseFigure_linear = calculateTotalNoiseFigure(obj)
            % stages is an Nx2 matrix where each row is [NF, G]
            % NF is in linear terms, G is in linear terms
            % Example:
            % stages = [
            % 5, 100;  NF1 = 5, G1 = 100
            % 10, 31.62  NF2 = 10, G2 = 31.62
            % ];

            % Check if there are any stages to process
            if isempty(obj.NoiseFigureStages)
                error('No noise figure stages to calculate.');
            end

            % Initialize total noise figure calculation
            noiseFigure = obj.NoiseFigureStages(1, 1); % NF of the first stage
            disp(['Starting with first stage: NF = ', num2str(noiseFigure), ' (linear), G = ', num2str(obj.NoiseFigureStages(1, 2))]);

            % Iterate over the remaining stages
            for i = 2:size(obj.NoiseFigureStages, 1)
                NF_i = obj.NoiseFigureStages(i, 1);
                G_prev = prod(obj.NoiseFigureStages(1:i-1, 2)); % Product of gains of all previous stages

                % Apply the Friis formula for noise figure
                noiseFigure = noiseFigure + (NF_i - 1) / G_prev;

                % Display feedback for each stage
                disp(['Stage ', num2str(i), ': NF = ', num2str(NF_i), ' (linear), G = ', num2str(obj.NoiseFigureStages(i, 2))]);
                disp(['Cumulative noise figure after stage ', num2str(i), ': ', num2str(noiseFigure)]);
            end

            noiseFigure_linear = noiseFigure; % Assign the final calculated noise figure
            disp(['Total noise figure (linear): ', num2str(noiseFigure_linear)]);
        end

        function Rmax = calculateRMax(obj, transmitGain, receivingGain)

            lambda_c = obj.SpeedOfLight/obj.CenterFrequency; %Transmitted Signal, might be different than fc

            % Antenna gains in linear scale
            Gtx_dB = transmitGain; % (dBi) measured gain of transmit antenna
            Gtx = 10^(Gtx_dB/10); % convert to linear
            Grx_dB = receivingGain; % (dBi) measured gain of receive antenna
            Grx = 10^(Grx_dB/10); % convert to linear

            % Effective aperture of the receive antenna
            Arx = Grx * lambda_c^2 / (4 * pi); % assume rho_rx = 1

            RCS = 10^(obj.RCS_dB/10); % Sigma

            % Miscellaneous system losses
            Ls_dB = 6; % (dB)
            Ls = 10^(Ls_dB/10); % convert to linear

            % Noise figure
            Fn_dB = calculateTotalNoiseFigure(); % (dB)
            Fn = 10^(Fn_dB/10); % convert to linear

            % System noise bandwidth [NOT COMPLETE]
            t_sample = 10E-3; % (s) discrete sample length
            Bn = 2 / t_sample; % (Hz) system noise bandwidth

            % Required SNR for detection [NOT COMPLETE]
            SNR1_dB = 13.4; % (dB) required SNR
            SNR1 = 10^(SNR1_dB/10); % convert to linear


            Rmax = ((obj.Pavg * Gtx * Arx * RCS) / ((4 * pi)^2 * obj.K * obj.To * Fn * Bn * SNR1 * Ls))^(1/4);
        end
    end
end

