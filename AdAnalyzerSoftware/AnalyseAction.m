% Performs analysis steps for valid subjects
%   Starts when button "Analyse" was clicked
%   Performs eeg frequency analysis
%   Calculates statistics
%   Plots eda figures, eeg frequency figures
%   Calculates statistics
classdef AnalyseAction < handle
    
    properties
        plotter = Plotter;
        stringStatistics = StringStatistics;
        frequencies;
        frequencies4Hz;
    end
    
    methods
        %% Main function of this class
        %   Performs "Analyse" calculation step for all valid subjects
        function analyse(self,data,config,eegDevice,edaDevice,hrvDevice)
            subjects = data.subjects;
            StimuIntDefs = data.stimuIntDefs;
            validSubjects = self.countValidSubjects(subjects);
            message = ['Analysing data for ' num2str(validSubjects) ' valid subject(s)'];
            wBar = waitbar(0,message);
            %Tabel with in/valid Status of Subjects
            self.subjectValid(subjects,config);
            for i=1:length(subjects)
                self.frequencies = cell(6,6);
                self.frequencies4Hz = cell(6,6);
                subject = subjects{i};
%                 if (subject.isValid) <- do analyse for all subjects and
%                 just filter at EEG
                    self.analyseSubject(subject,StimuIntDefs,config,eegDevice,edaDevice,hrvDevice);

                waitbar(i/validSubjects);
            end
            close(wBar);
        end
    end
    methods(Access=private)
        %% Counts valid subjects
        function numValidSubjects = countValidSubjects(self,subjects)
            numValidSubjects=0;
            for i=1:length(subjects)
                if (subjects{i}.isValid)
                    numValidSubjects = numValidSubjects+1;
                end
            end
        end
        
        %% Print in/valid subject table
        function subjectValid(self,subject,config)
            counter = length(subject);
            statsMat = cell(length(subject)+2,1);
            statsMat(1) = {'Overview of subjects and their EEG status'};
            for i=1:counter 
               sub = subject{i};
               if sub.isValid == 1
                   statsMat(i+2) = {['EEG Values for subject   |   ' sub.name '   |   valid']};
               else 
                   statsMat(i+2) = {['EEG Values for subject   |   ' sub.name '   |   invalid']};
               end
            end
            self.plotter.writeValid(statsMat,[config.OutputDirectory '/' 'Subject_Valid_Overview.pdf']);
        end
        
        %% Performs analysis for each subject
        function analyseSubject(self,subject,StimuIntDefs,config,eegDevice,edaDevice,hrvDevice)
            edaPerStim = subject.edaPerVid;
            edaComplete = subject.edaValues;
            numStimuInt = length(edaPerStim);
            % Plot eda
            if (config.EDA_DEVICE_USED)
                self.plotter.plotEDA(StimuIntDefs,[config.OutputDirectory,'/' subject.name '_EDA','.pdf'],edaComplete,0);
            end
            % Plot eda detrended
            if (config.DetrendedEDAFig)
                self.plotter.plotEDA(StimuIntDefs,[config.OutputDirectory,'/' subject.name '_EDA_detrend','.pdf'],detrend(edaComplete),1);
            end
            % Plot EEG 
            numElectrodes = length(subject.eegValuesForElectrodes); 
            statsMat = cell(4+numElectrodes,9);
            %Mark unvalid subjects in EEG Statistics
            if subject.isValid == 1
                statsMat(1,1) = {['Statistics for subject ' subject.name]};
            elseif subject.isValid == 0
                statsMat(1,1) = {['Statistics for subject ' subject.name ' EEG VALUES INVALID']};
            end
            statsMat(3,1:5) ={'EEG values by electrodes','mean[µV]','sd[µV]','dev-[µV]','dev+[µV]'};
            mMean =0; 
            sdMean =0;
            devPMean = 0; 
            devMMean =0; 
            for i=1:numElectrodes
                electrodeData = subject.eegValuesForElectrodes{i}; 
                filteredEEGPerVid = electrodeData.filteredEEGPerVid;
                eegComplete = double(electrodeData.eegValues');
                electrode = electrodeData.electrode; 
                % Calculate statitics for all eeg values
                [m,sd,devP,devM] = self.calculateStatistics(eegComplete);
                mMean = mMean+m; 
                sdMean = sdMean+sd; 
                devPMean = devPMean+devP;
                devMMean = devMMean+devM;
                statsMat(3+i,1:5) = {[char(electrode) ': '],num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            end
            statsMat(end,1:5) = {'Mean electrode values: ',num2str(mMean/numElectrodes,'%6.4f'),num2str(sdMean/numElectrodes,'%6.4f'),num2str(devMMean/numElectrodes,'%6.4f'),num2str(devPMean/numElectrodes,'%6.4f')}; 
            for StimuIntNumber=1:numStimuInt
                filteredEEGPerVid = self.calculateMeanEEGValuesForStimuInt(subject);
                StimuIntStatsMat = self.analyseStimuInt(subject,StimuIntNumber,filteredEEGPerVid,edaPerStim,StimuIntDefs,config,eegDevice,edaDevice,hrvDevice);
                statsMat = vertcat(statsMat,StimuIntStatsMat);
            end
            % EDA statistics 
            orientingResponse = self.getStimuIntIndec('Dummy','EDA Orientation Response',StimuIntDefs);
            [amplitudes,delays] = self.calculateDelays(edaPerStim{orientingResponse},StimuIntDefs{orientingResponse}.intervals,edaDevice);%2
            edaStimuInt = self.getStimuIntIndec('EDA','Dummy',StimuIntDefs);
            edaStatsMat = self.calculateEDAStatistics(edaStimuInt,edaPerStim,delays,amplitudes,StimuIntDefs);
            edaStatsMat = vertcat({'EDA statistics','','','','','','','',''},edaStatsMat);
            edaStatsString =   self.stringStatistics.matrixToString(edaStatsMat(1:end-2,:),' | ');
            delayString =  self.stringStatistics.delaysToString(edaStatsMat(end-1,:));
            ampString =  self.stringStatistics.aplitudesToString(edaStatsMat(end,:));
            statsMat = vertcat(statsMat,edaStatsMat);
            statString =  self.stringStatistics.matrixToString(statsMat(1:end-2,:),' | ');
            % Plot statistics
            if (config.Statistics)
                self.plotter.writeCSV([config.OutputDirectory '/' subject.name '_statistics.csv'],'%s;%s;%s;%s;%s;%s;%s;%s;%s\n',statsMat');
                self.plotter.writeStatistics([statString newline newline delayString newline ampString],[config.OutputDirectory '/' subject.name '_statistics.pdf']);
            end
            % Plot subStimuIntEDA
            if (config.SubStimuIntEDAFig)
                self.plotter.plotSubStimuIntEDA(edaStimuInt,edaPerStim,StimuIntDefs,subject.name,[config.OutputDirectory '/' subject.name ' EDA for StimulusInterval(s) ' mat2str(edaStimuInt)],[edaStatsString newline newline delayString newline ampString]);
            end
            % Plot HRV figure
            if (config.HRV_DEVICE_USED)
                self.plotter.plotHRV(subject.hrvValues,config.OutputDirectory,subject.name,StimuIntDefs);
            end
            % Plot HRV Recurrence
            if (config.RecurrenceFig)
                self.plotter.plotHRVRecurrence(subject.name,config,'HRV',subject.hrvValues);
            end
            %plot frequencies for baseline tvProgramm and tvCommercial with baseline magnitude
            %Funktion für genau diesen Fall, Besprechen wie vorgehen Tim
            if (config.FrequencyFig)
                [~,baselineTheta_s,baselineAlpha_s,baselineBeta1_s,baselineBeta2_s,baselineTEI_s] = self.frequencies4Hz{3,:};
                [~,tvProgrammTheta_s,tvProgrammAlpha_s,tvProgrammBeta1_s,tvProgrammBeta2_s,tvProgrammTEI_s] = self.frequencies4Hz{4,:};
                [~,tvCommercialTheta_s,tvCommercialAlpha_s,tvCommercialBeta1_s,tvCommercialBeta2_s,tvCommercialTEI_s] = self.frequencies4Hz{5,:};
                resolution = 4;
                intervals = StimuIntDefs{4}.intervals;
                StimuIntDescrp = StimuIntDefs{4}.stimuIntDescrp;
                self.plotter.plotFrequencysWithBaselineMagnitude(length(filteredEEGPerVid{4})/eegDevice.samplingRate,...
                    [config.OutputDirectory '/' subject.name '_alpha_beta_theta_TEI_' StimuIntDescrp '.pdf'],...
                    tvProgrammTheta_s,tvProgrammAlpha_s,tvProgrammBeta1_s,tvProgrammBeta2_s,tvProgrammTEI_s,baselineTheta_s,...
                    baselineAlpha_s,baselineBeta1_s,baselineBeta2_s,baselineTEI_s,resolution,intervals,...
                    ['Theta, Alpha, Beta1, Beta2 frequencies and TEI for' StimuIntDescrp ' of subject ' subject.name]);
                intervals = StimuIntDefs{5}.intervals;
                StimuIntDescrp = StimuIntDefs{5}.stimuIntDescrp;
                self.plotter.plotFrequencysWithBaselineMagnitude(length(filteredEEGPerVid{5})/eegDevice.samplingRate,...
                    [config.OutputDirectory '/' subject.name  '_alpha_beta_theta_TEI_' StimuIntDescrp '.pdf'],...
                    tvCommercialTheta_s,tvCommercialAlpha_s,tvCommercialBeta1_s,tvCommercialBeta2_s,tvCommercialTEI_s,...
                    baselineTheta_s,baselineAlpha_s,baselineBeta1_s,baselineBeta2_s,baselineTEI_s,resolution,intervals,...
                    ['Theta, Alpha, Beta1, Beta2 frequencies and TEI for ' StimuIntDescrp ' of subject ' subject.name]);
            end
            %transient = self.frequencyEstimation(edaComplete);
            %self.plotter.plotMomentaryFrequency(transient,config,subject,stimuIntDef)
        end
        
        %         %% Frequency estimation algorithmen
        %         function resultFreq = frequencyEstimation(self, signalData)
        %             mean1 = 0.0;
        %             mean2 = 0.0;
        %             mean3 = 0.0;
        %             tMean = 0.005;
        %             tFreq = 0.005;
        %             k1 = 1;
        %             k2 = 1;
        %             w = 1;
        %             [length,~] = size(signalData);
        %             resultFreq = zeros(length,1);
        %             for i=3:length
        %                 mean1 = self.meanOperator(signalData(i),mean1,tMean);
        %                 if (mean1 < signalData(i-1))
        %                     k1=0;
        %                 end
        %                 mean2 = self.meanOperator(signalData(i-1),mean2,tMean);
        %                 if (mean2 < signalData(i-2))
        %                     k2=0;
        %                 end
        %                 if (k1~=k2)
        %                     w=1;
        %                 end
        %                 mean3 = self.meanOperator(w, mean3, tFreq);
        %                 resultFreq(i-2) = mean3/2;
        %             end
        %         end
        %
        %         function newMeanValue = meanOperator(self, datapoint, oldMeanValue, adaption_const)
        %             newMeanValue = oldMeanValue + adaption_const * (datapoint - oldMeanValue);
        %         end
        
        
        function meanEEGPerStim = calculateMeanEEGValuesForStimuInt(self,subject)
            numElectrodes = length(subject.eegValuesForElectrodes);
            eegForElectrode = subject.eegValuesForElectrodes{1};
            numStimuInt = length(eegForElectrode.filteredEEGPerVid);
            meanEEGPerStim = cell(1,numStimuInt);
            for StimuIntNumber=1:numStimuInt
                meanEEGPerStim{StimuIntNumber} = eegForElectrode.filteredEEGPerVid{StimuIntNumber};
                for i=2:numElectrodes
                    valuesForElectrode = subject.eegValuesForElectrodes{i}.filteredEEGPerVid{StimuIntNumber}; 
                    previousValues = meanEEGPerStim{StimuIntNumber}; 
                    meanEEGPerStim{StimuIntNumber} = previousValues+valuesForElectrode;
                end
                numValues = length(meanEEGPerStim{StimuIntNumber});
                for i=1:numValues
                    meanEEGPerStim{StimuIntNumber}(i) = meanEEGPerStim{StimuIntNumber}(i)/numElectrodes;
                end
            end
        end
        
        %% Performs analysis for each StimulusInterval of each subject
        function StimuIntStatsMat = analyseStimuInt(self,subject,StimuIntNumber,filteredEEGPerStim,edaPerVid,StimuIntDefs,config,eegDevice,edaDevice,hrvDevice)
            % Calculate eeg statistics for each StimulusInterval
            StimuIntLength = length(filteredEEGPerStim{StimuIntNumber})/eegDevice.samplingRate;
            StimuIntDef = StimuIntDefs{StimuIntNumber};
            StimuIntStatsMat = cell(1,9);
            StimuIntStatsMat(1,1) = {['EEG statistics for ' StimuIntDef.stimuIntDescrp]};
            [delta,theta,alpha,beta1,beta2,task] = self.analyseFrequencies(filteredEEGPerStim{StimuIntNumber},eegDevice);
            self.frequencies(StimuIntNumber,:) = {delta,theta,alpha,beta1,beta2,task};
            % Calculate eeg statistics for each StimulusInterval and each frequency
            eegFreqStatsMat = self.calculateEEGFrequencyStatistics(filteredEEGPerStim{StimuIntNumber},delta,theta,alpha,beta1,beta2,task);
            StimuIntStatsMat = vertcat(StimuIntStatsMat,eegFreqStatsMat);
            % Reduce signal resolution to 4Hz
            [delta_s,theta_s,alpha_s,beta1_s,beta2_s,task_s] = self.reduceTo4Hz(delta,theta,alpha,beta1,beta2,task,eegDevice);
            self.frequencies4Hz(StimuIntNumber,:) = {delta_s,theta_s,alpha_s,beta1_s,beta2_s,task_s};
            if(config.BehaveFig)
                self.plotter.plotBehavioralCharacteristics(subject.name,StimuIntNumber,config.OutputDirectory,self.frequencies(StimuIntNumber,:),StimuIntDef,eegDevice)
            end
            if (config.FrequencyFig)
                resolution = 4;
                self.plotter.plotFrequencys(StimuIntLength,[config.OutputDirectory '\' subject.name '_freq_bands_' StimuIntDef.stimuIntDescrp],theta_s,alpha_s,beta1_s,beta2_s,task_s,resolution,StimuIntDef,edaPerVid{StimuIntNumber});
            end
            % Plot Recurrence for EDA_TVSPOT and EDA_COMMERCIAL
            if (config.RecurrenceFig)
                if (contains(StimuIntDef.stimuIntDescrp,'TV Commercial')) 	%Tim Value Hardcoded 
                    self.plotter.plotEDARecurrence(subject.name,config,StimuIntDef.stimuIntDescrp,edaPerVid{StimuIntNumber});
                end
                if (contains(StimuIntDef.stimuIntDescrp,'TV Programm'))
                    self.plotter.plotEDARecurrence(subject.name,config,StimuIntDef.stimuIntDescrp,edaPerVid{StimuIntNumber}); %Tim
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
        function statsMat = calculateEDAStatistics(self,StimuInt,edaValues,delays,amplitudes,StimuIntDefs)
            edaValuesForStimuInt = edaValues(StimuInt);
            numEdaStimuInts = length(edaValuesForStimuInt);
            statsMat = cell(numEdaStimuInts+4,9);
            statsMat(1,2:5) ={'mean[µS]','sd[µS]','dev-[µS]','dev+[µS]'} ;
            completeEDA = cell2mat(edaValues');
            [m,sd,devP,devM] = self.calculateStatistics(completeEDA);
            statsMat(2,1:5) = {'EDA complete',num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            for i=1:numEdaStimuInts
                StimuIntClass = StimuIntDefs{i};
                [m,sd,devP,devM] = self.calculateStatistics(edaValuesForStimuInt{i});
                statsMat(i+2,1:5) = {StimuIntClass.stimuIntDescrp,num2str(m,'%6.4f'),num2str(sd,'%6.4f'),num2str(devM,'%6.4f'),num2str(devP,'%6.4f')};
            end
            delaysNotNull = delays(delays~=0);
            amplitudesNotNull = amplitudes(amplitudes~=0);
            indicies = find(delays);
            if isempty(delaysNotNull)
                s= 'No valid peaks found for Delta_t';
                statsMat{end-1,1}= s;
            elseif length(delaysNotNull)==1
                statsMat{end-1,1} = ['Delta_t of StimulusInterval 2 based on interval ' strtrim(num2str(indicies))]; %Warum StimuInt 2? Tim - erst danach ändern
                statsMat{end-1,2} = num2str(delaysNotNull);
            else
                delayMean = mean(delaysNotNull);
                delayVar = var(delaysNotNull);
                minVarDelay = delayMean - min(delaysNotNull);
                maxVarDelay = max(delaysNotNull) - delayMean;
                statsMat(end-1,1:5) = {
                    ['Delta_t StimulusInterval 2 for intervals ' strtrim(strrep(num2str(indicies),'  ',','))],...
                    ['mean=' num2str(delayMean,'%6.2f') 's'],['var=' num2str(delayVar,'%6.2f') 's'],...
                    ['dev+=' num2str(minVarDelay,'%6.2f') 's'],['dev-=' num2str(maxVarDelay,'%6.2f') 's']
                    };
                numAmplitudes = length(amplitudesNotNull);
                amplitudesAsString = cell(1,numAmplitudes+1);
                amplitudesAsString(1,1) = {['Amplitudes for intervals ' strtrim(strrep(num2str(indicies),'  ',','))]};
                for i=1:numAmplitudes
                    amplitudesAsString(1,i+1) = {[num2str(amplitudesNotNull(i),'%6.2f') 'µS']};
                end
                statsMat(end,1:length(amplitudesAsString)) = amplitudesAsString;
            end
        end
        
        %% Calculates eda delays for given intervals
        function [values,delays] = calculateDelays(self,edaValues,intervals,edaDevice)
            edaValuesDetrend = detrend(edaValues);
            numEDAValues = length(edaValuesDetrend);
            edaPerSec = edaDevice.samplingRate;
            intervals(end+1)=numEDAValues/edaPerSec;
            %delays = zeros(1,length(intervals));
            %values = zeros(1,length(intervals));
            %             for i=1:length(intervals)-1;
            %                 start = uint32(intervals(i)*5);
            %                 ende = uint32(intervals(i+1)*5);
            %                 offset = 10;
            %                 valuesBetweenIntervals = edaValuesDetrend(start+offset:ende);
            %                 m = mean (smooth(valuesBetweenIntervals));
            %                 [~,index] = findpeaks(smooth(valuesBetweenIntervals),'MINPEAKDISTANCE',3,'MINPEAKHEIGHT',(m*120)/100);
            %                 if length(index)~=1
            %                     delays(i) = 0;
            %                     values(i) =0;
            %                 else
            %                     pos = start+offset+index;
            %                     delays(i) = double(pos-(intervals(i)*5))/5.0;
            %                     values(i) = edaValues(pos);
            %                 end
            %             end
            start = uint32(intervals(1)*5);
            ende = uint32((intervals(2)+5)*5); %end offset (project in next interval)
            offset = 10; % start offset (start 10 datapoints later from interval start)
            valuesBetweenIntervals = edaValuesDetrend(start+offset:ende);
            m = mean (smooth(valuesBetweenIntervals));
            delays = zeros(1,length(intervals));
            values = zeros(1,length(intervals));
            [peak,index] = findpeaks(smooth(valuesBetweenIntervals),'MINPEAKDISTANCE',5,'MINPEAKHEIGHT',(m*120)/100);
            if length(index)>1
                index = index(1); %find(peak == max(peak))
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
        
        %% Splits eeg data into different frequencies
        function [delta,theta,alpha,beta1,beta2,task] = analyseFrequencies(self,filteredEEGData,eegDevice)
            EEGsampRate=eegDevice.samplingRate;
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
        
        %% Subsamples the different eeg frequencies to a resoultion of 4Hz
        function [delta_s,theta_s,alpha_s,beta1_s,beta2_s,task_s] = reduceTo4Hz(self,delta,theta,alpha,beta1,beta2,task,eegDevice)
            resolution = 4;
            resolutionFac = double(eegDevice.samplingRate/resolution);
            l = length(delta)/(resolutionFac);
            delta_s = zeros(1,l);
            theta_s = zeros(1,l);
            alpha_s = zeros(1,l);
            beta1_s= zeros(1,l);
            beta2_s= zeros(1,l);
            task_s= zeros(1,l);
            for i = 1:l
                % Build mean value between upper and lower bound for each frequency in order to
                % reduce the signal resolution
                lower = (i-1)*(resolutionFac)+1;
                upper = (i-1)*(resolutionFac)+(resolutionFac);
                delta_s(i) = mean(delta(lower:upper));
                theta_s(i) = mean(theta(lower:upper));
                alpha_s(i) = mean(alpha(lower:upper));
                beta1_s(i) = mean(beta1(lower:upper));
                beta2_s(i) = mean(beta2(lower:upper));
                task_s(i) = mean(task(lower:upper));
            end
        end
        
        function indicies = getStimuIntIndec(self,NeededLocal,NeededDescrp,StimuIntDef)
            lengthStimu = length(StimuIntDef);
            indicies = zeros(1,lengthStimu);

            for i = 1:lengthStimu
                StimuIntSearchLocal = StimuIntDef{i}.StimuIntLocal;
                StimuIntSearchDescrp = StimuIntDef{i}.stimuIntDescrp;

                if strcmpi(NeededLocal,StimuIntSearchLocal) 
                    indicies(i)= i;    
                end

                if contains(NeededDescrp,StimuIntSearchDescrp)
                    indicies(i)= i;
                end
                
            end
            indicies = indicies(indicies~=0);
        end
        
        
        
    end
end

