close all;
clear, clc

% Create an instance of the Splitter class with a specific usedFreq value
split = Splitter(5);

% Call the setUsedProperties method directly on the object

% Inspect the values of the properties
disp(['usedInsertionLoss: ' num2str(split.usedInsertionLoss)]);
disp(['usedIsolation: ' num2str(split.usedIsolation)]);
disp(['usedReturnLoss: ' num2str(split.usedReturnLoss)]);
disp(['usedPhaseUnbalance: ' num2str(split.usedPhaseUnbalance)]);
disp(['useAmplitudeUnbalance: ' num2str(split.useAmplitudeUnbalance)]);