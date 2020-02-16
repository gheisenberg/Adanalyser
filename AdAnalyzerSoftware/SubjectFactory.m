%Creates new Subjects
%   Reads subject related files and creates appropriate data representation -> See: Subject
classdef SubjectFactory
    
    properties
    end
    
    methods
        %% Creates new Subjects on base of the file paths stored in Config Object.
        %   See: Config.m
        function subjects=createSubjects(self,config,StimuIntLength,eegDevice,edaDevice,hrvDevice)
            eegFilePaths = config.EEGFiles;
            edaFilePaths = config.EDAFiles;
            hrvFilePaths = config.HRVFiles;
            numberOfSubjects =  length(edaFilePaths);  
            message = ['Reading raw data for ' num2str(numberOfSubjects) ' subject(s)'];
            bar = waitbar(0,message);  % open waitbar dialog with message
            subjects=cell(1,numberOfSubjects);
            for i = 1:numberOfSubjects
                % get subject name and electrode name from eeg file name
                edaFileForSubject = edaFilePaths{i};
                [~,name,~] = fileparts(edaFileForSubject);
                splitFileName =  textscan(name,'%s','Delimiter','_');
                subjectName = splitFileName{1}{2};
                % get eeg files for subject by subject name
                matches = strfind(eegFilePaths,subjectName);
                eegFileIndicies = find(~cellfun(@isempty,matches));
                subject = Subject();
                for j = 1:length(eegFileIndicies)
                   eegFileForSubject = eegFilePaths{eegFileIndicies(j)}; 
                   subject.eegValuesForElectrodes{j} = self.parseEEGFile(eegFileForSubject,StimuIntLength,eegDevice);
                end
                % get eda file for subject by subject name
                matches = strfind(edaFilePaths,subjectName);
                edaFileIndex = ~cellfun(@isempty,matches);
                edaFileForSubject = edaFilePaths{edaFileIndex};
                % get hrv file for subject by subject name
                matches = strfind(hrvFilePaths,subjectName);
                hrvFileIndex = ~cellfun(@isempty,matches);
                hrvFileForSubject = hrvFilePaths{hrvFileIndex};
                % create the subject
                subject.name = subjectName;
                subject.edaValues = self.parseEDAFile(edaFileForSubject,StimuIntLength,edaDevice);
                subject.hrvValues = self.parseHRVFile(hrvFileForSubject,hrvDevice);    
                subjects{i}=subject; 
                % update waitbar
                waitbar(i /numberOfSubjects);
            end
            close(bar);
        end
    end
    methods(Access=private)
 
        
        %% Parses EEG file to int array
        function electrodeEEGdata = parseEEGFile(self,eegFile,StimuIntLength,eegDevice)
            [~,name,~] = fileparts(eegFile);
            splitFileName = textscan(name,'%s','Delimiter','_');
            electrodeName = splitFileName{1}{3};
            fileID = fopen(eegFile);
            fileContents = textscan(fileID,'%d','Headerlines',1);
            fclose(fileID);
            eegRawValues =  fileContents{1};
            electrodeEEGdata = ElectrodeEEGData();
            electrodeEEGdata.electrode = Electrodes.(electrodeName); 
            eegOffset = 10;
            EEGSamplingRate = eegDevice.samplingRate;
            start = eegOffset*EEGSamplingRate;
            ende = start+(StimuIntLength*EEGSamplingRate);
            % Cut of egg values and create eeg matrix for each subject
            eegValsCutoff = eegRawValues(start:ende-1);
            eegValsMatrix = reshape(eegValsCutoff,EEGSamplingRate,StimuIntLength);
            electrodeEEGdata.eegValues = eegValsCutoff;
            electrodeEEGdata.eegMatrix = double(eegValsMatrix');
        end
        
        %% Parses HRV file to double array
        function hrvValues = parseHRVFile(self,hrvFile,hrvDevice)
            fileID = fopen(hrvFile);
            fileContents = textscan(fileID,'%f %f','Delimiter',',');
            fclose(fileID);
            hrvValues = fileContents(:,2);
            hrvValues = hrvValues{1};
            %maybe we have to implement the HRV data values the same way as the EDA values
            % see below !!! Now we assume that hrvDevice.samplingRate = 1 
        end
        
        
        %% Parses EDA file to double array
        function edaValues = parseEDAFile(self,edaFile,StimuIntLength,edaDevice)
            edaValuesPerSec = edaDevice.samplingRate;
            fileID = fopen(edaFile);
            fileContents = textscan(fileID,'%f %f','HeaderLines',1,'Delimiter',',');
            fclose(fileID);
            edaValues = fileContents(:,2);
            edaValues = edaValues{1}(1:edaValuesPerSec*StimuIntLength);
        end
        
    end
end


