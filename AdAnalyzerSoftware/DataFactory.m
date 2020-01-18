% Factory class creating _Data_ objects
%   Parses StimulusInterval definitions
%   Cut off eeg and eda values for each subject
%   Creates eegMatrix for each subject
classdef DataFactory
    
    properties
    end
    
    methods
        %% Creates new _Data_ object
        %   Cut off first 10 seconds of eeg values
        %   Cut off eda values at the end
        %   Sets eeg matrix
        function data = createData(self, conf)
            stimuIntDefs = self.parseStimuIntDefinition(conf.StimuIntDef);
            StimuIntLength = 0;
            % Calculate complete StimulusInterval length
            for i=1:length(stimuIntDefs)
                StimuIntLength = StimuIntLength + stimuIntDefs{i}.length;
            end
            subjectFactory = SubjectFactory();
            subjects = subjectFactory.createSubjects(conf,StimuIntLength);
            data = Data(subjects,stimuIntDefs);
        end
    end
    
    methods(Access=private)
        %% Parses StimulusInterval definitions
        function StimuIntDefs = parseStimuIntDefinition(self,StimuIntDefFile)
            fileID = fopen(StimuIntDefFile);
            fileContents = textscan(fileID,'%s','Delimiter','\n');
            fclose(fileID);
            fileContents = fileContents{1};
            [numStimuIntDefs,~] = size(fileContents);
            StimuIntDefs = cell(1,numStimuIntDefs);
            for i = 1:numStimuIntDefs
                stimuIntDef = fileContents{i};
                values = textscan(stimuIntDef,'%u','Delimiter',',');
                values = values{1};
                StimuIntLength = values(2);
                type = values(1);
                intervals=values(setdiff(1:length(values),[1 2]));
                StimuIntDefs{i} = StimuIntDefinition(StimuIntLength,type,intervals);
            end
        end
    end
end

