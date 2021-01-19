% Performs filter calculation steps
%   Starts when button "Filter" was clicked
%   Analysis quality and filters subjects
%   Plots quality figures
%
% Author: Gernot Heisenberg, Tim Kreitzberg
%
classdef FilterAction < handle
    
    properties
        plotter = Plotter;
    end
    
    methods
        %% Main function of this class
        %   1. substracts mean for each column from eegMatrix column values
        %   2. calculates values outside allowed interval for filtered and unfiltered eeg values
        %   3. calculates eeg and eda values per StimulusInterval
        %   4. rates qualiyt
        %   5. plots eeg quality figures using _Plotter_ %currecntly
        %   disabled
        function [data,config] = filter(self,data,config,eegDevice,edaDevice,hrvDevice)
            message = ['Filtering data for ', num2str(length(data.subjects)), ' subject(s)'];
            h = waitbar(0,message);
            
            % create folder for data
            stamp = datetime('now');
            stamp = regexprep(datestr(stamp), ' ', '_');
            stamp = regexprep(stamp, ':', '_');
            parentfolder = config.OutputDirectory;
            subfolder_name = char(stamp);
            mkdir(fullfile(parentfolder, subfolder_name));
            
            % change directory to new folder
            config.OutputDirectory = [parentfolder '\' subfolder_name];
            
            % prepare loop
            numStimuInt = length(data.stimuIntDefs);
            numSubjects = length(data.subjects);            
            edaValsPerSec = edaDevice.samplingRate;
            eegValsPerSec = eegDevice.samplingRate;            
            unfilteredQuality = zeros(numSubjects,numStimuInt);
            filteredQuality = zeros(numSubjects,numStimuInt);
            %loop for each subject
            for i=1:numSubjects
                subject = data.subjects{i};
                
                % create folder for each subject
                parentfolder = config.OutputDirectory;
                subfolder_name = subject.name;
                mkdir(fullfile(parentfolder, subfolder_name));
                
                % change directory to subject folder
                subject.OutputDirectory = [parentfolder '\' subfolder_name];
                
                if subject.isValid == 1 % Filter invalid subjects
                numElectrodes = length(subject.eegValuesForElectrodes);
                %loop for each electrode position
                for j=1:numElectrodes
                    eegValues = subject.eegValuesForElectrodes{j};
                    rawMatrix = eegValues.eegMatrix;
                    [seconds,eegValsPerSec] = size(rawMatrix);
                    rawList = self.buildRawList(seconds,eegValsPerSec,rawMatrix);
                    % eegfiltfft is a eeglab function for (high|low|band) - 
                    % pass filter data using inverse fft - for more
                    % information please look at eegfiltfft.m
                    filteredList = eegfiltfft(rawList,eegValsPerSec,1,49);
                    %calculate the percent outside and 
                    percentOutside(1) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,rawList);
                    percentOutside(2) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,filteredList);
                    if (config.EEG_DEVICE_USED)
                        self.plotter.plotRawEEGFigures(rawList,filteredList,percentOutside,subject,eegValues.electrode,config);
                    end
                    % calculate eeg values per Stimulus Interval
                    eegValuesPerStim = self.getValuesPerStimuInt(1,eegValsPerSec,data.stimuIntDefs,rawList);
                    filteredEEGValuesPerVid = self.getValuesPerStimuInt(1,eegValsPerSec,data.stimuIntDefs,filteredList); 
                    eegValues.filteredEEGPerVid = filteredEEGValuesPerVid;
                    % save EGG Values in vector to write out csv
                    allEEGValues(j,:) = filteredList';
                    eegValues.eegValues = filteredList';
                    subject.eegValuesForElectrodes{j} = eegValues;
                    % Rate Quality for EEG Electrode
                    for v=1:numStimuInt
                        unfilteredEEGVid = eegValuesPerStim{v};
                        filteredEEGVid = filteredEEGValuesPerVid{v};
                        % unfilteredQuality(i,v) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,unfilteredEEGVid);
                        filteredQuality(i,v) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,filteredEEGVid); % vector will be to big, because it was used for the function "quality figures", which is deactivated 
                    end
                    % rate quality of each Stimulus Interval
                    subject = self.rateQuality(subject,filteredQuality,data.stimuIntDefs,config.QualityIndex,j);
                    % calculate eda values per StimulusInterval
                    edaValuesPerStim = self.getValuesPerStimuInt(1,edaValsPerSec,data.stimuIntDefs,subject.edaValues);
                    subject.edaPerVid = edaValuesPerStim;
                end
                % check for flag in config and prints out EEG Data 
                if config.EEGData == 1
                    % calculate time and add labels to timeseries
                    time = 0:1/eegDevice.samplingRate:seconds;
                    time = ["Time [s]",time(2:end)];
                    output = [subject.Electrodes num2cell(allEEGValues)];
                    % combine
                    output = [time; output];
                    fname = [subject.OutputDirectory '/' subject.name '_Filtered_EEG_Values.csv'];
                    writematrix(output', fname,'Delimiter','semi');
                end
                
                if config.EDAData == 1
                    % calculate time and add to timeseries
                    time = 0:1/edaDevice.samplingRate:seconds;
                    output = cat(2,time(2:end)',subject.edaValues);
                    title = ["Time [s]","EDA [MUs]"];
                    output = [title;output];
                    fname = [subject.OutputDirectory '/' subject.name '_EDA_Values.csv'];
                    writematrix(output,fname,'Delimiter','semi')
                end
                
                if config.HRVData == 1
                    % calculate time and add to timeseries
                    time = 1:1/hrvDevice.samplingRate:seconds; % add 5 seconds according to SubjectFactory.m
                    % cut off HRV into the exact timeframe
                    cut = length(subject.hrvValues)-length(time);
                    subject.hrvValues = subject.hrvValues(1:end-cut);
                    % combine the matrix
                    output = cat(2,time',subject.hrvValues);
                    title = ["Time [s]","R-R [ms]"];
                    output = [title;output];
                    fname = [subject.OutputDirectory '/' subject.name '_HRV_Values.csv'];
                    writematrix(output,fname,'Delimiter','semi')
                end
                
                data.subjects{i} = subject;
                waitbar(i/numSubjects);
                end       
                
            % plot quality figures
%           Kreitzberg: Commented out; Reason go to Plotter.m
%           rateQuality change, therefore is this function missing input variables 
%           plotEEGQualityFigures()
%             if (config.QualityFig)
%                 self.plotter.plotEEGQualityFigures(unfilteredQuality,filteredQuality,validStimuIntPerSubject,validSubjects,data.stimuIntDefs,config,numSubjects);
%             end
            end
            close(h);
        end
    end
    
    methods(Access=private)
        
        %% Substracts mean for each column from eegMatrix column values
        function rawList = buildRawList(self,seconds,eegValsPerSec,rawMatrix)
            for i = 1:seconds
                column=rawMatrix(i,:);
                m=mean(column);
                rawMatrix(i,:) = column-m;
            end
            totalEEGValues = double(seconds*eegValsPerSec);
            rawList = reshape(rawMatrix',1,totalEEGValues);
        end
        
        
        %% Calculates percentage of values outside lower and upper bound
        function percentOutside = getPercentQutside(self,lowerBound,upperBound,values)
            numValues = length(values);
            outside = length(find(values < lowerBound | values > upperBound));
            percentOutside = (outside/numValues)*100;
        end
        
        %% Splits given values per StimulusInterval using given StimuIntDefs and StimulusInterval start point
        function splittedValues = getValuesPerStimuInt(self,StimuIntStart,valuesPerSec,stimuIntDefs,values)
            numStimuInt = length(stimuIntDefs);
            splittedValues = cell(1,numStimuInt);
            for i = 1:numStimuInt
                Stimulus = stimuIntDefs{i};
                eegStimuIntLength = double(Stimulus.Stimulength*valuesPerSec);
                eegStimuIntEnd = StimuIntStart+eegStimuIntLength-1;
                splittedValues{i} = values(StimuIntStart:eegStimuIntEnd);
                StimuIntStart = StimuIntStart+eegStimuIntLength;
            end
        end
        
        %% Stores invalid Electrodes in subject
        %   Sets isValid flag for each Electrode based on used qualityThreshold
        function subjects = rateQuality(self,subjects,quality,stimuIntDefs,qualityThreshold,electrode) 
            if any(quality > qualityThreshold)
                    subjects.invalidElectrodes{end+1} = subjects.Electrodes{electrode};
            end
        end
        
        %% Splits given StimuIntDef based on there SimulationsInterval
        % Returns StimulusIntervals by their SimulationsInterval
%         function [baselines,ads,other,clips]= getStimuIntIndiciesByType(self,stimuIntDefs)
%             numStimuIntDefs = length(stimuIntDefs);
%             baselines = zeros(1,numStimuIntDefs);
%             ads = zeros(1,numStimuIntDefs);
%             other = zeros(1,numStimuIntDefs);
%             clips = zeros(1,numStimuIntDefs);
%             for i=1:numStimuIntDefs
%                 Stimu = stimuIntDefs{i};
%                 if (contains(Stimu.stimuIntDescrp,'EDA Baseline'))
%                     baselines(i) = i;
%                 elseif (contains(Stimu.stimuIntDescrp,'TV Commercial'))
%                     ads(i) = i;
%                 elseif (contains(Stimu.stimuIntDescrp,'TV Programm'))
%                     clips(i) = i;
%                 else
%                     other(i) = i;
%                 end
%             end
%             baselines = baselines(baselines~=0);
%             ads = ads(ads~=0);
%             other = other(other~=0);
%             clips = clips(clips~=0);
%         end
    end
    
end
