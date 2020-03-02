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
        %State of electrode
        electrode
        isUsed
    end
    
    methods
    end
    
end

