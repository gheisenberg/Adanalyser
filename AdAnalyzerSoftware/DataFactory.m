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
        %   Creates data object for subjects and Stimulus
        function data = createData(self, conf, eegDevice,edaDevice,hrvDevice)
            stimuIntDefs = self.parseStimuIntDefinition(conf.StimuIntDef);
            StimuIntLength = 0;
            % Calculate complete StimulusInterval length
            for i=1:length(stimuIntDefs)
                StimuIntLength = StimuIntLength + stimuIntDefs{i}.Stimulength;
            end
            subjectFactory = SubjectFactory();
            % create subject
            subjects = subjectFactory.createSubjects(conf,StimuIntLength,eegDevice,edaDevice,hrvDevice);
            % save subject and Stimulus in data
            data = Data(subjects,stimuIntDefs);
        end
    end
    
    methods(Access=private)
        %% Parses StimulusInterval definition
        % import the AdIndex and creates a Stimulus Interval Definition
        % cell array with each Stimulus Interval
        function StimuIntDefs = parseStimuIntDefinition(self,StimulusIndex)
            %get AdIndex and store it in cell array
            fileID = fopen(StimulusIndex);
            fileContents = textscan(fileID,'%s','Delimiter','\n');
            fclose(fileID);
            fileContents = fileContents{1};
            [numStimuIntDefs,~] = size(fileContents);
            StimuIntDefs = cell(1,numStimuIntDefs);
            % for loop for each Stimulus Interval
            for i = 1:numStimuIntDefs 
                stimuIntDef = fileContents{i};
                AdIndex = textscan(stimuIntDef,'%u %u %s %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u','Delimiter',',');
                AdIndex = AdIndex(~cellfun('isempty',AdIndex));
                Stimulength = cell2mat(AdIndex(1));
                % get type - see StimuusIntDefinition.m
                % and user given Description 
                type = cell2mat(AdIndex(2));
                stimuIntDescrp = cell2mat(AdIndex{1,3});
                IndexLength = length(AdIndex);
                % length above 4 = Stimulus with Interval - see AdIndex
                % conventions in ReadMe
                if IndexLength >= 4
                    intervals = zeros(IndexLength-3,1);
                    for j = 1:IndexLength-3
                        intervals(j,1) = cell2mat(AdIndex(j+3));
                    end
                    % validate the length of the Stimulus with the given
                    % intervals by the user
                    if max(intervals) > Stimulength
                        fprintf('Intervals in "%s" doesn´t match stimulus length.\n\n',stimuIntDescrp)
                    end
                else
                    intervals = [];
                end
                % save Stimulus Interval in Stimlus Interval Definitions
                StimuIntDefs{i} = StimuIntDefinition(Stimulength,type,stimuIntDescrp,intervals);
            end
        end
    end
end

