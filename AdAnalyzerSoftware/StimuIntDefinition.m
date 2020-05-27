% Representation of a Stimulus 
%   Contains:
%           Stimulus Length, 
%           Stimulus Type, 
%           Description of the Stimulus,
%           Interval of interest
%
% Author: Tim Kreitzberg
%
classdef StimuIntDefinition
        
    properties
        Stimulength % Length of the Stimulus Interval in [s]
        stimuIntType %Type of the Stimulus Interval 
        %List of StimuInt Types
        %0: EDA Baseline
        %1: EDA Orientation Response
        %2: EEG Baseline
        %3: Black Screen
        %4: Video Stimulus
        %5: Audio Stimulus
        %6: Image Stimulus
        stimuIntDescrp %Description of Stimu Interval, choosen by user
        intervals ={} % Intervals of interest 
    end
        
    methods
        %% Constructor: Creates new StimuIntDefinition and sets properties
        %See DataFactory
        function ST = StimuIntDefinition(Stimulength,type,stimuIntDescrp,intervals)
            ST.Stimulength = Stimulength;
            ST.stimuIntType = type;
            ST.stimuIntDescrp = stimuIntDescrp;
            ST.intervals = intervals;
        end
    end
end

