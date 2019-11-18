% Data representation of complete Data needed for analysis
%   Contains subject specific data and video definitions
classdef Data

    properties
        subjects = {} % cell array of subjects. See _Subject_ 
        videoDefs % video definition. See _VideoDefinition_
        isValid = 0 
    end
    
    methods
        %% Constructor: Creates new data object and sets _Subject_s and __VideoDefinition 
        function D = Data(subjects,videoDefs)
            D.subjects = subjects; 
            D.videoDefs = videoDefs; 
        end        
    end
    
end

