% Factory class creating _Data_ objects
%   Parses video definitions
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
            videoDefs = self.parseVideoDefinitions(conf.VideoDef);
            videoLength = 0;
            % Calculate complete video length
            for i=1:length(videoDefs)
                videoLength = videoLength + videoDefs{i}.length;
            end
            subjectFactory = SubjectFactory();
            subjects = subjectFactory.createSubjects(conf,videoLength);
            data = Data(subjects,videoDefs);
        end
    end
    
    methods(Access=private)
        %% Parses video definitions
        function videoDefs = parseVideoDefinitions(self,videoDefFile)
            fileID = fopen(videoDefFile);
            fileContents = textscan(fileID,'%s','Delimiter','\n');
            fclose(fileID);
            fileContents = fileContents{1};
            [numVideoDefs,~] = size(fileContents);
            videoDefs = cell(1,numVideoDefs);
            for i = 1:numVideoDefs
                videoDef = fileContents{i};
                values = textscan(videoDef,'%u','Delimiter',',');
                values = values{1};
                videoLength = values(2);
                type = values(1);
                intervals=values(setdiff(1:length(values),[1 2]));
                videoDefs{i} = VideoDefinition(videoLength,type,intervals);
            end
        end
    end
end

