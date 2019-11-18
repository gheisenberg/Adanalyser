% Class manages _Config_
%   Provides methods to load, save and validate _Config_ objects
classdef ConfigManager
    
    properties
    end
    
    methods
        %% Loads saved config files and creates _Config_ object from loaded data
        function conf = load(self)
            conf = Config();
            [file, path]=uigetfile('*.txt','Select conf file');
            try
                if file~=0
                    fid = fopen(fullfile(path, file),'r');
                    while ~feof(fid)
                        line = fgets(fid);
                        %values = textscan(line,'%s','Delimiter','=','BufSize', 200000);
                        values = textscan(line,'%s','Delimiter','=');
                        splitLine = values{1};
                        if isscalar(splitLine)
                            splitLine{2}='';
                        end
                        if strcmp(splitLine{1},'OutputDirectory')
                            conf.OutputDirectory=splitLine{2};
                        end
                        if strcmp(splitLine{1},'VideoDef')
                            conf.VideoDef=splitLine{2};
                        end
                        if strcmp(splitLine{1},'EEGFig')
                            conf.EEGFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'EDAFig')
                            conf.EDAFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'DetrendedEDAFig')
                            conf.DetrendedEDAFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'HRVFig')
                            conf.HRVFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'SubVideoEDAFig')
                            conf.SubVideoEDAFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'QualityFig')
                            conf.QualityFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'FrequencyFig')
                            conf.FrequencyFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'Statistics')
                            conf.Statistics=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'BehaveFig')
                            conf.BehaveFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'RecurrenceFig')
                            conf.RecurrenceFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'EDAFiles')
                            if ~isempty(findstr(',', splitLine{2}))
                                %files = textscan(splitLine{2},'%s','Delimiter',',','BufSize', 200000);
                                files = textscan(splitLine{2},'%s','Delimiter',',');
                                conf.EDAFiles = files{1};
                            elseif ~isempty(splitLine{2})
                                conf.EDAFiles = {splitLine{2}};
                            else
                                conf.EDAFiles = cell(0);
                            end
                        end
                        if strcmp(splitLine{1},'EEGFiles')
                            if ~isempty(findstr(',', splitLine{2}))
                                %files = textscan(splitLine{2},'%s','Delimiter',',','BufSize', 200000);
                                files = textscan(splitLine{2},'%s','Delimiter',',');
                                conf.EEGFiles = files{1};
                            elseif ~isempty(splitLine{2})
                                conf.EEGFiles = {splitLine{2}};
                            else
                                conf.EEGFiles = cell(0);
                            end
                        end
                        if strcmp(splitLine{1},'ECGFiles')
                            if ~isempty(findstr(',', splitLine{2}))
                                %files = textscan(splitLine{2},'%s','Delimiter',',','BufSize', 200000);
                                files = textscan(splitLine{2},'%s','Delimiter',',');
                                conf.ECGFiles = files{1};
                            elseif ~isempty(splitLine{2})
                                conf.ECGFiles = {splitLine{2}};
                            else
                                conf.ECGFiles = cell(0);
                            end
                        end
                        if strcmp(splitLine{1},'LowerThreshold')
                            conf.LowerThreshold=str2double(splitLine{2});
                        end
                        if strcmp(splitLine{1},'UpperThreshold')
                            conf.UpperThreshold=str2double(splitLine{2});
                        end
                        if strcmp(splitLine{1},'QualityIndex')
                            conf.QualityIndex=str2double(splitLine{2});
                        end
                        if strcmp(splitLine{1},'RecurrenceTreshold')
                            conf.RecurrenceThreshold=str2double(splitLine{2}); 
                        end 
                    end
                    fclose(fid);
                end
            catch ex
                dialogMessage = strcat([sprintf('%s\n','Error loading conf:'),ex.message]);
                h = warndlg(dialogMessage,'Error loading conf','modal');
                rethrow(ex);
            end
        end
        
        %% Saves _Config_ objects to file using toString method of config object
        function save(self,conf)
            text = conf.toString();
            [file,path] = uiputfile('*.txt','Save conf');
            if file~=0
                fid = fopen(fullfile(path,file),'wt');
                fprintf(fid,'%s',text);
                fclose(fid);
            end
        end
        
        %% Validates given _Config_ object and displays error dialog if config is not valid
        function valid = validate(self,conf)
            try
                msgID = 'VALIDATE:config';
                msg = 'Invalid Settings';
                isValid = true;
                baseException = MException(msgID,msg);
                try
                    assert(exist(conf.OutputDirectory,'dir')==7,'VALIDATE:outputdirectory','Output folder is not a valid folder.');
                catch ex
                    baseException = addCause(baseException,ex);
                    isValid = false;
                end
                try
                    assert(exist(conf.VideoDef,'file')==2,'VALIDATE:videodef','Path to Video definitions file is not valid.');
                catch ex
                    baseException = addCause(baseException,ex);
                    isValid = false;
                end
                try
                    assert(~isempty(conf.EDAFiles),'VALIDATE:edafiles','No EDA files selected. Please select at least one.');
                catch ex
                    baseException = addCause(baseException,ex);
                    isValid = false;
                end
                try
                    assert(~isempty(conf.EEGFiles),'VALIDATE:eegfiles','No EEG files selected. Please select at least one.');
                catch ex
                    baseException = addCause(baseException,ex);
                    isValid = false;
                end
                try
                    assert(~isempty(conf.ECGFiles),'VALIDATE:ecgfiles','No ECG files selected. Please select at least one.');
                catch ex
                    baseException = addCause(baseException,ex);
                    isValid = false;
                end
                try
                    assert(conf.UpperThreshold >= conf.LowerThreshold,'VALIDATE:threshold','Upper threshold must be greater or equal lower threshold');
                catch ex
                    baseException = addCause(baseException,ex);
                    isValid = false;
                end
                if ~isValid
                    throw(baseException);
                end
                valid = true;
            catch ex
                title = ex.message;
                dialogMessage = sprintf('Please verify your inputs: \n');
                for c = 1:numel(ex.cause)
                    nestedEx = ex.cause{c};
                    dialogMessage = strcat([sprintf('%s\n',dialogMessage),nestedEx.message]);
                end
                warndlg(dialogMessage,title,'modal');
                valid = false;
            end
        end
        
        
    end
end
