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
        %   3. calculates eeg and eda values per video
        %   4. rates qualiyt
        %   5. plots eeg quality figures using _Plotter_
        function data = filter(self,data,config)
            message = ['Filtering data for ', num2str(length(data.subjects)), ' subject(s)'];
            h = waitbar(0,message);
            numVideos = length(data.videoDefs);
            numSubjects = length(data.subjects);
            edaValsPerSec = 5;
            %edaValsPerSec = edaDevice.samplingRate;
            unfilteredQuality = zeros(numSubjects,numVideos);
            filteredQuality = zeros(numSubjects,numVideos);
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
                        self.plotter.plotRawEEGFigures(rawList,filteredList,percentOutside,subject.name,eegValues.electrode,config);
                    end
                    %calculate eeg and eda values per video
                    edaValuesPerVid = self.getValuesPerVideo(1,edaValsPerSec,data.videoDefs,subject.edaValues);
                    eegValuesPerVid = self.getValuesPerVideo(1,eegValsPerSec,data.videoDefs,rawList);
                    filteredEEGValuesPerVid = self.getValuesPerVideo(1,512,data.videoDefs,filteredList);
                    subject.edaPerVid = edaValuesPerVid;
                    eegValues.filteredEEGPerVid = filteredEEGValuesPerVid;
                    subject.eegValuesForElectrodes{j} = eegValues;
                    if (eegValues.electrode == Electrodes.FZ)
                        for v=1:numVideos
                            unfilteredEEGVid = eegValuesPerVid{v};
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
            [data.subjects,validVideosPerSubject,validSubjects] = self.rateQuality(data.subjects,filteredQuality,data.videoDefs,config.QualityIndex);
            % plot quality figures
            if (config.QualityFig)
                self.plotter.plotEEGQualityFigures(unfilteredQuality,filteredQuality,validVideosPerSubject,validSubjects,data.videoDefs,config,numSubjects);
            end
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
        
        %% Splits given values per video using given videoDefs and video start point
        function splittedValues = getValuesPerVideo(self,videoStart,valuesPerSec,videoDefs,values)
            numVideos = length(videoDefs);
            splittedValues = cell(1,numVideos);
            for v=1:numVideos
                curVid = videoDefs{v};
                eegVideoLength = double(curVid.length*valuesPerSec);
                eegVideoEnd = videoStart+eegVideoLength-1;
                splittedValues{v} = values(videoStart:eegVideoEnd);
                videoStart = videoStart+eegVideoLength;
            end
        end
        
        %% Calculates valid videos per subject regarding the relevant video types
        %   Stores number of valid videos for each subject and video type in _qualityIndex_
        %   Calculates total number of valid video See: _totalValidVideo_
        %   Sets isValid flag for each Subject
        function [subjects,qualityIndex,totalValidVideo] = rateQuality(self,subjects,quality,videoDefs,qualityThreshold)
            videos = length(videoDefs);
            numSubjects = length(subjects);
            [baselines,ads,other,clips] = self.getVideoIndiciesByType(videoDefs);
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
            validVideosPerSubject = sum(qualityIndex,2);
            numRelevantVideos = videos - length(other);
            totalValidVideo = length(find(validVideosPerSubject >= numRelevantVideos));
            for i=1:numSubjects
                numValidVideosForSubject = validVideosPerSubject(i);
                if (numValidVideosForSubject >= numRelevantVideos)
                    subjects{i}.isValid = 1;
                end
            end
        end
        
        %% Splits given videoDefs based on there _VideoType_
        %   Returns videos by _VideoType_
        function [baselines,ads,other,clips]= getVideoIndiciesByType(self,videoDefs)
            numVideoDefs = length(videoDefs);
            baselines = zeros(1,numVideoDefs);
            ads = zeros(1,numVideoDefs);
            other = zeros(1,numVideoDefs);
            clips = zeros(1,numVideoDefs);
            for i=1:numVideoDefs
                vid = videoDefs{i};
                if (vid.videoType==VideoType.EEGBaseline)
                    baselines(i) = i;
                elseif (vid.videoType==VideoType.TVCommercial)
                    ads(i) = i;
                elseif (vid.videoType==VideoType.TVProgramm)
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
