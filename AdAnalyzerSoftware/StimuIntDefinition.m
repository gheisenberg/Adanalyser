%Data representation of a StimuIntDefinition.  
%   Stores one row of the SimulationsInterval definition file. 
classdef StimuIntDefinition
    
    properties
        stimuIntDescrp %Description of StimuInt
        StimuIntType % See: StimuIntType
        length % Length of the Stimulusinterval
        intervals ={} % Intervals of interest 
    end
    
    methods
        %% Constructor: Creates new StimuIntDefinition and sets values
        function VD = StimuIntDefinition(type,l,intervals)
            VD.StimuIntType = type;
            VD.length = l;
            VD.intervals = intervals; 
            
            %Adds a Description for the StimulationsInterval based on the
            %type
            if type == 0
                VD.stimuIntDescrp = 'EDA Baseline';
            elseif type == 1
                VD.stimuIntDescrp = 'EDA OrientingResponse';
            elseif type == 2
                VD.stimuIntDescrp = 'EEG Baseline';
            elseif type == 3
                VD.stimuIntDescrp = 'TV Programm';
            elseif type == 4
                VD.stimuIntDescrp = 'TV Commercial';
            else
                VD.stimuIntDescrp = 'Wrong Type in AdIndex';
            end
            
        end
    end
    
end

