% Author: David Fian
% Course: ECE 492
% Title: Plotting signals of Mixer (Tx)
% Date Created: 4/30/24
% Description: The following script uses values from a specified component
%datasheet
% in order to produce the output signal, specifically for the output of a
% mixer connected to the Tx in a RF circuit. This script doesnt 100% reflect
% what the experimental signal will look like because this current version
% assumes there is no IM or other harmonics influencing the output.
% Calculating for the Rx is similar.
% Note (1)
% Input/Output of a mixer depending whether it's on the Tx or Rx side of
% circuit.
% Tx Rx
%----------- ---------
% Input: IF Input: RF
% Output: RF Output: IF
%------------------------------------------------------------------------------

% Component that this script is configured to:
% Component type: Mixer
% Part #: XM-A3W2-0404D
% Datasheet: HMC1048ALC3B
% Link to data sheet:
%"https://www.analog.com/media/en/technical-documentation/data-sheets/hmc1048a.p
%df"
%------------------------------------------------------------------------------

clc, clear, close
% Constants
giga = 10^9;
milli = 10^-3;
micro = 10^-6;
nano = 10^-9;
% Set up of time vector used for plotting
start_point = 0;
increment = .1 * nano;
end_point = 1 * milli;
t = (start_point : increment : end_point);
%------------------------------------------------------------------------------

% Note: The following values below chosen based on either it was provided
% by the datasheet or determined.
% dB Values
LO_power_dB = 14; % unit: dBm (from datasheet)
IF_power_dB = 11; % unit: dBm (N210 can output power within
%the range of 0-20 dBm)
conversion_loss_of_mixer = 10; % unit: dBm (from datasheet)
% Relevant Frequency
IF_frequency = 4.4 * giga; % unit: GHz (Max frequency of the N210)
%------------------------------------------------------------------------------

% General Equation for output of Mixer
% Note: David used this equation for calculating the output power of the
% mixer in his component schematic.
RF_power_dB = IF_power_dB - conversion_loss_of_mixer;
% Note: Jackson stated:
% RF_power_dB = IF_power_dB - conversion_loss_of_mixer - loss_due_to_IM
% dont currently have the IM value. Not 100% if the IM value is obtained
% from testing or if its provided in the datasheet.
%------------------------------------------------------------------------------

% This block of code focuses on the conversion of dBm to mW for plotting
%purposes in the time domain.
% The IF signal is the input to the mixer
IF_power_watts_conversion = (10^(IF_power_dB/10))/1000;
IF_power_watts_signal = IF_power_watts_conversion * cos (IF_frequency*t);
% The RF signal is the output of the mixer (in terms of the Tx chain)
RF_power_watts_conversion = (10^(RF_power_dB/10))/1000;
RF_power_watts_signal = RF_power_watts_conversion * cos (IF_frequency*t);
%------------------------------------------------------------------------------

%Plot and Setting
hold on
grid on
plot(t,IF_power_watts_signal, 'b') % Input plot
plot(t, RF_power_watts_signal, 'r') % Output plot
xlim([0,10*nano]) % Time base units: sec therefore range set
%to 0 to 10 nanosec
ylim([-15* milli , 15 * milli]) % Power base unit: Watts therefore range
%set to -15 to 15 milliWatt
xlabel('Time [s]')
ylabel('Power [W]')
title('Input and Output of Tx Mixer')
hold off
%------------------------------------------------------------------------------
