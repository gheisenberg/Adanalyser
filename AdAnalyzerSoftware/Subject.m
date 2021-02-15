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
        
        % parsed values
        edaValues={}
        hrvValues={}
        eegValuesForElectrodes ={}
        Electrodes = []
        invalidElectrodes = []
        
        % Values set during FilterAction
        % values per Stimlus
        edaPerStim = {}
        eegPerStim = {}
        hrvPerStim = {}
        
        % eeg values sub sampled
        eegSubSample = {}
        
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

