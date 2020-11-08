% Representation of the config for the analysis
%   Contains:
%           all settings of the GUI window
%           stores all file paths and settings needed for analysis
%
% Author: Gernot Heisenberg
%

classdef Config
    
    properties
        % Variables for file paths
        EDAFiles = cell(0)
        EEGFiles = cell(0)
        HRVFiles = cell(0)
        StimuIntDef = ''
        OutputDirectory = ''
		EEG_DEVICE=''
		EDA_DEVICE=''
		HRV_DEVICE=''
        % Variables for output flags
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
        topoplot = 1
        brainactivity = 1
        % Variables forQuality Settings
        LowerThreshold = -100
        UpperThreshold = 100
        QualityIndex = 10
        % Variables for Recurrence Treshhold
        RecurrenceThreshold = 0
        EEGCutoffValue = 10
        % Variables for Topology Plot
        videoName = ''
        UserFrameRate = 30
        TopoRange = 2000
        BrainRange = 2000
        % Variables for number of subject
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
                'VideoName=',config.videoName,newline,...
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
                'RecurrenceThreshold=',num2str(config.RecurrenceThreshold),newline,...
                'EEGCutoffValue=',num2str(config.EEGCutoffValue),newline,...
                'TopoRange=',num2str(config.TopoRange),newline,...
                'BrainRange=',num2str(config.BrainRange),newline,...
                'numSubjects=',num2str(config.numSubjects),newline,...
                'topoplot=',num2str(config.topoplot),newline,...
                'UserFrameRate=',num2str(config.UserFrameRate),newline,...
                'brainactivity=',num2str(config.brainactivity)
                ];
        end
    end
   methods(Access=private)
       %converts cell to array to be able to save them later on
       function str = cellArrayToString(self,cellArray)
            cellArray(cellfun('isempty',cellArray)) = [];
            cellArrayTxt = sprintf('%s,',cellArray{:});
            str = cellArrayTxt(1:end-1);
       end 
   end
    
end

