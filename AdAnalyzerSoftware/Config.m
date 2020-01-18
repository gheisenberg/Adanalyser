% Data representation for seetings set by the user using the gui window
% Stores all file paths and settings needed for analysis
classdef Config
    
    properties
        % File paths
        EDAFiles = cell(0)
        EEGFiles = cell(0)
        ECGFiles = cell(0)
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
        
    end
    
    methods
        %% Generates string representation of config object
        %   Used to store config objects as file See:_ConfigManager_ 
        function str = toString(self)
            edaTxt = self.cellArrayToString(self.EDAFiles); 
            eegTxt = self.cellArrayToString(self.EEGFiles); 
            ecgTxt = self.cellArrayToString(self.ECGFiles); 
            str = [...
                'OutputDirectory=',self.OutputDirectory,newline,...
                'EDAFiles=',edaTxt,newline,...
                'EEGFiles=',eegTxt,newline,...
                'ECGFiles=',ecgTxt,newline,...
                'StimuIntDef=',self.StimuIntDef,newline,...
                'EEG_DEVICE_USED=',num2str(self.EEG_DEVICE_USED),newline,...
                'EDA_DEVICE_USED=',num2str(self.EDA_DEVICE_USED),newline,...
                'HRV_DEVICE_USED=',num2str(self.HRV_DEVICE_USED),newline,...
				'EEG_DEVICE=',self.EEG_DEVICE,newline,...
				'EDA_DEVICE=',self.EDA_DEVICE,newline,...
				'HRV_DEVICE=',self.HRV_DEVICE,newline,...
                'SubStimuIntEDAFig=',num2str(self.SubStimuIntEDAFig),newline,...
                'Statistics=',num2str(self.Statistics),newline,...
                'BehaveFig=',num2str(self.BehaveFig),newline,...
                'DetrendedEDAFig=',num2str(self.DetrendedEDAFig),newline,...
                'RecurrenceFig=',num2str(self.RecurrenceFig),newline,...
                'QualityFig=',num2str(self.QualityFig),newline,...
                'FrequencyFig=',num2str(self.FrequencyFig),newline,...
                'LowerThreshold=',num2str(self.LowerThreshold),newline,...
                'UpperThreshold=',num2str(self.UpperThreshold),newline,...
                'QualityIndex=',num2str(self.QualityIndex),newline,...
                'RecurrenceTreshold=',num2str(self.RecurrenceThreshold)
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

