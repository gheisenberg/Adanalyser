%Creates new Subjects
%   Reads subject related files and creates appropriate data representation -> See: Subject
classdef SubjectFactory
    
    properties 
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
                %Check if number of EDA Files -> correct = get subject
                %names
                if numberOfSubjects == numberOfEDA         
                    edaFileForSubject = edaFilePaths{i};
                    [~,name,~] = fileparts(edaFileForSubject);
                    splitFileName =  textscan(name,'%s','Delimiter','_');
                    subjectName = splitFileName{1}{2};
                    %Check if subject also containes a HRV file -> Invalid
                    %if not
                    if 1 ~= contains(hrvFilePaths{:},subjectName)
                        fprintf(['Subject ' subjectName ' is missing the HRV File!\n\n'])
                        fprintf('This subject will neither be filtered nor analyzed!\n\n')
                        subject.isValid = 0;
                        %go for next loop iteration
                        continue
                    end      
                %if EDA is incorrect check for HRV
                elseif numberOfSubjects == numberofHRV                 
                    hrvFileForSubject = hrvFilePaths{i};
                    [~,name,~] = fileparts(hrvFileForSubject);
                    splitFileName =  textscan(name,'%s','Delimiter','_');
                    subjectName = splitFileName{1}{2};
                    %get incorrect Subject for EDA
                    if 1 ~= contains(edaFilePaths{:},subjectName)
                        fprintf(['Subject ' subjectName ' is missing the EDA File!\n'])
                        fprintf('This subject will neither be filtered nor analyzed!\n\n')
                        subject.isValid = 0;
                        continue
                    end
                else 
                    fprintf('Please check the EDA and HRV Files!\n')
                    fprintf('Neither of them correlates with number of subjects.\n\n')
                    close(bar);
                    return
                end
                % get eeg files for subject by subject name
                matches = strfind(eegFilePaths,subjectName);
                Subjectmatches = find(~cellfun(@isempty,matches));
                usedElectrodes = eegDevice.electrodePositions;
                ElectrodesStates = eegDevice.electrodeState;
                ListVector = size(usedElectrodes);
                ListL = ListVector(1);
                for k = 1:ListL
                    subjectlist = eegFilePaths(Subjectmatches(1):Subjectmatches(end));
                    electrodelist = strfind(subjectlist,usedElectrodes{k});
                    eegFileIndicies = find(~cellfun(@isempty,electrodelist));
                    %Check State of Electrode
                    if ElectrodesStates{k} == 1
                        if eegFileIndicies > 0
                            eegFileForSubject = eegFilePaths{eegFileIndicies}; 
                            subject.eegValuesForElectrodes{k} = self.parseEEGFile(config,eegFileForSubject,StimuIntLength,eegDevice);
                        else
                            MissingElectrode = usedElectrodes(k);
                            Electrode = MissingElectrode{1};
                            SubjectNumber = num2str(i);
                            if config.EEG_DEVICE_USED == 1 %Tim Besprechen, wo schon gestoppt wird generell
                            fprintf('Data missing for subject %s for EEG electrode "%s".\n',SubjectNumber,Electrode)
                            fprintf('This subject will neither be filtered nor analyzed!\n\n')
                            subject.isValid = 0;
                            end
                        end
                    else
                        %Empty unused Electrodes from Device
                        eegDevice.electrodePositions{k} = [];
                        eegDevice.electrodeState{k} = [];
                    end
                end
                %Get empty rows
                removeEmptyPositions = eegDevice.electrodePositions;
                removeEmptyState = eegDevice.electrodeState;
                removeEmpty = subject.eegValuesForElectrodes;
                %delete empty rows
                eegDevice.electrodePositions = removeEmptyPositions(~cellfun('isempty',removeEmptyPositions));
                eegDevice.electrodeState = removeEmptyState(~cellfun('isempty',removeEmptyState));
                subject.eegValuesForElectrodes = removeEmpty(~cellfun('isempty',removeEmpty));
                subject.validElectrodes = eegDevice.electrodePositions;
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
        function electrodeEEGdata = parseEEGFile(self,config,eegFile,StimuIntLength,eegDevice)
            [~,name,~] = fileparts(eegFile);
            splitFileName = textscan(name,'%s','Delimiter','_');
            electrodeName = splitFileName{1}{3};
            fileID = fopen(eegFile);
            fileContents = textscan(fileID,'%d','Headerlines',1);
            fclose(fileID);
            eegRawValues =  fileContents{1};
            electrodeEEGdata = ElectrodeEEGData();
            electrodeEEGdata.electrode = electrodeName; 
            eegOffset = config.EEGCutoffValue;
            EEGSamplingRate = eegDevice.samplingRate;
            start = eegOffset*EEGSamplingRate;
            ende = start+(StimuIntLength*EEGSamplingRate);
            % Cut of eeg values and create eeg matrix for each subject
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


