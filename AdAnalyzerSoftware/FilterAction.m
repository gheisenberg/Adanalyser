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
            hrvValsPerSec = hrvDevice.samplingRate;
            unfilteredQuality = zeros(numSubjects,numStimuInt);
            filteredQuality = zeros(numSubjects,numStimuInt);
            % loop for each subject
            for i=1:numSubjects
                subject = data.subjects{i};
                
                % create folder for each subject
                parentfolder = config.OutputDirectory;
                subfolder_name = subject.name;
                mkdir(fullfile(parentfolder, subfolder_name));
                
                % change directory to subject folder
                subject.OutputDirectory = [parentfolder '\' subfolder_name];
                
                if subject.isValid == 1 % Filter invalid subjects
                numElectrodes = length(subject.eegDataPerElectrode);
                
                %loop for each electrode position
                for j=1:numElectrodes
                    eegDataPerElectrode = subject.eegDataPerElectrode{j};
                    rawMatrix = eegDataPerElectrode.eegMatrix;
                    [seconds,eegValsPerSec] = size(rawMatrix);
                    rawList = self.buildRawList(seconds,eegValsPerSec,rawMatrix);
                    % eegfiltfft is a eeglab function for (high|low|band) - 
                    % pass filter data using inverse fft - for more
                    % information please look at eegfiltfft.m
                    eegBandPassed = eegfiltfft(rawList,eegValsPerSec,1,49);
                    %calculate the percent outside and 
                    percentOutside(1) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,rawList);
                    percentOutside(2) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,eegBandPassed);
                    if (config.EEG_DEVICE_USED)
                        self.plotter.plotRawEEGFigures(rawList,eegBandPassed,percentOutside,subject,eegDataPerElectrode.electrode,config);
                    end
                    % calculate eeg values per Stimulus Interval
                    eegBandPassedPerStim = self.getValuesPerStimuInt(1,eegValsPerSec,data.stimuIntDefs,eegBandPassed); 
                    eegDataPerElectrode.eegPerStim = eegBandPassedPerStim;
                    % save EGG Values in vector to write out csv
                    eegAllValues(j,:) = eegBandPassed';
                    eegDataPerElectrode.eegValues = eegBandPassed';
                    subject.eegDataPerElectrode{j} = eegDataPerElectrode;
                    % Rate Quality for EEG Electrode
                    for v = 1:numStimuInt
                        filteredEEGStim = eegBandPassedPerStim{v};
                        filteredQuality(i,v) = self.getPercentQutside(config.LowerThreshold,config.UpperThreshold,filteredEEGStim); % vector will be to big, because it was used for the function "quality figures", which is deactivated 
                    end
                    
                    % save eegValues averaged over all electrodes
                    subject.eegData.eegValues = self.calculateMeanEEGValuesForStimuInt(eegDataPerElectrode);
                    % sub by 4
                    subject.eegData.eegValuesSubedBy4 = self.singleSubsampleByFactorOf4(subject.eegData.eegValues,eegDevice);
                    
                    % rate quality of each Stimulus Interval
                    subject = self.rateQuality(subject,filteredQuality,config,j);
                    % calculate eda values per StimulusInterval
                    edaValuesPerStim = self.getValuesPerStimuInt(1,edaValsPerSec,data.stimuIntDefs,subject.edaValues);
                    subject.edaPerStim = edaValuesPerStim;
                    % calculate hrv values per StimulusInterval
                    hrvValuesPerStim = self.getValuesPerStimuInt(1,hrvValsPerSec,data.stimuIntDefs,subject.hrvValues);
                    subject.hrvPerStim = hrvValuesPerStim;
                end
                
                % check for flag in config and prints out EEG Data 
                if config.EEGData == 1
                    % calculate time and add labels to timeseries
                    time = 0:1/eegDevice.samplingRate:seconds;
                    time = ["Time [s]",time(2:end)];
                    output = [config.electrodes' num2cell(eegAllValues)];
                    % combine
                    output = [time; output];
                    fname = [subject.OutputDirectory '/' subject.name '__1to49HzBandpassFiltered_EEG_RAW_Values_PerElectrode.csv'];
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
                
                % create data for EEG Topology plots, if necessary 
                if config.topoplot == 1 || config.brainactivity == 1
                    % Preparing EEG Data for print
                    % Import of Standard 10-20 System channel locs for electrodes
                    load Standard-10-20-Cap81.mat;

                    % Data preparation
                    Usedelectrodes = config.electrodes;
                    numElectrodes = length(subject.eegDataPerElectrode);
                    lenghtSignal = length(subject.eegDataPerElectrode{1,1}.eegValues);
                    ValuesEEG = zeros(lenghtSignal,numElectrodes);
                    for j = 1:numElectrodes              
                        ValuesEEG(:,j) =  subject.eegDataPerElectrode{1, j}.eegValues;              
                    end
                    PlotDataOverTime = ValuesEEG';

                    % needed variables for chanloc preparation
                    chanloc = Chanloc; % get Chanloc included in Standard-10-20-Cap81.mat
                    electrodes = Usedelectrodes'; % transfrom vector
                    numUsedElectrodes = length(electrodes);
                    lengthStandardChanloc = length(Chanloc);
                    SumDeleteRow = zeros(1,lengthStandardChanloc);

                    % delete all unused electrode chanlocs
                    for j = 1:numUsedElectrodes
                        deleteRow = ismember({chanloc.labels}, electrodes{j});
                        SumDeleteRow = SumDeleteRow + deleteRow;
                    end
                    SumDeleteRow = ~SumDeleteRow;
                    % delete the unused rows
                    chanloc(SumDeleteRow) = [];

                    % Create EEG Structur which is used in Topology plot of
                    % EEGLab libary
                    EEG.data = PlotDataOverTime;        % data array (chans x frames x epochs)
                    EEG.setname = subject.name;         % Set name = Number of subject
                    EEG.chanlocs = chanloc;             % name of file containing names and positions of the channels on the scalp
                    EEG.nbchan = length(EEG.chanlocs);  % number of channels in each epoch
                    EEG.pnts = length(EEG.data);        % number of frames (time points) per epoch (trial)
                    EEG.trials = 1;                     % number of epochs (trials) in the dataset (Allways 1 for now)
                    EEG.srate = eegDevice.samplingRate; % sampling rate (in Hz)
                    EEG.xmin = 0;                       % epoch start time (in seconds)
                    EEG.xmax = (EEG.pnts-1)/EEG.srate;  % epoch end time (in seconds)
                    
                    subject.EEG = EEG;
                end
          
                data.subjects{i} = subject;
                waitbar(i/numSubjects);
                end       
            end
           
            % plot tabel with in/valid Status of Subjects
            self.subjectValid(data.subjects,config);
            
            close(h);
        end
    
        %% Print in/valid subject table        
        function subjectValid(self,subject,config)
            numSubjects = length(subject);
            validString = cell(length(subject)+3,1); % +3 for Header
            validString(1) = {'Overview of subjects and their EEG status'};

            j = 1;
            isValid = 0;
            % loop to check if subject is in/valid
            for i=1:numSubjects 
               sub = subject{i};
               if sub.isValid == 1
                   isValid = isValid+1;
                   % save subject as valid
                   validString(i+3) = {['EEG Values for subject   |   ' sub.name '   |   valid ']};
                   j = j+1;
                   % check for invalid electrodes and save them behind the
                   % subject
                   if  ~isempty(sub.invalidElectrodes)
                       validString(i+3) = strcat(validString(i+3),'  |  Invalid electrodes  |',{' '});
                       for j = 1:length(sub.invalidElectrodes)
                       validString(i+3) = strcat(validString(i+3),{' '},sub.invalidElectrodes(j)); 
                       end
                   end
               else 
                   % save subject as invalid
                   validString(i+3) = {['EEG Values for subject   |   ' sub.name '   |   invalid |']};
                   isValid = isValid + 0;
                   if  length(sub.invalidElectrodes) >= 1 
                       validString(i+3) = strcat(validString(i+3),'  |  Invalid electrodes  |',{' '});
                       for j = 1:length(sub.invalidElectrodes)
                       validString(i+3) = strcat(validString(i+3),{' '},sub.invalidElectrodes(j)); 
                       end   
                   end
               end
            end
            % Add string with summary of the subject table
            validString(2) = {[num2str(num2str(isValid)) ' of ' num2str(numSubjects) ' subjects are valid']};
            self.plotter.writeValid(validString, [config.OutputDirectory '/' 'Subject_Valid_Overview.pdf']);

            if isValid == 0
                fprintf('\n\nNo valid subject found!\n\n');
            end
        end
        
        %% reduces the sampling frequency of the given eeg signals per Stimulus by a factor of 4
        % change version of subsampleByFactorOf4() to sub sample a single
        % data object
        function data_s = singleSubsampleByFactorOf4(self,data,eegDevice)
            factor = 4;
            numStimuInt = length(data);
            reducedSamplingRate = double(eegDevice.samplingRate/factor);
            data_s = cell(1,numStimuInt);
            
            for j = 1:numStimuInt
                dataPerStimu = data{1,j};
                reducedSignalLength = length(dataPerStimu)/(reducedSamplingRate); 
                % initialize reduced signals by 0 
                % _s may stand for "short" since the signal vectors 
                % are shorter now
                dataPerStimu_s = zeros(1,reducedSignalLength);

                % now fill the old signals into the shorter vectors by
                % subsampling them
                for i = 1:reducedSignalLength
                    % Build mean value between upper and lower bound for 
                    % every frequency_band for subsampling the signal, hence reducing the resolution
                    lower_bound = (i-1)*(reducedSamplingRate)+1;
                    upper_bound = (i-1)*(reducedSamplingRate)+(reducedSamplingRate);

                    dataPerStimu_s(i) = mean(dataPerStimu(lower_bound:upper_bound));
                end
                data_s{j} = dataPerStimu_s;
            end
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
        
        %% Calcualtes the mean Value of the EEG for each Stimulus/Subject
        function meanEEGPerStim = calculateMeanEEGValuesForStimuInt(self,eegData)
            numElectrodes = length(eegData);
            numStimuInt = length(eegData.eegPerStim);
            meanEEGPerStim = cell(1,numStimuInt);
            % cycle through Simulus Intervals and electrodes
            for i = 1:numStimuInt
                meanEEGPerStim{i} = eegData.eegPerStim{i};
                for j = 2:numElectrodes
                    valuesForElectrode = data.eegDataPerElectrode{j}.eegPerStim{i}; 
                    previousValues = meanEEGPerStim{i}; 
                    meanEEGPerStim{i} = previousValues+valuesForElectrode;
                end
                numValues = length(meanEEGPerStim{i});
                for j = 1:numValues
                    meanEEGPerStim{i}(j) = meanEEGPerStim{i}(j)/numElectrodes;
                end
            end
        end
        
        %% Stores invalid Electrodes in subject
        %   Sets isValid flag for each Electrode based on used qualityThreshold
        function subjects = rateQuality(self,subjects,quality,config,electrode) 
            qualityThreshold = config.QualityIndex;
            if any(quality > qualityThreshold)
                    subjects.invalidElectrodes{end+1} = config.electrodes{electrode};
            end
        end
    end
    
end
