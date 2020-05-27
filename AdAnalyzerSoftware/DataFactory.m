% Factory class creating _Data_ objects
%   Parses StimulusInterval definitions
%   Cut off eeg and eda values for each subject
%   Creates eegMatrix for each subject
%
% Author: Gernot Heisenberg
%
classdef DataFactory
    
    properties
    end
    
    methods
        %% Creates new _Data_ object
        %   Cut off first X seconds of eeg values, selected by user
        %   Cut off eda values at the end
        %   Sets eeg matrix
        function data = createData(self, conf, eegDevice,edaDevice,hrvDevice)
            stimuIntDefs = self.parseStimuIntDefinition(conf.StimuIntDef);
            StimuIntLength = 0;
            % Calculate complete StimulusInterval length
            for i=1:length(stimuIntDefs)
                StimuIntLength = StimuIntLength + stimuIntDefs{i}.Stimulength;
            end
            subjectFactory = SubjectFactory();
            subjects = subjectFactory.createSubjects(conf,StimuIntLength,eegDevice,edaDevice,hrvDevice);
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
                AdIndex = textscan(stimuIntDef,'%u %u %s %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u','Delimiter',',');
                AdIndex = AdIndex(~cellfun('isempty',AdIndex));
                Stimulength = cell2mat(AdIndex(1));
                type = cell2mat(AdIndex(2));
                stimuIntDescrp = cell2mat(AdIndex{1,3});
                IndexLength = length(AdIndex);
                if IndexLength >= 4
                intervals = zeros(IndexLength-3,1);
                    for j = 1:IndexLength-3
                    intervals(j,1) = cell2mat(AdIndex(j+3));
                    end
                else
                    intervals = [];
                end
                StimuIntDefs{i} = StimuIntDefinition(Stimulength,type,stimuIntDescrp,intervals);
            end
        end
    end
end

