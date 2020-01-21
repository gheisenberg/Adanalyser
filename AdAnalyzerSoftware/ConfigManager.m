% Class manages _Config_
%   Provides methods to load, save and validate _Config_ objects
classdef ConfigManager
    
    properties
    end
    
    methods
        %% Loads saved config files and creates _Config_ object from loaded data
        function conf = load(self)
            conf = Config();
            [file, path]=uigetfile('.\config\*.txt','Select conf file');
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
                        if strcmp(splitLine{1},'StimuIntDef')
                            conf.StimuIntDef=splitLine{2};
                        end
                        if strcmp(splitLine{1},'EEG_DEVICE_USED')
                            conf.EEG_DEVICE_USED=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'EDA_DEVICE_USED')
                            conf.EDA_DEVICE_USED=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'HRV_DEVICE_USED')
                            conf.HRV_DEVICE_USED=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'EEG_DEVICE')
                            conf.EEG_DEVICE=splitLine{2};
                        end
						if strcmp(splitLine{1},'EDA_DEVICE')
                            conf.EDA_DEVICE=splitLine{2};
                        end
						if strcmp(splitLine{1},'HRV_DEVICE')
                            conf.HRV_DEVICE=splitLine{2};
                        end
						if strcmp(splitLine{1},'DetrendedEDAFig')
                            conf.DetrendedEDAFig=str2num(splitLine{2});
                        end
                        if strcmp(splitLine{1},'SubStimuIntEDAFig')
                            conf.SubStimuIntEDAFig=str2num(splitLine{2});
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
            
            % cut the config text into pieces
            conf_text_all = conf.toString();
            if(contains(conf_text_all,'EEG_DEVICE_USED=1'))
                conf_text_1= regexp(conf_text_all,'EEG_DEVICE_USED=1','split');
            else
                conf_text_1= regexp(conf_text_all,'EEG_DEVICE_USED=0','split');
            end
            conf_text_up = conf_text_1(1); % this now contains the upper part
            if(contains(conf_text_all,'EEG_DEVICE_USED=1'))
                conf_text_mid = strcat("EEG_DEVICE_USED=1",conf_text_1(2));
            else
                conf_text_mid = strcat("EEG_DEVICE_USED=0",conf_text_1(2));
            end
            
            if(contains(conf_text_all,'SubStimuIntEDAFig=1'))
                conf_text_2= regexp(conf_text_mid,'SubStimuIntEDAFig=1','split');
            else
                conf_text_2= regexp(conf_text_mid,'SubStimuIntEDAFig=0','split');
            end
            conf_text_mid = conf_text_2(1);% this one contains the mid part
            
            if(contains(conf_text_all,'SubStimuIntEDAFig=1'))
                conf_text_low = strcat("SubStimuIntEDAFig=1",conf_text_2(2));% this one contains the lower part
            else
                conf_text_low = strcat("SubStimuIntEDAFig=0",conf_text_2(2));% this one contains the lower part
            end
            
            % Set the formatting elements 
            braid = "----------------------------" + newline;
            path_text       = "PATHS" + newline;
            device_text     = "DEVICES" + newline;
            settings_text   = "SETTINGS" + newline;
            
            % start the formatting here now
            % the path section
            text = strcat(braid,path_text);
            text = strcat(text,braid);
            text = strcat(text,conf_text_up);
            % the device section
            text = strcat(text, braid);
            text = strcat(text,device_text);
            text = strcat(text, braid);
            text = strcat(text,conf_text_mid);
            % the settings section
            text = strcat(text, braid);
            text = strcat(text,settings_text);
            text = strcat(text, braid);
            text = strcat(text,conf_text_low);
            
            % write text to file
            [file,path] = uiputfile('.\config\*.txt','Save conf');
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
                    assert(exist(conf.StimuIntDef,'file')==2,'VALIDATE:StimuIntDef','Path to StimuInt definitions file is not valid.');
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
