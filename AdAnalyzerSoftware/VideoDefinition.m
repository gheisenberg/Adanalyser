%Data representation of a VideoDefinition.  
%   Stores one row of the video definition file. 
classdef VideoDefinition
    
    properties
        videoType % See: VideoType
        length % Length of the Video
        intervals ={} % Intervals of interest 
    end
    
    methods
        %% Constructor: Creates new VideoDefinition and sets values
        function VD = VideoDefinition(type,l,intervals)
            VD.videoType = type;
            VD.length = l;
            VD.intervals = intervals; 
        end
    end
    
end

