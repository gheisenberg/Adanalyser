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

classdef EEGDataPerElectrode
    properties
        % name of electrode
        electrode
        
        % Matrix representation of the eeg values [seconds X Values per second; double]
        % all EEG data is build on this data
        eegMatrix = {} 
        
        % Bandpassed eeg Values (1-49 Hz) for each electrode
        eegValues = {} 
        
        % Bandpassed eeg data for each Stimulus Interval for each electode
        eegPerStim = {}
        
        % Spectrum Band (Alpha,Beta1,..) for EEG data for each electrode
        eegSpecBandPerStim = {}
    end
end
