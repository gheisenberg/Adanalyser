% Performs filter calculation steps
%   Starts when button "Filter" was clicked
%   Analysis quality and filters subjects
%   Plots quality figures
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
                    %calculate eeg and eda values per StimulusInterval
                    edaValuesPerStim = self.getValuesPerStimuInt(1,edaValsPerSec,data.stimuIntDefs,subject.edaValues);
                    eegValuesPerStim = self.getValuesPerStimuInt(1,eegValsPerSec,data.stimuIntDefs,rawList);
                    filteredEEGValuesPerVid = self.getValuesPerStimuInt(1,eegValsPerSec,data.stimuIntDefs,filteredList);
                    subject.edaPerVid = edaValuesPerStim;
                    eegValues.filteredEEGPerVid = filteredEEGValuesPerVid;
                    subject.eegValuesForElectrodes{j} = eegValues;
                    if (eegValues.electrode == Electrodes.FZ)
                        for v=1:numStimuInt
                            unfilteredEEGVid = eegValuesPerStim{v};
                            filteredEEGVid = filteredEEGValuesPerVid{v};
                            unfilteredQuality(i,v) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,unfilteredEEGVid);
                            filteredQuality(i,v) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,filteredEEGVid);
                        end
                    end
                end
                data.subjects{i} = subject;
                waitbar(i/numSubjects);
            end
            close(h);
            % rate quality
            [data.subjects,validStimuIntPerSubject,validSubjects] = self.rateQuality(data.subjects,filteredQuality,data.stimuIntDefs,config.QualityIndex);
            % plot quality figures

%           Kreitzberg: Commented out; Reason go to Plotter.m
%           plotEEGQualityFigures()

%             if (config.QualityFig)
%                 self.plotter.plotEEGQualityFigures(unfilteredQuality,filteredQuality,validStimuIntPerSubject,validSubjects,data.stimuIntDefs,config,numSubjects);
%             end
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
                eegStimuIntLength = double(curVid.length*valuesPerSec);
                eegStimuIntEnd = StimuIntStart+eegStimuIntLength-1;
                splittedValues{v} = values(StimuIntStart:eegStimuIntEnd);
                StimuIntStart = StimuIntStart+eegStimuIntLength;
            end
        end
        
        %% Calculates valid StimulusInterval per subject regarding the relevant StimulusInterval types
        %   Stores number of valid StimulusInterval for each subject and StimulusInterval type in _qualityIndex_
        %   Calculates total number of valid StimulusInterval See: _totalValidStimuInt_
        %   Sets isValid flag for each Subject
        function [subjects,qualityIndex,totalValidStimuInt] = rateQuality(self,subjects,quality,stimuIntDefs,qualityThreshold) %Tim ID 9 -> hier werden die invalid subjects gefiltert - kann unterbunden werden wenn gewollt
            StimuInt = length(stimuIntDefs);
            numSubjects = length(subjects);
            [baselines,ads,other,clips] = self.getStimuIntIndiciesByType(stimuIntDefs);
            qualityIndex = zeros(numSubjects,3);
            for i = 1:numSubjects
                for j = 1:length(clips)
                    if quality(i,clips(j)) < qualityThreshold
                        qualityIndex(i,3) = qualityIndex(i,3)+1;
                    end
                end
                for j = 1:length(ads)
                    if quality(i,ads(j)) < qualityThreshold
                        qualityIndex(i,2) = qualityIndex(i,2)+1;
                    end
                end
                for j = 1:length(baselines)
                    if quality(i,baselines(j)) < qualityThreshold
                        qualityIndex(i,1) = qualityIndex(i,1)+1;
                    end
                end
            end
            validStimuIntPerSubject = sum(qualityIndex,2);
            numRelevantStimuInts = StimuInt - length(other);
            totalValidStimuInt = length(find(validStimuIntPerSubject >= numRelevantStimuInts));
            for i=1:numSubjects
                numValidStimuIntsForSubject = validStimuIntPerSubject(i);
                if (numValidStimuIntsForSubject >= numRelevantStimuInts)
                    subjects{i}.isValid = 1;
                end
            end
        end
        
        %% Splits given StimuIntDef based on there SimulationsInterval
        %   Returns StimulusIntervals by their SimulationsInterval
        function [baselines,ads,other,clips]= getStimuIntIndiciesByType(self,stimuIntDefs)
            numStimuIntDefs = length(stimuIntDefs);
            baselines = zeros(1,numStimuIntDefs);
            ads = zeros(1,numStimuIntDefs);
            other = zeros(1,numStimuIntDefs);
            clips = zeros(1,numStimuIntDefs);
            for i=1:numStimuIntDefs
                Stimu = stimuIntDefs{i};
                if (contains(Stimu.stimuIntDescrp,'EDA Baseline'))
                    baselines(i) = i;
                elseif (contains(Stimu.stimuIntDescrp,'TV Commercial'))
                    ads(i) = i;
                elseif (contains(Stimu.stimuIntDescrp,'TV Programm'))
                    clips(i) = i;
                else
                    other(i) = i;
                end
            end
            baselines = baselines(baselines~=0);
            ads = ads(ads~=0);
            other = other(other~=0);
            clips = clips(clips~=0);
        end
    end
    
end
