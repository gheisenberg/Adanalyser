% Representation of all Values for each EEG electrode position
%   Contains:
%           eegValues: vector with all EEG values
%           eegMatrix: matrix, with x rows for number of seconds 
%                      and x columns based on the Hz of the device
%           filteredEEGPerVid: vector, with filtered EEG values
%           electrode: char, with the name of the electrode
%
% -> see SubjectFactory
%
% Author: Tim Kreitzberg

classdef EEGData
    properties
        % Bandpassed eeg Values (1-49 Hz)/for each Stimulus Interval
        eegValues = {}
        eegPerStim = {} 
        
        % Bandpassed eeg data subsampeld by 4
        eegValuesSubedBy4 = {} 
        
        % Spectrum Band (Alpha,Beta1,..) for EEG data/data subsampeld by 4
        % Values are sorted in following order:
        % 1 = Delta (1-4 Hz)
        % 2 = Theta(5-7 Hz)
        % 3 = Alpha(8-13 Hz)
        % 4 = Beta1(14-24 Hz)
        % 5 = Beta2(25-40 Hz
        % 6 = Task-Engagement
        eegSpecBand = {}
        eegSpecBandSubedBy4 = {}
    end
end
