%Enumeration for Stimulusinterval types related to the Stimulusinterval definition file.  
%   Values:   EDABaseline(0), EDAOrientingResponse(1), EEGBaseline(2), TVProgramm(3), TVCommercial(4) 
%   See: StimuIntDefinition
classdef StimuIntType < int32
    enumeration
        EDABaseline(0)
        EDAOrientingResponse(1)
        EEGBaseline(2)
        TVProgramm(3) 
        TVCommercial(4) 
    end
end

