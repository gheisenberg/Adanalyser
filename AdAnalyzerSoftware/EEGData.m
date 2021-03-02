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
%

classdef EEGData
    properties
        % Bandpassed eeg Values (1-49 Hz)/for each Stimulus Interval
        eegValues = {}
        eegPerStim = {} 
        
        % Bandpassed eeg data subsampeld by 4
        eegValuesSubedBy4 = {} 
        
        % Spectrum Band (Alpha,Beta1,..) for EEG data/data subsampeld by 4
        eegSpecBand = {}
        eegSpecBandSubedBy4 = {}
    end
end
