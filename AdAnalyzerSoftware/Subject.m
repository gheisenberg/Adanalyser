% Data representation of all informations related to one subject 
%   Contains:
%           a name, 
%           edaValues, 
%           hrvValues,
%           eegValuesForElectrodes,
%           Electrodes,
%           isValid,
%           edaPerVid,
%   hence, two different constructors are necessary 
%   See: SubjectFactory, DataFactory
%
% Author: Gernot Heisenberg
%

classdef Subject
   
    properties
        %Initial values set during creation in SubjectFactory
        name = '' 
        OutputDirectory = ''
        isValid = 1
        
        % invalid electrodes for subject
        invalidElectrodes = []
        
        % filterd values set during FilterAction
        % data values
        edaValues= {}
        hrvValues= {}
        eegValuesForElectrodes = {}
        
        % values per Stimlus
        edaPerStim = {}
        eegPerStim = {}
        hrvPerStim = {}
        
        % eeg values sub sampled
        eegSubSample = {}
        
        % frequency data
        frequencies = {}
        frequenciesSubedBy4 = {}
        frequenciesPerElectorde = {}
        
        % EEG structure for Topolody Plot
        EEG = {}
        
        % signalSpec
        signalSpec = []  
    end
    
    methods
        
        function eegValues = eegValuesByElectrode(self, electrode)
            eegValues = {}; 
            numEegValues = length(self.eegValuesForElectrodes); 
            for i=1:numEegValues
                currentElectrode = self.eegValuesForElectrodes{i}.electrode; 
                if (electrode == currentElectrode)
                    eegValues = self.eegValuesForElectrodes{i}; 
                end
            end
        end 
        
    end
    
end

