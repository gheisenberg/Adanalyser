% Data representation for seetings set by the user using the gui window
% Stores all file paths and settings needed for analysis
classdef Config
    
    properties
        % File paths
        EDAFiles = cell(0)
        EEGFiles = cell(0)
        HRVFiles = cell(0)
        StimuIntDef = ''
        OutputDirectory = ''
		EEG_DEVICE=''
		EDA_DEVICE=''
		HRV_DEVICE=''
        % Output flags
        EEG_DEVICE_USED = 0
        FrequencyFig = 0
        EDA_DEVICE_USED = 0
        DetrendedEDAFig = 0 
        RecurrenceFig = 0 
        HRV_DEVICE_USED = 0 
        SubStimuIntEDAFig = 0
        QualityFig = 0
        BehaveFig = 0 
        Statistics = 0 
        % Quality Settings
        LowerThreshold = -100
        UpperThreshold = 100
        QualityIndex = 10
        % Recurrence Treshhold
        RecurrenceThreshold = 0
        EEGCutoffValue = 10
        %Topology Plot
        TopoRange = 2000
        %Subject
        numSubjects = 0
        
    end
    
    methods
        %% Generates string representation of config object
        %   Used to store config objects as file See:_ConfigManager_ 
        function str = toString(config)
            edaTxt = config.cellArrayToString(config.EDAFiles); 
            eegTxt = config.cellArrayToString(config.EEGFiles); 
            hrvTxt = config.cellArrayToString(config.HRVFiles); 
            str = [...
                'OutputDirectory=',config.OutputDirectory,newline,...
                'EDAFiles=',edaTxt,newline,...
                'EEGFiles=',eegTxt,newline,...
                'HRVFiles=',hrvTxt,newline,...
                'StimuIntDef=',config.StimuIntDef,newline,...
                'EEG_DEVICE_USED=',num2str(config.EEG_DEVICE_USED),newline,...
                'EDA_DEVICE_USED=',num2str(config.EDA_DEVICE_USED),newline,...
                'HRV_DEVICE_USED=',num2str(config.HRV_DEVICE_USED),newline,...
				'EEG_DEVICE=',config.EEG_DEVICE,newline,...
				'EDA_DEVICE=',config.EDA_DEVICE,newline,...
				'HRV_DEVICE=',config.HRV_DEVICE,newline,...
                'SubStimuIntEDAFig=',num2str(config.SubStimuIntEDAFig),newline,...
                'Statistics=',num2str(config.Statistics),newline,...
                'BehaveFig=',num2str(config.BehaveFig),newline,...
                'DetrendedEDAFig=',num2str(config.DetrendedEDAFig),newline,...
                'RecurrenceFig=',num2str(config.RecurrenceFig),newline,...
                'QualityFig=',num2str(config.QualityFig),newline,...
                'FrequencyFig=',num2str(config.FrequencyFig),newline,...
                'LowerThreshold=',num2str(config.LowerThreshold),newline,...
                'UpperThreshold=',num2str(config.UpperThreshold),newline,...
                'QualityIndex=',num2str(config.QualityIndex),newline,...
                'RecurrenceTreshold=',num2str(config.RecurrenceThreshold),newline,...
                'EEGCutoffValue=',num2str(config.EEGCutoffValue),newline,...
                'TopoRange=',num2str(config.TopoRange),newline,...
                'numSubjects=',num2str(config.numSubjects)
                ];
        end
    end
   methods(Access=private)
       function str = cellArrayToString(self,cellArray)
            cellArray(cellfun('isempty',cellArray)) = [];
            cellArrayTxt = sprintf('%s,',cellArray{:});
            str = cellArrayTxt(1:end-1);
       end 
   end
    
end

