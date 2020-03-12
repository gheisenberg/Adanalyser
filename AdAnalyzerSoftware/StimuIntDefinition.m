%Data representation of a StimuIntDefinition.  
%   Stores one row of the SimulationsInterval definition file. 
classdef StimuIntDefinition
        
    properties
        Stimulength % Length of the Stimulusinterval
        stimuIntType %Type of the Stimulusinterval
        %List of StimuInt Types
        %0: EDA Baseline
        %1: EDA Orientation Response
        %2: EEG Baseline
        %3: Black Screen
        %4: Video Stimulus
        %5: Audio Stimulus
        %6: Image Stimulus
        stimuIntDescrp %Description of StimuInt
        intervals ={} % Intervals of interest 
    end
        
    methods
        %% Constructor: Creates new StimuIntDefinition and sets values
        function ST = StimuIntDefinition(Stimulength,type,stimuIntDescrp,intervals)
            ST.Stimulength = Stimulength;
            ST.stimuIntType = type;
            ST.stimuIntDescrp = stimuIntDescrp;
            ST.intervals = intervals;
        end
    end
end

