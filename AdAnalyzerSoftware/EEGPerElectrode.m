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

classdef EEGPerElectrode
    properties
        % parsed eeg values 
        eegValues={} 
        % Matrix representation of the eeg values [seconds X Values per second; double]
        eegMatrix={} 
        filteredEEGPerVid = {}
        %State of electrode
        electrode
    end
end

