% Performs analysis steps for valid subjects
%   Starts when button "Analyse" was clicked
%   Performs eeg frequency analysis
%   Calculates statistics
%   Plots 2D Topology Maps with video
%   Plots 2D Topology Overview chart
%   Plots eda figures, eeg frequency figures
%   Calculates statistics
%
% Author: Gernot Heisenberg, Tim Kreitzberg
%
classdef AnalyseAction < handle
    
    properties
        plotter = Plotter;
        stringStatistics = StringStatistics;
    end
    
    methods
        %% Main function of this class
        %   Performs "Analyse" calculation step for all valid subjects
        %   and initialize the AnalyseSubject function
        function analyse(self,data,config,eegDevice,edaDevice,hrvDevice)
            subjects = data.subjects;
            StimuIntDefs = data.stimuIntDefs;
            validSubjects = self.countValidSubjects(subjects);
            message = ['Analysing data for ' num2str(validSubjects) ' valid subject(s)'];
            wBar = waitbar(0,message);
                        
            % plot the a file as pdf containing all the GUI and all DEVICE settings
            self.plotter.writeSettings(config,eegDevice,edaDevice,hrvDevice,[config.OutputDirectory,'/Settings.pdf']); 
            
            % plot the a file as pdf containing all the ADIndex settings
            self.plotter.writeAdIndex(StimuIntDefs,[config.OutputDirectory,'/AdIndex.pdf']);
            
            for indexSubject = 1:length(subjects)
                subject = subjects{indexSubject};
                if subject.isValid == 1 % Filter invalid subjects
                    self.analyseSubject(subject,StimuIntDefs,config,eegDevice,edaDevice,hrvDevice);
                end      
                waitbar(indexSubject/validSubjects);
                fprintf('\n');
            end
            close(wBar);
        end
        
        %% Counts valid subjects
        %   subjects: subject class with all nessesary information
        function numValidSubjects = countValidSubjects(self,subjects)
            numValidSubjects = 0;
            for indexSubject = 1:length(subjects)
                if (subjects{indexSubject}.isValid)
                    numValidSubjects = numValidSubjects+1;
                end
            end
        end   
    end
    methods(Access=private)
        %% Performs analysis of the data of each subject
        % Main function of the AdAnalyser
        %   subject: information about the current subject
        %   StimuIntDefs: information about all Stimulus Intervals
        %   config: information on the choosen config of the user
        %   devices: information of the used devices
        function analyseSubject(self,subject,StimuIntDefs,config,eegDevice,edaDevice,hrvDevice)
            
            numStimuInt = length(StimuIntDefs);
            numElectrodes = length(subject.eegDataPerElectrode);
            
            % get index of Stimlus Type 0, 1, 4, 5 and 6 - see StimuIntDefinition.m
            edaIndex = self.getStimuIntIndex([0,1,4,5,6],StimuIntDefs);
            
            % get index of Stimlus Type > 4 - see StimuIntDefinition.m
            StimulusIndex = self.getStimuIntIndex([4,5,6],StimuIntDefs);
            
            % prepare data for plots using power signals
            for indexStimu = 1:numStimuInt
                [delta,theta,alpha,beta1,beta2,task] = self.filterSpectrumBands(subject.eegData.eegValues{indexStimu},eegDevice);
                subject.eegData.eegSpecBand(indexStimu,:) = {delta,theta,alpha,beta1,beta2,task};

                % Reduce signal resolution by a factor of 4 (subsampling)
                % the benefit is that the signals can be plotted much faster !?
                % and the signals look much smoother
                % It seems they are JUST used for plotting the Theta, Alpha,
                % "Beta1, Beta2 frequencies and TEI" plots
                % (e.g. the "Behavioral Characteristics" plot uses the original
                % signal frequencies (see below)
                [delta_s,theta_s,alpha_s,beta1_s,beta2_s,task_s] = self.subsampleByFactorOf4(delta,theta,alpha,beta1,beta2,task,eegDevice);
                subject.eegData.eegSpecBandSubedBy4(indexStimu,:) = {delta_s,theta_s,alpha_s,beta1_s,beta2_s,task_s};

                % save signal spectra for each electrode
                for indexEEG = 1:numElectrodes 
                   [delta_e,theta_e,alpha_e,beta1_e,beta2_e,task_e] = self.filterSpectrumBands(subject.eegDataPerElectrode{indexEEG}.eegPerStim{indexStimu},eegDevice);
                   subject.eegDataPerElectrode{indexEEG}.eegSpecBandPerStim(indexStimu,:)= {delta_e,theta_e,alpha_e,beta1_e,beta2_e,task_e};
                end
            end
                        
            % generate power signal csv
            if config.signalSpec == 1 
                self.SignalBandCSV(subject,StimuIntDefs,eegDevice)
            end
            
            % generate different stat matrix
            [statsMat,edaStatsCell] = self.createStatsMat(subject,StimuIntDefs,edaDevice,edaIndex);
            
            % Plot statistics
            if (config.Statistics)
                % save statistics as pdf and CSV
                self.plotter.writeCSV([subject.OutputDirectory '/' subject.name '_statistics_EEG_EDA_HRV.csv'],'%s;%s;%s;%s;%s;%s;%s;%s;%s\n',statsMat');
            end
            
            % plot Behavioral Characteristics for each Stimulus Interval
            if(config.BehaveFig)
                for StimuIntIndex = 1:numStimuInt
                    self.plotter.plotBehavioralCharacteristics(subject.name,subject.OutputDirectory,subject.eegData.eegSpecBand(StimuIntIndex,:),StimuIntDefs{StimuIntIndex},eegDevice)
                end
            end

            % Plot Recurrence for EDA data
            if (config.EDARecurrence)
                self.plotter.plotEDARecurrence(subject,config,StimuIntDefs,subject.edaValues,edaDevice);
            end
            
            % Plot eda values
            if (config.EDA_DEVICE_USED)
                self.plotter.plotEDA(StimuIntDefs,[subject.OutputDirectory,'/' subject.name '_EDA','.pdf'],subject.edaValues,0);
            end
            
            % Plot eda detrended
            if (config.DetrendedEDAFig)
                self.plotter.plotEDA(StimuIntDefs,[subject.OutputDirectory,'/' subject.name '_EDA_detrend','.pdf'],detrend(subject.edaValues),1);
            end
             
            % Plot 2D Topology Map
            if config.topoplot == 1 
                self.plotter.printTopo(config,subject,StimuIntDefs);
            end
                        
            % Plot Brain Activity Plot
            if config.brainactivity == 1
                self.plotter.stimulusOverviewChart(config,subject,StimuIntDefs,StimulusIndex);
            end
            
            % Plot subStimuIntEDA
            % edaStatsCell = {edaStatsString, delayString, ampString}
            if (config.SubStimuIntEDAFig)
                self.plotter.plotSubStimuIntEDA(edaIndex,subject.edaPerStim,StimuIntDefs,subject.name,[subject.OutputDirectory '/' subject.name ' EDA_Values_for_all_StimulusInterval(s)'],[edaStatsCell{1} newline newline edaStatsCell{2} newline edaStatsCell{3}]);
            end
            
            % Plot HRV figure
            if (config.HRV_DEVICE_USED)
                self.plotter.plotHRV(subject.hrvValues,subject.OutputDirectory,subject.name,StimuIntDefs);
            end
            
            % Plot HRV Recurrence
            if (config.HRVRecurrence)
                self.plotter.plotHRVRecurrence(subject,config,'HRV',subject.hrvValues,StimuIntDefs);
            end
            
            % plot frequencies for baseline Stimulus Intervals with baseline magnitude
            if (config.FrequencyFig)
                StimuIntTypes = zeros(1,length(StimuIntDefs));
                % get Stimulus Interval Types
                for indexStimu = 1:length(StimuIntDefs)
                    StimuIntTypes(indexStimu) = StimuIntDefs{1, indexStimu}.stimuIntType;
                end
                
                % get frequencies for baseline
                BaselineIndexEEG = find(StimuIntTypes == 2,1); % Type 2 == EEG Baseline
                [~,baselineTheta_s,baselineAlpha_s,baselineBeta1_s,baselineBeta2_s,baselineTEI_s] = subject.eegData.eegSpecBandSubedBy4{BaselineIndexEEG,:};
                
                % calculate EDA Baseline
                BaselineIndexEDA = find(StimuIntTypes == 0); % Type 2 == EEG Baseline
                baseline_EDA = mean(subject.edaPerStim{1,BaselineIndexEDA});
                baseline_HRV = mean(subject.hrvPerStim{1,BaselineIndexEDA});
                
                % get all indices for Stimulus_Interval_Types >= 4
                % see StimuIntDefinition.m
                StimulIndex = find(StimuIntTypes >= 4);
                
                for indexStimu = StimulIndex    
                    [~,StimuIntTheta_s,StimuIntAlpha_s,StimuIntBeta1_s,StimuIntBeta2_s,StimuIntTEI_s] = subject.eegData.eegSpecBandSubedBy4{indexStimu,:};
                    intervals = StimuIntDefs{indexStimu}.intervals;
                    StimuIntDescrp = StimuIntDefs{indexStimu}.stimuIntDescrp;
                    
                    self.plotter.plotFrequencysWithBaselineMagnitude(subject.edaPerStim{indexStimu},subject.hrvPerStim{indexStimu},...
                        length(subject.eegDataPerElectrode{1}.eegPerStim{indexStimu})/eegDevice.samplingRate,...
                        [subject.OutputDirectory '/' subject.name '_alpha_beta_theta_TEI_' StimuIntDescrp '.pdf'],...
                        StimuIntTheta_s,StimuIntAlpha_s,StimuIntBeta1_s,StimuIntBeta2_s,StimuIntTEI_s,baselineTheta_s,...
                        baselineAlpha_s,baselineBeta1_s,baselineBeta2_s,baselineTEI_s,baseline_EDA,baseline_HRV,...
                        intervals,['Theta, Alpha, Beta1, Beta2 frequencies and TEI for ' StimuIntDescrp ' of subject ' subject.name]);
                end
            end
            % transient = self.frequencyEstimation(edaComplete); obsolet
            % self.plotter.plotMomentaryFrequency(transient,config,subject,stimuIntDef)
            
        end
      
        %% Performs analysis for every StimulusInterval of each subject
        function StimuIntStatsMat = createStimStatsMat(self,StimuIntIndex,meanEEGPerStim,StimuIntDefs,frequencies)
            % Calculate eeg statistics for every StimulusInterval
            StimuIntDef = StimuIntDefs{StimuIntIndex};
            StimuIntStatsMat = cell(1,9);
            StimuIntStatsMat(1,1) = {['EEG statistics for ' StimuIntDef.stimuIntDescrp]};
            [delta,theta,alpha,beta1,beta2,task] = frequencies{:};
            
            % Calculate eeg statistics for each StimulusInterval and each frequency
            eegFreqStatsMat = self.calculateEEGFrequencyStatistics(meanEEGPerStim{StimuIntIndex},delta,theta,alpha,beta1,beta2,task);
            StimuIntStatsMat = vertcat(StimuIntStatsMat,eegFreqStatsMat);      
        end
     
        %% Calcualtes the mean Value of the EEG for each Stimulus/Subject
        function meanEEGPerStim = calculateMeanEEGValuesForStimuInt(self,subject)
            numElectrodes = length(subject.eegDataPerElectrode);
            eegForElectrode = subject.eegDataPerElectrode{1};
            numStimuInt = length(eegForElectrode.eegPerStim);
            meanEEGPerStim = cell(1,numStimuInt);
            % cycle through Simulus Intervals and electrodes
            for indexStimu = 1:numStimuInt
                meanEEGPerStim{indexStimu} = eegForElectrode.eegPerStim{indexStimu};
                for indexElec = 2:numElectrodes
                    valuesForElectrode = subject.eegDataPerElectrode{indexElec}.eegPerStim{indexStimu}; 
                    previousValues = meanEEGPerStim{indexStimu}; 
                    meanEEGPerStim{indexStimu} = previousValues+valuesForElectrode;
                end
                numValues = length(meanEEGPerStim{indexStimu});
                for indexValues = 1:numValues
                    meanEEGPerStim{indexStimu}(indexValues) = meanEEGPerStim{indexStimu}(indexValues)/numElectrodes;
                end
            end
        end
        
        %% Method calculates mean of values and standard derivation, max, min for detrended values
        %   Used to create statistics
        function [m,sd,devP,devM] = calculateStatistics(self,values)
            m = mean(values);
            detrended = detrend(values);
            sd = std(detrended);
            devP = max(detrended);
            devM = min(detrended);
        end
        
        %% Calculates staticstics for the different eeg frequencies
        %  creates and returns StatsMat cell array
        function statsMat = calculateEEGFrequencyStatistics(self,eeg,delta,theta,alpha,beta1,beta2,task)
            statsMat = cell(7,9);
            [m,sd,devP,devM] = self.calculateStatistics(eeg);
            statsMat(1,1:5) = {'EEG',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            [m,sd,devP,devM] = self.calculateStatistics(delta);
            statsMat(2,1:5) = {'EEG delta',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            [m,sd,devP,devM] = self.calculateStatistics(theta);
            statsMat(3,1:5) = {'EEG theta',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            [m,sd,devP,devM] = self.calculateStatistics(alpha);
            statsMat(4,1:5) = {'EEG alpha',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            [m,sd,devP,devM] = self.calculateStatistics(beta1);
            statsMat(5,1:5) = {'EEG beta 1',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            [m,sd,devP,devM] = self.calculateStatistics(beta2);
            statsMat(6,1:5) = {'EEG beta 2',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            [m,sd,devP,devM] = self.calculateStatistics(task);
            statsMat(7,1:5) = {'TEI',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
        end
        
        %% Calculates statistics for eda values including delays (Delta_t) and amplitudes
        %  creates and returns StatsMat cell array % Tim Absprache zu Stats
        function statsMat = calculateEDAStatistics(self,StimuInt,edaValues,delays,amplitudes,StimuIntDefs)
            edaValuesForStimuInt = edaValues(StimuInt);
            numEDAStimuInts = length(edaValuesForStimuInt);
            % create EDA cell array for statistics and enter the data into
            % the array
            statsMat = cell(numEDAStimuInts+4,9);
            statsMat(1,2:5) ={'mean[�S]','sd[�S]','dev-[�S]','dev+[�S]'} ;
            completeEDA = cell2mat(edaValues');
            [m,sd,devP,devM] = self.calculateStatistics(completeEDA);
            statsMat(2,1:5) = {'EDA complete',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            % get Stimlus Type
            index = 1;
            % for loop trough vector, therefor a index counter also needed
            for indexStimu = StimuInt
                StimuIntClass = StimuIntDefs{indexStimu};
                [m,sd,devP,devM] = self.calculateStatistics(edaValuesForStimuInt{index});
                statsMat(index+2,1:5) = {StimuIntClass.stimuIntDescrp,num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
                index = index + 1;
            end
            delaysNotNull = delays(delays~=0);
            amplitudesNotNull = amplitudes(amplitudes~=0);
            indicies = find(delays);
            if isempty(delaysNotNull)
                s= 'No valid peaks found for Delta_t';
                statsMat{end-1,1}= s;
            elseif length(delaysNotNull)==1
                statsMat{end-1,1} = 'Delta_t of EDA Orientation Baseline';
                statsMat{end-1,2} = num2str(delaysNotNull);
            else
                delayMean = mean(delaysNotNull);
                delayVar = var(delaysNotNull);
                minVarDelay = delayMean - min(delaysNotNull);
                maxVarDelay = max(delaysNotNull) - delayMean;
                statsMat(end-1,1:5) = {
                    'Delta_t EDA Orientation Baseline',...
                    ['mean=' num2str(delayMean,'%6.2f') 's'],['var=' num2str(delayVar,'%6.2f') 's'],...
                    ['dev+=' num2str(minVarDelay,'%6.2f') 's'],['dev-=' num2str(maxVarDelay,'%6.2f') 's']
                    };
                numAmplitudes = length(amplitudesNotNull);
                amplitudesAsString = cell(1,numAmplitudes+1);
                amplitudesAsString(1,1) = {['Amplitudes for intervals ' strtrim(strrep(num2str(indicies),'  ',','))]};
                for indexStimu=1:numAmplitudes
                    amplitudesAsString(1,indexStimu+1) = {[num2str(amplitudesNotNull(indexStimu),'%6.2f') '�S']};
                end
                statsMat(end,1:length(amplitudesAsString)) = amplitudesAsString;
            end
        end
        
        %% Calculate HRV statistics
        function statsMat = calculateHRVStatistics(self,StimuIntDef,subject)
            HRVValues = subject.hrvValues;
            numStimuInts = length(StimuIntDef);
            % create HRV cell array for statistics and enter the data into
            % the array
            statsMat = cell(numStimuInts+2,9);
            statsMat(1,2:5) ={'mean[�S]','sd[�S]','dev-[�S]','dev+[�S]'} ;
            [m,sd,devP,devM] = self.calculateStatistics(HRVValues);
            statsMat(2,1:5) = {'HRV complete',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            % for loop trough vector, therefor a index counter also needed
            Start = 1;
            for indexStimu = 1:numStimuInts
                StimuInt = StimuIntDef{indexStimu};
                if indexStimu == 1
                    End = StimuInt.Stimulength;
                else
                    End = StimuInt.Stimulength + Start - 1; %Vector starts a 1 not 0 in Matlab != real seconds, substract the +1 from Start
                end
                [m,sd,devP,devM] = self.calculateStatistics(HRVValues(Start:End));
                Start = End + 1; %for next StimuInt
                statsMat(indexStimu+2,1:5) = {StimuInt.stimuIntDescrp,num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            end
        end      
        %% Calculates eda delays for given intervals
        function [values,delays] = calculateDelaysEDA(self,edaValues,intervals,edaDevice)
            edaValuesDetrend = detrend(edaValues);
            numEDAValues = length(edaValuesDetrend);
            edaPerSec = edaDevice.samplingRate;
            intervals(end+1)= numEDAValues/edaPerSec;
            start = uint32(intervals(1)*1);
            ende = uint32((intervals(2)+5)*1); % end offset (project in next interval)
            offset = 1; % start offset (start 5 datapoints later from interval start)
            valuesBetweenIntervals = edaValuesDetrend(start+offset:ende);
            m = mean (smooth(valuesBetweenIntervals));
            delays = zeros(1,length(intervals));
            values = zeros(1,length(intervals));
            [peak,index] = findpeaks(smooth(valuesBetweenIntervals),'MINPEAKDISTANCE',5,'MINPEAKHEIGHT',(m*120)/100);
            if length(index)>1
                index = index(1); % find(peak == max(peak))
            end
            if length(index)~=1 || max(peak) < 0
                delays(1) = 0;
                values(1) =0;
            else
                pos = start+offset+index;
                delays(1) = double(pos-(intervals(1)*edaPerSec))/edaPerSec;
                values(1) = edaValues(pos);
            end
        end
        %% create Stats Matrix
        function  [statsMat,edaStatsCell] = createStatsMat(self,subject,StimuIntDefs,edaDevice,edaIndex)
            
            numStimuInt = length(StimuIntDefs);
            % EEG statistics
            numElectrodes = length(subject.eegDataPerElectrode); 
            statsMat = cell(4+numElectrodes,9);
            % Mark unvalid subjects in EEG Statistics
            if subject.isValid == 1
                statsMat(1,1) = {['Statistics for subject ' subject.name]};
            elseif subject.isValid == 0
                statsMat(1,1) = {['Statistics for subject ' subject.name ' EEG VALUES INVALID']};
            end
            statsMat(3,1:5) ={'EEG values by electrodes','mean[�V]','sd[�V]','dev-[�V]','dev+[�V]'};
            mMean =0; 
            sdMean =0;
            devPMean = 0; 
            devMMean =0; 
            % create data for each electrode and save in stats matrix
            for indexElec = 1:numElectrodes
                eegDataperElectrode = subject.eegDataPerElectrode{indexElec}; 
                eegComplete = double(eegDataperElectrode.eegValues');
                electrode = eegDataperElectrode.electrode; 
                % Calculate statitics for all eeg values
                [m,sd,devP,devM] = self.calculateStatistics(eegComplete);
                mMean = mMean+m; 
                sdMean = sdMean+sd; 
                devPMean = devPMean+devP;
                devMMean = devMMean+devM;
                statsMat(3+indexElec,1:5) = {[char(electrode) ': '],num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            end
            statsMat(end,1:5) = {'Mean electrode values: ',num2str(mMean/numElectrodes,'%6.4f'),num2str(sdMean/numElectrodes,'%6.4f'),num2str(devMMean/numElectrodes,'%6.4f'),num2str(devPMean/numElectrodes,'%6.4f')}; 
            
            for indexStimu = 1:numStimuInt
                meanEEGPerStim = self.calculateMeanEEGValuesForStimuInt(subject);
                StimuIntStatsMat = self.createStimStatsMat(indexStimu,meanEEGPerStim,StimuIntDefs,subject.eegData.eegSpecBand(indexStimu,:));
                statsMat = vertcat(statsMat,StimuIntStatsMat);
            end
            
            % HRV statistics
            hrvStatsMat = self.calculateHRVStatistics(StimuIntDefs,subject);
            statsMat = vertcat(statsMat,{'HRV statistics','','','','','','','',''});
            statsMat = vertcat(statsMat,hrvStatsMat);            
            
            % EDA statistics
            % get index of Stimulus Type 1 - see StimuIntDefinition.m
            orientingResponseIndex = self.getStimuIntIndex(1,StimuIntDefs);
            [amplitudes,delays] = self.calculateDelaysEDA(subject.edaPerStim{orientingResponseIndex},StimuIntDefs{orientingResponseIndex}.intervals,edaDevice);

            % create EDA stats matrix
            edaStatsMat = self.calculateEDAStatistics(edaIndex,subject.edaPerStim,delays,amplitudes,StimuIntDefs);
            edaStatsMat = vertcat({'EDA statistics','','','','','','','',''},edaStatsMat);
            edaStatsString =   self.stringStatistics.matrixToString(edaStatsMat(1:end-2,:),' | ');
            delayString =  self.stringStatistics.delaysToString(edaStatsMat(end-1,:));
            ampString =  self.stringStatistics.aplitudesToString(edaStatsMat(end,:));
            % save edaStats string for function: plotSubStimuIntEDA
            edaStatsCell = {edaStatsString; delayString; ampString};
            statsMat = vertcat(statsMat,edaStatsMat);
        end
        
        %% Splits eeg data into different frequencies
        function [delta,theta,alpha,beta1,beta2,task] = filterSpectrumBands(self,filteredEEGData,eegDevice)
            EEGsampRate = eegDevice.samplingRate;
            %--------------------- Delta (1-4 Hz)
            delta = sqrt((eegfiltfft(filteredEEGData,EEGsampRate,1,4)).^2);
            %--------------------- Theta(5-7 Hz)
            theta = sqrt((eegfiltfft(filteredEEGData,EEGsampRate,5,7)).^2);
            %--------------------- Alpha(8-13 Hz)
            alpha = sqrt((eegfiltfft(filteredEEGData,EEGsampRate,8,13)).^2);
            %--------------------- Beta1(14-24 Hz)
            beta1 = sqrt((eegfiltfft(filteredEEGData,EEGsampRate,14,24)).^2);
            %--------------------- Beta2(25-40 Hz)
            beta2 = sqrt((eegfiltfft(filteredEEGData,EEGsampRate,25,40)).^2);
            %--------------------- Task-Engagement
            task = beta1./(alpha+theta);
        end
        
        %% reduces the sampling frequency of the given eeg signals by a factor of 4 - #Tim
        % renamed from reduceTo4Hz() to subsampleByFactorOf4()
        % method rewritten by Gernot 
        % old method below
        %function [delta_s,theta_s,alpha_s,beta1_s,beta2_s,task_s] = reduceTo4Hz(self,delta,theta,alpha,beta1,beta2,task,eegDevice)
        function [delta_s,theta_s,alpha_s,beta1_s,beta2_s,task_s] = subsampleByFactorOf4(self,delta,theta,alpha,beta1,beta2,task,eegDevice)
            factor = 4;
            reducedSamplingRate = double(eegDevice.samplingRate/factor);
            reducedSignalLength = length(delta)/(reducedSamplingRate); % the given signals have got all the same length
            % initialize reduced signals by 0 
            % _s may stand for "short" since the signal vectors 
            % are shorter now
            delta_s = zeros(1,reducedSignalLength);
            theta_s = zeros(1,reducedSignalLength);
            alpha_s = zeros(1,reducedSignalLength);
            beta1_s= zeros(1,reducedSignalLength);
            beta2_s= zeros(1,reducedSignalLength);
            task_s= zeros(1,reducedSignalLength);

            % now fill the old signals into the shorter vectors by
            % subsampling them
            for indexSignal = 1:reducedSignalLength
                % Build mean value between upper and lower bound for 
                % every frequency_band for subsampling the signal, hence reducing the resolution
                lower_bound = (indexSignal-1)*(reducedSamplingRate)+1;
                upper_bound = (indexSignal-1)*(reducedSamplingRate)+(reducedSamplingRate);

                delta_s(indexSignal) = mean(delta(lower_bound:upper_bound));
                theta_s(indexSignal) = mean(theta(lower_bound:upper_bound));
                alpha_s(indexSignal) = mean(alpha(lower_bound:upper_bound));
                beta1_s(indexSignal) = mean(beta1(lower_bound:upper_bound));
                beta2_s(indexSignal) = mean(beta2(lower_bound:upper_bound));
                task_s(indexSignal) = mean(task(lower_bound:upper_bound));
            end
        end
        
        %         %% Subsamples the different eeg frequencies to a resolution of 4Hz
%         function [delta_s,theta_s,alpha_s,beta1_s,beta2_s,task_s] = reduceTo4Hz(self,delta,theta,alpha,beta1,beta2,task,eegDevice)
%             resolution = 4;
%             resolutionFac = double(eegDevice.samplingRate/resolution);
%             l = length(delta)/(resolutionFac);
%             delta_s = zeros(1,l);
%             theta_s = zeros(1,l);
%             alpha_s = zeros(1,l);
%             beta1_s= zeros(1,l);
%             beta2_s= zeros(1,l);
%             task_s= zeros(1,l);
%             for i = 1:l
%                 % Build mean value between upper and lower bound for each frequency in order to
%                 % reduce the signal resolution
%                 lower = (i-1)*(resolutionFac)+1;
%                 upper = (i-1)*(resolutionFac)+(resolutionFac);
%                 delta_s(i) = mean(delta(lower:upper));
%                 theta_s(i) = mean(theta(lower:upper));
%                 alpha_s(i) = mean(alpha(lower:upper));
%                 beta1_s(i) = mean(beta1(lower:upper));
%                 beta2_s(i) = mean(beta2(lower:upper));
%                 task_s(i) = mean(task(lower:upper));
%             end
%         end
        
%% Create CSV file for Bandspectrum Signals
        function SignalBandCSV(self,subject,StimuIntDefs,eegDevice)
            
            % define needed variables
            statsMat = [];
            testLength = 0;
            
            for indexStimu = 1:length(StimuIntDefs)
                
                % get test length
                testLength = testLength + double(StimuIntDefs{indexStimu}.Stimulength);
                StimuIntTypeVector = [];
                
                % get signals
                % {indexStimu, INTEGER} - Integer represents the spectrum
                % bands, which are saved in the order seen below
                delta = subject.eegData.eegSpecBand{indexStimu,1}';
                theta = subject.eegData.eegSpecBand{indexStimu,2}';
                alpha = subject.eegData.eegSpecBand{indexStimu,3}';
                beta1 = subject.eegData.eegSpecBand{indexStimu,4}';
                beta2 = subject.eegData.eegSpecBand{indexStimu,5}';
                task = subject.eegData.eegSpecBand{indexStimu,6}';
                                
                % get vector with Stimulus Type
                StimuIntType = StimuIntDefs{indexStimu}.stimuIntType;
                StimuIntTypeVector(1:length(delta), 1) = StimuIntType;
                
                % make a matrix 
                statsMatStimuInt = cat(2,StimuIntTypeVector,delta,theta,alpha,beta1,beta2,task);
                
                % add to previous matrix
                statsMat = cat(1,statsMat,statsMatStimuInt);
            end
            
            % add timeseries
            time = 1/eegDevice.samplingRate:1/eegDevice.samplingRate:testLength;
            statsMat = cat(2,time',statsMat);
            
            % add header
            Header = ["Time","Stimulus Type","Delta_1-4Hz","Theta_5-7Hz","Alpha_8-13Hz","Beta1_14-24Hz","Beta2_25-45Hz","TEI_Index"];
            statsMat = cat(1,Header,statsMat);
            
            % print into csv
            fname = [subject.OutputDirectory '/' subject.name '___EEGSpectrumBandFiltered_EEG_Values_PerStimulusInterval_OverTime.csv'];
            writematrix(statsMat,fname,'Delimiter','semi');
        end
        

        %% Function which returns the indices of the stimlus interval of a given type
        %  see StimuIntDefinition.m for more information about the Stimlus
        %  types
        function indicies = getStimuIntIndex(self,SearchType,StimuIntDef)
            lengthStimu = length(StimuIntDef);
            indicies = zeros(1,lengthStimu);

            for indexStimu = 1:lengthStimu
                StimuIntType = StimuIntDef{indexStimu}.stimuIntType;
                for j = 1:length(SearchType)
                    if StimuIntType == SearchType(j)
                        indicies(indexStimu)= indexStimu;
                        break;
                    end
                end 
            end
            indicies = indicies(indicies~=0);
        end  
    end
end

