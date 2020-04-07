%Data representation of all informations related to one subject 
%   See: SubjectFactory, DataFactory
classdef Subject
   
    properties
        %Initial values set during creation in SubjectFactory
        name = '' 
        % parsed eda values
        edaValues={}
        % parsed hrv values 
        hrvValues={} 
        eegValuesForElectrodes ={}
        validElectrodes = []
        %Values set during FilterAction
        isValid = 1
        edaPerVid= {}
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

