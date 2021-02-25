%% Factory class creating Subjects objects
%   Reads subject related files and creates appropriate data representation -> See: Subject
%   Also checks for in/valid of the provided data and if all nessesary
%   files are provided
%
% Author: Gernot Heisenberg, Tim Kreitzberg
%
classdef SubjectFactory
    
    properties 
        eegValuesForElectrodes = EEGPerElectrode;
    end
    
    methods
        %% Creates new Subjects on base of the file paths stored in Config Object.
        %   See: Config.m
        function subjects = createSubjects(self,config,StimuIntLength,eegDevice,edaDevice,hrvDevice)
            eegFilePaths = config.EEGFiles;
            edaFilePaths = config.EDAFiles;
            hrvFilePaths = config.HRVFiles;
            numberOfSubjects =  config.numSubjects;  
            message = ['Reading raw data for ' num2str(numberOfSubjects) ' subject(s)'];
            bar = waitbar(0,message);  % open waitbar dialog with message
            subjects=cell(1,numberOfSubjects);
            for i = 1:numberOfSubjects
                subject = Subject();
                % get subject name and electrode name from eeg file name
                numberOfEDA = length(edaFilePaths);
                numberofHRV = length(hrvFilePaths);
                % Check if number of EDA Files -> correct = get subject
                % names
                if numberOfSubjects <= numberOfEDA && numberOfEDA >= numberofHRV          
                    edaFileForSubject = edaFilePaths{i};
                    [~,name,~] = fileparts(edaFileForSubject);
                    splitFileName =  textscan(name,'%s','Delimiter','_');
                    subjectName = splitFileName{1}{2};
                    % Check if subject also containes a HRV file -> Invalid
                    % if not
                    if 0 == contains(hrvFilePaths,subjectName)
                        fprintf(['Subject ' subjectName ' is missing the HRV File!\n\n'])
                        fprintf('This subject will neither be filtered nor analyzed!\n\n')
                        subject.isValid = 0;
                        % go for next loop iteration
                        continue
                    end
                    if numberOfSubjects < numberOfEDA || numberOfSubjects < numberofHRV
                            if numberOfEDA == numberofHRV
                            total = numberOfEDA-numberOfSubjects;
                            fprintf('The number of subjects doesn´t match the number of EDA and HRV Files!\n')
                            fprintf([num2str(total) ' files will be filtered and analyzed in ascending order!\n\n'])
                            end
                            if numberOfEDA > numberofHRV
                            total = numberofHRV-numberOfSubjects;
                            fprintf('The number of subjects doesn´t match the number of EDA Files!\n')
                            fprintf([num2str(total) ' files will be filtered and analyzed in ascending order!\n\n'])
                            end
                    end
                % if EDA is incorrect check for HRV
                elseif numberOfSubjects <= numberofHRV                 
                    hrvFileForSubject = hrvFilePaths{i};
                    [~,name,~] = fileparts(hrvFileForSubject);
                    splitFileName =  textscan(name,'%s','Delimiter','_');
                    subjectName = splitFileName{1}{2};
                    % get incorrect Subject for EDA
                    if 0 == contains(edaFilePaths,subjectName)
                        fprintf(['Subject ' subjectName ' is missing the EDA File!\n'])
                        fprintf('This subject will neither be filtered nor analyzed!\n\n')
                        subject.isValid = 0;
                        continue
                    end
                    if numberOfSubjects < numberofHRV
                        total = numberofHRV-numberOfSubjects;
                        fprintf('The number of subjects doesn´t match the number of HRV Files!\n')
                        fprintf([num2str(total) ' files will be filtered and analyzed in ascending order!\n\n'])
                    end
                else 
                    fprintf('Please check the EDA and HRV Files or change number of subjects in config dialog!\n')
                    fprintf('Neither of them correlates with number of subjects!\n\n')
                    close(bar);
                    return
                end
                % get eeg files for subject by subject name
                matches = strfind(eegFilePaths,subjectName);
                Subjectmatches = find(~cellfun(@isempty,matches));
                usedElectrodes = eegDevice.electrodePositions;
                ElectrodesStates = eegDevice.electrodeState;
                NumElectrodesVector = size(usedElectrodes);
                NumElectrodes = NumElectrodesVector(1);
                NumMatches = length(Subjectmatches);
                % Check for EEG Files
                if NumMatches < NumElectrodes
                    missing = NumElectrodes - NumMatches;
                    fprintf(['Subject ' subjectName ' is missing ' num2str(missing) ' EEG File/s!\n'])
                    fprintf('This subject will neither be filtered nor analyzed!\n\n')
                    subject.isValid = 0;
                    continue
                end               
                for k = 1:NumElectrodes
                    subjectlist = eegFilePaths(Subjectmatches(1):Subjectmatches(end));
                    electrodelist = strfind(subjectlist,usedElectrodes{k});
                    eegFileIndicies = find(~cellfun(@isempty,electrodelist));
                    % Check State of Electrode
                    if ElectrodesStates{k} == 1
                        if eegFileIndicies > 0
                            eegFileForSubject = subjectlist{eegFileIndicies}; 
                            [subject.eegValuesForElectrodes{k},Validation] = self.parseEEGFile(config,eegFileForSubject,StimuIntLength,eegDevice);
                            if Validation ~= 0
                                fprintf(['The EEG File of subject ' subjectName ' for electrode ' Validation ' is too short!\n'])
                                fprintf('This subject will neither be filtered nor analyzed!\n\n')
                                subject.isValid = 0;
                                continue
                            end    
                        else
                            MissingElectrode = usedElectrodes(k);
                            Electrode = MissingElectrode{1};
                            SubjectNumber = num2str(i);
                            if config.EEG_DEVICE_USED == 1
                            fprintf('Data missing for subject %s for EEG electrode "%s".\n',SubjectNumber,Electrode)
                            fprintf('This subject will neither be filtered nor analyzed!\n\n')
                            subject.isValid = 0;
                            end
                        end
                    else
                        % Empty unused Electrodes from Device
                        eegDevice.electrodePositions{k} = [];
                        eegDevice.electrodeState{k} = [];
                    end
                end
                % Get empty rows
                removeEmptyPositions = eegDevice.electrodePositions;
                removeEmptyState = eegDevice.electrodeState;
                removeEmpty = subject.eegValuesForElectrodes;
                % delete empty rows
                eegDevice.electrodePositions = removeEmptyPositions(~cellfun('isempty',removeEmptyPositions));
                eegDevice.electrodeState = removeEmptyState(~cellfun('isempty',removeEmptyState));
                subject.eegValuesForElectrodes = removeEmpty(~cellfun('isempty',removeEmpty));
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
                [subject.edaValues,EDAValidation] = self.parseEDAFile(edaFileForSubject,StimuIntLength,edaDevice);
                if EDAValidation ~= 0
                    fprintf(['The EDA File of subject ' subjectName ' is too short!\n'])
                    fprintf('This subject will neither be filtered nor analyzed!\n\n')
                    subject.isValid = 0;
                end
                [subject.hrvValues,HRVValidation] = self.parseHRVFile(hrvFileForSubject,StimuIntLength,hrvDevice);
                if HRVValidation ~= 0
                    fprintf(['The HRV File of subject ' subjectName ' is too short!\n'])
                    fprintf('This subject will neither be filtered nor analyzed!\n\n')
                    subject.isValid = 0;
                end
                % Check for validation, else dont save subject
                subjects{i}=subject; 
                %  update waitbar
                waitbar(i /numberOfSubjects);
            end
            subjects = subjects(~cellfun('isempty',subjects));
            close(bar);
        end
    end
    methods(Access=private)
 
        
        %% Parses EEG file to array
        function [eegPerElectrode,invalid] = parseEEGFile(self,config,eegFile,StimuIntLength,eegDevice)
            invalid = [];
            % get eeg files and split them
            [~,name,~] = fileparts(eegFile);
            splitFileName = textscan(name,'%s','Delimiter','_');
            electrodeName = splitFileName{1}{3};
            fileID = fopen(eegFile);
            fileContents = textscan(fileID,'%d','Headerlines',1);
            fclose(fileID);
            eegRawValues =  fileContents{1};
            eegPerElectrode = EEGPerElectrode();
            eegPerElectrode.electrode = electrodeName; 
            eegOffset = config.EEGCutoffValue;
            EEGSamplingRate = eegDevice.samplingRate;
            start = eegOffset*EEGSamplingRate;
            ende = start+(StimuIntLength*EEGSamplingRate);
            % check for correct length of raw values
            if length(eegRawValues) < ende
                invalid = electrodeName;
            else
            % Cut of eeg values and create eeg matrix for each subject
            eegValsCutoff = eegRawValues(start:ende-1);
            eegValsMatrix = reshape(eegValsCutoff,EEGSamplingRate,StimuIntLength);
            eegPerElectrode.eegValues = eegValsCutoff;
            eegPerElectrode.eegMatrix = double(eegValsMatrix');
            end
        end
        
        %% Parses HRV file to double array
        function [hrvValues,invalid] = parseHRVFile(self,hrvFile,StimuIntLength,hrvDevice)
            invalid = [];
            hrvValuesPerSec = hrvDevice.samplingRate;
            fileID = fopen(hrvFile);
            fileContents = textscan(fileID,'%f %f','Delimiter',',');
            fclose(fileID);
            hrvValues = fileContents(:,2);
            % cut off all HRV values after Stimulus Interval Length
            % 5*sampling rate
            if length(hrvValues{1}) >= hrvValuesPerSec*StimuIntLength+hrvValuesPerSec*5
                hrvValues = hrvValues{1}(1:hrvValuesPerSec*StimuIntLength+hrvValuesPerSec*5); % Add 5 values as dummy
            else
                invalid = 1;
            end
        end
        
        
        %% Parses EDA file to double array
        function [edaValues,invalid] = parseEDAFile(self,edaFile,StimuIntLength,edaDevice)
            invalid = [];
            edaValuesPerSec = edaDevice.samplingRate;
            fileID = fopen(edaFile);
            fileContents = textscan(fileID,'%f %f','HeaderLines',1,'Delimiter',',');
            fclose(fileID);
            edaValues = fileContents(:,2);
            % cut off all EDA values after Stimlus Interval Length
            if length(edaValues{1}) >= edaValuesPerSec*StimuIntLength
                edaValues = edaValues{1}(1:edaValuesPerSec*StimuIntLength);
            else
                invalid = 1;
            end
        end
        
    end
end


