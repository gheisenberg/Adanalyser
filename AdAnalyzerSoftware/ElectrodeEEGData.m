classdef ElectrodeEEGData
    %ELETRODEEEGDATA Summary of this class goes here
    %Saves the data from SubjectFacotry.m for each EEG Electrodes in a vector and a matrix 
    
    %   Detailed explanation goes here
    %   eegValues: vector with all values
    %   eegMatrix: matrix, with x rows for number of seconds and x columns
    %              based on the Hz of the device
    %   filteredEEGPerVid: vector, with filtered values
    %   electrode: char, with the name of the electrode

    
    
    properties
        % parsed eeg values 
        eegValues={} 
        % Matrix representation of the eeg values [seconds X Values per second; double]
        eegMatrix={} 
        filteredEEGPerVid = {}
        %State of electrode
        electrode
    end
    
    methods
    end
    
end

