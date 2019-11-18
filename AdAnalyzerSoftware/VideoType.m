%Enumeration for video types related to the video definition file.  
%   Values:   EDABaseline(0), EDAOrientingResponse(1), EEGBaseline(2), TVProgramm(3), TVCommercial(4) 
%   See: VideoDefinition
classdef VideoType < int32
    enumeration
        EDABaseline(0)
        EDAOrientingResponse(1)
        EEGBaseline(2)
        TVProgramm(3) 
        TVCommercial(4) 
    end
end

