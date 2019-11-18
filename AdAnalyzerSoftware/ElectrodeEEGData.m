classdef ElectrodeEEGData
    %ELETRODEEEGDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % parsed eeg values 
        eegValues={} 
        % Matrix representation of the eeg values [seconds X Values per second; double]
        % See: DataFactory
        eegMatrix={} 
        filteredEEGPerVid = {} 
        electrode
    end
    
    methods
    end
    
end

