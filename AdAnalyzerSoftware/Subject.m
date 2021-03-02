% Data representation of all informations related to one subject 
%   Contains:
%           a name, 
%           OutputDirectory,
%           isValid,
%           invalidElectrodes,
% 
%           edaValues,
%           hrvValues,
%           edaPerStim,
%           hrvPerStim,
% 
%           eegData;
% 
%           EEG;
%   hence, two different constructors are necessary 
%   See: SubjectFactory, DataFactory
%
% Author: Gernot Heisenberg
%

classdef Subject
   
    properties
        % subject dependent variables
        % see SubjectFactory.m and FilterAction.m
        name = '' 
        OutputDirectory = ''
        isValid = 1
        invalidElectrodes = []
        
        % bandpassed values set during FilterAction.m
        edaValues = {}
        hrvValues = {}
        
        % bandpassed values per Stimlus set during FilterAction.m
        edaPerStim = {}
        hrvPerStim = {}
        
        % eeg data struct containing all created eeg data
        % see eegData.m and eegDataPerElectrode for more information
        eegData = {}
        eegDataPerElectrode = {}
        
        % EEG structure for Topolody Plot
        % needed for topoplot() from EEGLAB 
        EEG = {} 
    end
    
    methods
        
        function eegValues = eegValuesByElectrode(self, electrode)
            eegValues = {}; 
            numEegValues = length(self.eegValues); 
            for i=1:numEegValues
                currentElectrode = self.eegValues{i}.electrode; 
                if (electrode == currentElectrode)
                    eegValues = self.eegValues{i}; 
                end
            end
        end 
        
    end
    
end

