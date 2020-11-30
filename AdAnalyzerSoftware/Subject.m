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
        % parsed eda values
        edaValues={}
        % parsed hrv values 
        hrvValues={}
        % parsed eeg values and status of position
        eegValuesForElectrodes ={}
        Electrodes = []
        invalidElectrodes = []
        % Values set during FilterAction
        isValid = 1
        edaPerVid= {}
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

