% Data representation of complete Data needed for analysis
%   Contains subject specific data and StimulusInterval definitions
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

