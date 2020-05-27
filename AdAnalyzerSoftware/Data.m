% Representation of all data 
%   Contains:
%           all subjects, 
%           all Stimulus, 
%           status of the subject
%
% Author: Gernot Heisenberg

classdef Data

    properties
        subjects = {} % cell array of subjects. See _Subject_ 
        stimuIntDefs % StimulusInterval definition. See StimuIntDefinition
        isValid = 0
    end
    
    methods
        %% Constructor: Creates new data object and sets _Subjects_ and StimuIntDefinition 
        function D = Data(subjects,stimuIntDefs)
            D.subjects = subjects; 
            D.stimuIntDefs = stimuIntDefs;
        end        
    end
    
end

