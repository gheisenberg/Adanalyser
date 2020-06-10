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
        %   5. plots eeg quality figures using _Plotter_
        function data = filter(self,data,config,eegDevice,edaDevice,hrvDevice)
            message = ['Filtering data for ', num2str(length(data.subjects)), ' subject(s)'];
            h = waitbar(0,message);
            numStimuInt = length(data.stimuIntDefs);
            numSubjects = length(data.subjects);            
            edaValsPerSec = edaDevice.samplingRate;
            eegValsPerSec = eegDevice.samplingRate;            
            unfilteredQuality = zeros(numSubjects,numStimuInt);
            filteredQuality = zeros(numSubjects,numStimuInt);
            for i=1:numSubjects
                subject = data.subjects{i}; 
                if subject.isValid == 1 %Filter invalid subjects
                numElectrodes = length(subject.eegValuesForElectrodes);               
                for j=1:numElectrodes
                    eegValues = subject.eegValuesForElectrodes{j};
                    rawMatrix = eegValues.eegMatrix;
                    [seconds,eegValsPerSec] = size(rawMatrix);
                    rawList = self.buildRawList(seconds,eegValsPerSec,rawMatrix);
                    filteredList = eegfiltfft(rawList,eegValsPerSec,1,49);
                    percentOutside(1) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,rawList);
                    percentOutside(2) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,filteredList);
                    if (config.EEG_DEVICE_USED)
                        self.plotter.plotRawEEGFigures(rawList,filteredList,percentOutside,subject,eegValues.electrode,config);
                    end
                    %calculate eeg values per StimulusInterval
                    eegValuesPerStim = self.getValuesPerStimuInt(1,eegValsPerSec,data.stimuIntDefs,rawList);
                    filteredEEGValuesPerVid = self.getValuesPerStimuInt(1,eegValsPerSec,data.stimuIntDefs,filteredList); %Tim 
                    eegValues.filteredEEGPerVid = filteredEEGValuesPerVid;
                    eegValues.eegValues = filteredList';
                    subject.eegValuesForElectrodes{j} = eegValues;
                    %Rate Quality for EEG Electrode
                    for v=1:numStimuInt
                        unfilteredEEGVid = eegValuesPerStim{v};
                        filteredEEGVid = filteredEEGValuesPerVid{v};
                        %unfilteredQuality(i,v) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,unfilteredEEGVid);
                        filteredQuality(i,v) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,filteredEEGVid);
                    end
                    % rate quality
                    subject = self.rateQuality(subject,filteredQuality,data.stimuIntDefs,config.QualityIndex);
                    %calculate eda values per StimulusInterval
                    edaValuesPerStim = self.getValuesPerStimuInt(1,edaValsPerSec,data.stimuIntDefs,subject.edaValues);
                    subject.edaPerVid = edaValuesPerStim;
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
            for j=1:seconds
                column=rawMatrix(j,:);
                m=mean(column);
                rawMatrix(j,:) = column-m;
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
            for v=1:numStimuInt
                curVid = stimuIntDefs{v};
                eegStimuIntLength = double(curVid.Stimulength*valuesPerSec);
                eegStimuIntEnd = StimuIntStart+eegStimuIntLength-1;
                splittedValues{v} = values(StimuIntStart:eegStimuIntEnd);
                StimuIntStart = StimuIntStart+eegStimuIntLength;
            end
        end
        
        %% Calculates valid StimulusInterval per subject regarding the relevant StimulusInterval types
        %   Stores number of valid StimulusInterval for each subject and StimulusInterval type in _qualityIndex_
        %   Calculates total number of valid StimulusInterval See: _totalValidStimuInt_
        %   Sets isValid flag for each Subject
        function subjects = rateQuality(self,subjects,quality,stimuIntDefs,qualityThreshold) 
            numStimuInts = length(stimuIntDefs);
            if sum(any(quality < qualityThreshold)) == numStimuInts
                subjects.validElectrodes
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
