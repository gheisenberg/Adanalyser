%Data representation of a StimuIntDefinition.  
%   Stores one row of the SimulationsInterval definition file. 
classdef StimuIntDefinition
        
    properties
        stimuIntDescrp %Description of StimuInt
        StimuIntType % See: StimuIntType
        length % Length of the Stimulusinterval
        intervals ={} % Intervals of interest 
        StimuIntLocal % Localization of reaction to StimulusInterval e.g. eda
    end
        
    methods
        %% Constructor: Creates new StimuIntDefinition and sets values
        function ST = StimuIntDefinition(type,l,intervals,numbertype)
            ST.StimuIntType = type;
            ST.length = l;
            ST.intervals = intervals; 
            
            %Adds a Description for the StimulationsInterval based on the
            %type
            
            if type == 0
                ST.StimuIntLocal = 'EDA';
                if numbertype(type+1) == 1
                ST.stimuIntDescrp = 'EDA Baseline';
                else
                    ST.stimuIntDescrp = ['EDA Baseline ' num2str(numbertype(type+1))];
                end
                
            elseif type == 1
                ST.StimuIntLocal = 'EDA';
                if numbertype(type+1) == 1
                ST.stimuIntDescrp = 'EDA Orienting Response';
                else
                    ST.stimuIntDescrp = ['EDA Orienting Response ' num2str(numbertype(type+1))];
                 end
                
            elseif type == 2
                ST.StimuIntLocal = 'EEG';
                if numbertype(type+1) == 1
                ST.stimuIntDescrp = 'EEG Baseline';
                else
                    ST.stimuIntDescrp = ['EEG Baseline ' num2str(numbertype(type+1))];
                end
                
            elseif type == 3
                ST.StimuIntLocal = 'EDA';
                if numbertype(type+1) == 1
                ST.stimuIntDescrp = 'TV Programm';
                else
                    ST.stimuIntDescrp = ['TV Programm ' num2str(numbertype(type+1))];
                end
                
            elseif type == 4
                ST.StimuIntLocal = 'EDA';
                if numbertype(type+1) == 1
                ST.stimuIntDescrp = 'TV Commercial';
                else
                    ST.stimuIntDescrp = ['TV Commercial ' num2str(numbertype(type+1))];
                end
                
            else
                ST.stimuIntDescrp = 'Wrong Type in AdIndex';
            end
        end
    end
    
end

