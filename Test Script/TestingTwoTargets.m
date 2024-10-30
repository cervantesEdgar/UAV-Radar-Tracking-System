%% Radar Specifications 
clear;
close;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frequency of operation = 77GHz
% Max Range = 200m
% Range Resolution = 1 m
% Max Velocity = 100 m/s
%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_range = 200;
range_resolution = 1;
max_velocity = 70;

% speed of light = 3e8
c = 3e8; 
%% User Defined Range and Velocity of targets
% Target 1
target_range1 = 110; 
target_velocity1 = 10; 

% Target 2
target_range2 = 150;  % Add the second target's initial range
target_velocity2 = 10;  % Add the second target's velocity
 
%% FMCW Waveform Generation

% Design the FMCW waveform
B = c /(2*range_resolution);
Tchirp= (5.5*2*max_range)/c;
slope = B/Tchirp;

%Operating carrier frequency of Radar 
fc= 10e9;             %carrier freq
                                                          
% The number of chirps in one sequence. 
Nd=128;                   % #of doppler cells OR #of sent periods

% The number of samples on each chirp. 
Nr=1024;                  % # of range cells

% Timestamp for running the displacement scenario for every sample on each chirp
t=linspace(0,Nd*Tchirp,Nr*Nd); %total time for samples

%Creating the vectors for Tx, Rx and Mix based on the total samples input.
Tx=zeros(1,length(t)); %transmitted signal
Rx=zeros(1,length(t)); %received signal
Mix = zeros(1,length(t)); %beat signal

%Similar vectors for range_covered and time delay.
r_t1=zeros(1,length(t));
td1=zeros(1,length(t));

r_t2=zeros(1,length(t));  % For the second target
td2=zeros(1,length(t));   % For the second target

%% Signal generation and Moving Target simulation
% Running the radar scenario over time

for i=1:length(t)
    
    % Target 1
    r_t1(i) = target_range1 + target_velocity1*t(i);
    td1(i) = 2*r_t1(i)/c;
    
    % Target 2
    r_t2(i) = target_range2 + target_velocity2*t(i);
    td2(i) = 2*r_t2(i)/c;

    % Transmitted signal (same for both targets)
    Tx(i) = cos(2*pi*(fc*t(i) + (slope*t(i)^2)/2));
    
    % Received signal from both targets
    Rx1 = cos(2*pi*(fc*(t(i)-td1(i)) + (slope*(t(i)-td1(i))^2)/2));
    Rx2 = cos(2*pi*(fc*(t(i)-td2(i)) + (slope*(t(i)-td2(i))^2)/2));
    
    % Combine the received signals from both targets
    Rx(i) = Rx1 + Rx2;
    
    % Mixing the transmit and received signal to generate the beat signal
    Mix(i) = Tx(i).*Rx(i);
    
end

%% RANGE MEASUREMENT

% Reshape the beat signal into Nr*Nd array
sig = reshape(Mix, [Nr, Nd]);

% Run the FFT on the beat signal along the range bins dimension (Nr)
sig_fft1 = fft(sig, Nr);

% Normalize and take the absolute value of FFT output
sig_fft1 = abs(sig_fft1./Nr);

% Take only one side of the spectrum
sig_fft1 = sig_fft1(1:(Nr/2));

% Plotting the range
figure('Name','Range from First FFT')
plot(sig_fft1, "LineWidth",2);
grid on;
axis ([0 200 0 0.5]);
xlabel('Range');
ylabel('FFT output');
title('Range Plot');

%% RANGE DOPPLER RESPONSE

Mix=reshape(Mix,[Nr,Nd]);

% 2D FFT using the FFT size for both dimensions.
sig_fft2 = fft2(Mix,Nr,Nd);

% Taking just one side of signal from Range dimension.
sig_fft2 = sig_fft2(1:Nr/2,1:Nd);
sig_fft2 = fftshift(sig_fft2);
RDM = abs(sig_fft2);
RDM = 10*log10(RDM);

% Use the surf function to plot the output of 2DFFT
doppler_axis = linspace(-100,100,Nd);
range_axis = linspace(-200,200,Nr/2)*((Nr/2)/400);
figure,surf(doppler_axis,range_axis,RDM);
xlabel('Doppler');
ylabel('Range');
zlabel('RDM');
title('Range Doppler Map');

% *%TODO* :
%display the CFAR output using the Surf function like we did for Range
%Doppler Response output.

% CFAR Output Plot (New Plot for CFAR results)
figure('Name', 'CFAR Detection Output');
surf(doppler_axis,range_axis,RDM);  % Display the thresholded RDM after CFAR
colorbar;
xlabel('doppler');
ylabel('range');
zlabel('Normalized Amplitude');
title('CFAR Output');