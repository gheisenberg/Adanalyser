% Data representation for seetings set by the user using the gui window
%   Stores all file paths and settings needed for analysis
classdef Config
    
    properties
        % File paths
        EDAFiles = cell(0)
        EEGFiles = cell(0)
        ECGFiles = cell(0)
        VideoDef = ''
        OutputDirectory = ''
        % Output flags
        EEGFig = 0
        FrequencyFig = 0
        EDAFig = 0
        DetrendedEDAFig = 0 
        RecurrenceFig = 0 
        HRVFig = 0 
        SubVideoEDAFig = 0
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
                'OutputDirectory=',self.OutputDirectory,char(10),...
                'EDAFiles=',edaTxt,char(10),...
                'EEGFiles=',eegTxt,char(10),...
                'ECGFiles=',ecgTxt,char(10),...
                'VideoDef=',self.VideoDef,char(10),...
                'EEGFig=',num2str(self.EEGFig),char(10),...
                'EDAFig=',num2str(self.EDAFig),char(10),...
                'HRVFig=',num2str(self.EDAFig),char(10),...
                'SubVideoEDAFig=',num2str(self.SubVideoEDAFig),char(10),...
                'Statistics=',num2str(self.Statistics),char(10),...
                'BehaveFig=',num2str(self.BehaveFig),char(10),...
                'DetrendedEDAFig=',num2str(self.DetrendedEDAFig),char(10),...
                'RecurrenceFig=',num2str(self.RecurrenceFig),char(10),...
                'QualityFig=',num2str(self.QualityFig),char(10),...
                'FrequencyFig=',num2str(self.FrequencyFig),char(10),...
                'LowerThreshold=',num2str(self.LowerThreshold),char(10),...
                'UpperThreshold=',num2str(self.UpperThreshold),char(10),...
                'QualityIndex=',num2str(self.QualityIndex),char(10),...
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

