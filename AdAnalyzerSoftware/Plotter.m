%Encapsulates functionality to plot PDF figures and write csv files.
classdef Plotter
    methods
        
        %% Saves all GUI and DEVICE settings to fName.pdf
        %   config: contains all configs as String
        %   fName: File name as String
        function writeSettings(self,config,eegDevice,edaDevice,hrvDevice,fName)
            fatbraid="===========================================================" + newline;
            thinbraid="------------------------------------------------------" + newline;
            
            output_text= strcat(fatbraid,"---> GUI SETTINGS"+newline);
            output_text= strcat(output_text,fatbraid);
            output_text= strcat(output_text,"SubStimuIntEDAFig=" + num2str(config.SubStimuIntEDAFig)+newline);
            output_text= strcat(output_text,"Statistics=" + num2str(config.Statistics)+newline);
            output_text= strcat(output_text,"BehaveFig=" + num2str(config.BehaveFig)+newline);
            output_text= strcat(output_text,"DetrendedEDAFig=" + num2str(config.DetrendedEDAFig)+newline);
            output_text= strcat(output_text,"RecurrenceFig=" + num2str(config.RecurrenceFig)+newline);
            output_text= strcat(output_text,"QualityFig=" + num2str(config.QualityFig)+newline);
            output_text= strcat(output_text,"FrequencyFig=" + num2str(config.FrequencyFig)+newline);
            output_text= strcat(output_text,"LowerThreshold=" + num2str(config.LowerThreshold)+newline);
            output_text= strcat(output_text,"UpperThreshold=" + num2str(config.UpperThreshold)+newline);
            output_text= strcat(output_text,"QualityIndex=" + num2str(config.QualityIndex)+newline);
            output_text= strcat(output_text,"RecurrenceTreshold=" + num2str(config.RecurrenceThreshold)+newline+newline);
            output_text= strcat(output_text,fatbraid);
            output_text= strcat(output_text,"---> DEVICE SETTINGS"+newline);
            output_text= strcat(output_text,fatbraid);
            output_text= strcat(output_text,"EEG-DEVICE SETTINGS"+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"Device Manufacturer=" + eegDevice.name +newline);
            output_text= strcat(output_text,"Sampling Frequency[Hz]=" + num2str(eegDevice.samplingRate)+newline);
            output_text= strcat(output_text,"Electrode Positions=" + eegDevice.electrodePositions +newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"EDA-DEVICE SETTINGS"+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"Device Manufacturer=" + edaDevice.name +newline);
            output_text= strcat(output_text,"Sampling Frequency[Hz]=" + num2str(edaDevice.samplingRate)+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"HRV-DEVICE SETTINGS"+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"Device Manufacturer=" + hrvDevice.name +newline);
            output_text= strcat(output_text,"Sampling Frequency[Hz]=" + num2str(hrvDevice.samplingRate)+newline);
            output_text= strcat(output_text,fatbraid);
            
            fig = figure('Visible','off');
            axes('Position',[0 0.1 1 1],'Visible','off');
            text(0.0,0.95,output_text,'FontName','FixedWidth','FontSize',8);
            print(fName,'-dpdf',fig,'-r0');
            close(fig);
        end
        %% Saves statistics as PDF
        %   stats: statistics as String
        %   fName: File name as String
        function writeStatistics(self,stats,fName)
            fig = figure('Visible','off');
            axes('Position',[0 0.1 1 1],'Visible','off');
            text(0.0,0.85,stats,'FontName','FixedWidth','FontSize',6); %Changed font size to 6 (from 8) for displaying the whole text
            print(fName,'-dpdf',fig,'-r0');
            close(fig);
        end
        
        %% Saves in/valid Subjects and status
        %   stats: statistics as String
        %   fName: File name as String
        function writeValid(self,index, fName)
            fig = figure('Visible','off');
            axes('Position',[0.1 0.1 1 1],'Visible','off');
            text(0.0,0.85,index,'FontName','FixedWidth','FontSize',10);
            ...%'VerticalAlignment', 'top', ...            
            %'HorizontalAlignment', 'right');
            print(fName,'-dpdf',fig,'-r0','-fillpage');
            close(fig);
        end
        
        %% Writes array or cell array to csv file with given format and file name
        %  fName: Name of the File to write as String
        %  format: Format String 
        %  data: CellArray or Array 
        function writeCSV(self,fName,format,data)
            fid = fopen(fName,'w');
            if iscell(data)
                fprintf(fid,format,data{:});
            else
                fprintf(fid,format,data);
            end
            fclose(fid);
        end
        
        %% Prints recurrence plots for HRV
        %  subjectName: Name of the Subject as String
        %  config: Config 
        %  StimuIntName: String
        %  hrvData: HRV values for Subject as double[] 
        function plotHRVRecurrence(self,subjectName,config,StimuIntName,hrvData)
            N = length(hrvData);
            S = zeros(N, N);
            time = zeros(N,1);
            % Calculate time in seconds for x axis
            for i=1:N
                time(i) = round(sum(hrvData(1:i))/1000);
            end
            for i = 1:N
                S(:,i) = abs( repmat( hrvData(i), N, 1 ) - hrvData(:) );
            end
            fig = figure('Visible','off');
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperUnits', 'centimeters');            
            set(fig, 'PaperPosition', [0.2 0.1 20 29 ]);
            subplot(2,1,1);
            imagesc(time, time, S);
            axis square;
            xlabel('Time [s]');
            ylabel('Time [s]');
            set(gca,'YDir','normal')            
            h = colorbar('eastoutside');
            freezeColors;
            freez = cbfreeze(h);
            cblabel('Time [ms]');
            set(freez, 'Position', [0.75 0.585 0.05 0.34]);
            title(['Distance map of ' StimuIntName ' phase space trajectory for subject' subjectName]);
            
            subplot(2,1,2);
            maxDiff = max(max(S) - min(S))*0.001;
            if (config.RecurrenceThreshold ~= 0)
                maxDiff = config.RecurrenceThreshold; 
            end
            imagesc(time, time, S < 1);
            axis square;
            colormap([1 1 1;0 0 0]);
            xlabel('Time [s]');
            ylabel('Time [s]');
            set(gca,'YDir','normal')
            title([StimuIntName ' recurrence plot for subject ' subjectName ' with threshold ' num2str(maxDiff)]);
            fName = [config.OutputDirectory '/' subjectName '_' StimuIntName ' _recurrence.pdf'];
            print(fName,'-dpdf',fig);
        end
        
        %%Prints recurrence plots for EDA
        %  subjectName: Name of the Subject as String
        %  config: Config 
        %  StimuIntName: String
        %  edaData: EDA values for Subject as double[] 
        function plotEDARecurrence(self,subjectName,config,StimuIntName,edaData)
            N = length(edaData);
            S = zeros(N, N);
            time = zeros(N,1);
            % Calculate time in seconds for x axis
            for i=1:N
                time(i) = round(sum(edaData(1:i))/5);
            end
            for i = 1:N
                S(:,i) = abs( repmat( edaData(i), N, 1 ) - edaData(:) );
            end
            fig = figure('Visible','off');
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperUnits', 'centimeters');            
            set(fig, 'PaperPosition', [0.2 0.1 20 29 ]);
            subplot(2,1,1);
            imagesc(time, time, S);
            axis square;
            xlabel('Time [s]');
            ylabel('Time [s]');
            set(gca,'YDir','normal')            
            h = colorbar('eastoutside');
            freezeColors;
            freez = cbfreeze(h);
            cblabel('Skin Conductance [µS]');
            set(freez, 'Position', [0.75 0.585 0.05 0.34]);
            title(['Distance map of ' StimuIntName ' phase space trajectory for subject' subjectName]);    
            subplot(2,1,2);
            maxDiff = max(max(S) - min(S))*0.001;
            if (config.RecurrenceThreshold ~= 0)
                maxDiff = config.RecurrenceThreshold; 
            end
            imagesc(time, time, S < 1);
            axis square;
            colormap([1 1 1;0 0 0]);
            xlabel('Time [s]');
            ylabel('Time [s]');
            set(gca,'YDir','normal')
            title([StimuIntName ' recurrence plot for subject ' subjectName ' with threshold ' num2str(maxDiff)]);
            fName = [config.OutputDirectory '/' subjectName '_' StimuIntName ' _recurrence.pdf'];
            print(fName,'-dpdf',fig);
        end
        
        %% Plots behavioral characteristics
        %  subjectName: String 
        %  StimuIntNum: Number of the StimulusInterval
        %  outputDir: Path to output directory as String
        %  frequencies: eeg frequency data for subject as CellArray of double[] 
        %  intervals: intervals of interest as int[]
        function plotBehavioralCharacteristics(self,subjectName,StimuIntNum,outputDir,frequencies,StimuIntDef,eegDevice)
            EEGSamplingRate=eegDevice.samplingRate;
            intervals = StimuIntDef.intervals;
            stimuIntDescrp = StimuIntDef.stimuIntDescrp;
            lengthInSeconds = length(frequencies{1,1})/EEGSamplingRate; 
            stepWith = 1;
            if lengthInSeconds > 30
                xName = 0:5:lengthInSeconds;
                stepWith = 5;
            else
                xName = 0:lengthInSeconds;
            end
            xTime = xName./stepWith; 
            absolutValuesPerSecond = zeros(length(frequencies),lengthInSeconds/stepWith); 
            [m,n] = size(absolutValuesPerSecond);
            % make values discrete (calculate mean per second)
            for i=1:m
                start = 1; 
                ende = EEGSamplingRate*stepWith; 
                freqValues = frequencies{:,i}; 
                for j=1:n
                   absolutValuesPerSecond(i,j) = mean(freqValues(start:ende)); 
                   start = start +EEGSamplingRate*stepWith;
                   ende = ende +EEGSamplingRate*stepWith; 
                end
            end
            %Normalize percental 
            valuesToPlot = zeros(m,n);
            % Add TEI values
            valuesToPlot(m,:) = absolutValuesPerSecond(m,:);
            for i=1:m 
                for j=1:n
                   maxPerSecond = max(absolutValuesPerSecond(:,j));
                   maximumPos = absolutValuesPerSecond(:,j) == maxPerSecond;
                   valuesToPlot(maximumPos,j) = maxPerSecond/sum(absolutValuesPerSecond(:,j))*100;
                   %offset = maxPerSecond*90/100; % if a value exists which is 10% smaller then max, show this value in plot
                   %secondValuePos = absolutValuesPerSecond(:,j) >= offset;
                   %if (secondValuePos~=maximumPos)
                   %     valuesToPlot(secondValuePos,j) = absolutValuesPerSecond(secondValuePos,j) / sum(absolutValuesPerSecond(:,j))*100;
                   %end
                end
            end            
            fig = figure('Visible','off');
            colormap jet;
            bar(valuesToPlot','stack');
            grid; 
            self.plotIntervals(intervals,[0, 100],stepWith,[],'r');
            title(['Behavioral characteristics for subject' subjectName ' ' stimuIntDescrp ' ' num2str(StimuIntNum)]);
            warning('off','MATLAB:legend:IgnoringExtraEntries'); 
            legend('Sleepiness','Thinking','Relaxation','Attention','Stress','TEI','Stimulus');
            warning('on','MATLAB:legend:IgnoringExtraEntries'); 
            axis([0 max(xTime)+1 0 100]);
            set(gca,'XTick',xTime,'XTickLabel',xName);
            xlabel('time [s]');
            ylabel('[%]'); 
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'landscape');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
            fName = [outputDir '/' subjectName '_' stimuIntDescrp num2str(StimuIntNum) '_characteristics.pdf'];
            print(fName,'-dpdf',fig);
            close(fig);
        end
        
%         %% Plots momentary frequency
%         function plotMomentaryFrequency(self,values,conf,subjectName,StimuIntDef)
%             maxscale = max(values);
%             minscale=min(values);
%             [StimuIntStartPoints,StimuIntLabels,intervals,completeVidLength] = self.calculateStimuIntStartPointsAndIntervals(StimuIntDef);
%             xName = 0:10:completeVidLength;
%             xTime = xName .* 5;
%             fig = figure('Visible','off');
%             plot(values,'k');
%             grid;
%             axis([1 length(values) minscale maxscale]);
%             set(gca,'XTick',xTime,'XTickLabel',xName);
%             ylabel('momentary frequencie [µS]');
%             self.plotStimuIntStartPoints(StimuIntStartPoints,StimuIntLabels,[minscale, maxscale],max(xTime)/max(xName));
%             self.plotIntervals(intervals,[minscale, maxscale],max(xTime)/max(xName),[],'r');
%             xlabel('time [s]');
%             title(['Momentary frequency for subject' subjectName]);
%             set(fig, 'PaperType', 'A4');
%             set(fig, 'PaperOrientation', 'landscape');
%             set(fig, 'PaperUnits', 'centimeters');
%             set(fig, 'PaperPositionMode', 'auto');
%             set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
%             print([conf.OutputDirectory '/' subjectName '_EDA_momentary_frequencie'],'-dpdf',fig);
%             close(fig);
%         end
        
        
        %% Plots hrv data
        %  hrvValues: hrvValues for Subject as double[]
        %  outputDir: Path to output directory as String
        %  subjName: The name of the Subject
        %  StimuIntDef: StimulusInterval Definition
        function plotHRV(self,hrvValues,outputDir,subjName,StimuIntDef)
            fig = figure('Visible','off');
            time = zeros(length(hrvValues),1);
            % Calculate time in seconds for x axis
            for i=1:length(hrvValues)
                time(i) = round(sum(hrvValues(1:i))/1000);
            end
            plot(hrvValues,'k');
            grid;
            xTime = time(1:20:end);
            yMin = min(hrvValues);
            yMax = max(hrvValues);
            [StimuIntStartPoints,StimuIntLabels,intervals,~] = self.calculateStimuIntStartPointsAndIntervals(StimuIntDef);
            self.plotStimuIntStartPoints(StimuIntStartPoints,StimuIntLabels,[yMin, yMax],1);
            self.plotIntervals(intervals,[yMin, yMax],1,[],'r');
            axis([1 max(xTime) yMin yMax]);
            set(gca,'XTick',xTime,'XTickLabel',xTime);
            ylabel('RR intervals [ms]');
            xlabel('time [s]');
            m = sprintf('%.2f',mean(hrvValues));
            sd = sprintf('%.2f',std(hrvValues));
            title({['HRV values for subject ' subjName ' (mean=' m 'ms, sd=' sd 'ms)'],''});
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'landscape');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
            fName = [outputDir '/' subjName '_HRV.pdf'];
            print(fName,'-dpdf',fig);
            close(fig);
        end
        
        %% RawEEG figure plot
        %   rawValues: Raw eeg values as double[]
        %   filteredValues: Filteres eeg values as double[]
        %   quality: Two double values. First is percent outside for
        %   rawValues. Second is percent outside for filtered values
        %   subject: Data of Subject
        %   config: Config  
        function plotRawEEGFigures(self,rawValues,filteredValues,quality,subject,electrode,config,data)
            numRawValues = length(rawValues);
            numFilteredValues = length(filteredValues);
            fig = figure('visible', 'off');
            subplot(2,1,1);
            plot(rawValues);
            grid;
            hold on;
            line('XData',[0 numRawValues],'YData',[config.LowerThreshold config.LowerThreshold],'Color','r')
            line('XData',[0 numRawValues],'YData',[config.UpperThreshold config.UpperThreshold],'Color','r')
            hold off;
            thresholdString = ['[' num2str(config.LowerThreshold) ',' num2str(config.UpperThreshold) ']'];
            title (['Unfiltered EEG raw data for electrode ' char(electrode) ' of subject ' subject.name ' (' sprintf('%3.2f',quality(1)) '% of data lies outside the interval ' thresholdString 'µV)'])
            ylabel('amplitude [µV]');
            xlabel('data point [#]');
            axis([1 numRawValues min(rawValues) max(rawValues)])
            set(gca,'YDir','reverse');
            subplot(2,1,2);
            plot(filteredValues);
            grid;
            hold on;
            line('XData',[0 numFilteredValues],'YData',[config.LowerThreshold config.LowerThreshold],'Color','r')
            line('XData',[0 numFilteredValues],'YData',[config.UpperThreshold config.UpperThreshold],'Color','r')
            hold off;
            title (['Filtered EEG raw data for subject ', subject.name ,' (',sprintf('%3.2f',quality(2)),'% of data lies outside the interval ' thresholdString 'µV)'])
            ylabel('amplitude [µV]')
            xlabel('data point [#]');
            axis([1 numFilteredValues min(rawValues) max(rawValues)])
            set(gca,'YDir','reverse');
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'landscape');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
            %Filter Invalid Subject to print EEG files
            if subject.isValid == 1
            print([config.OutputDirectory '/' subject.name '_' char(electrode) '_EEG.pdf'],'-dpdf',fig);
            end
            close(fig);
        end
        
        %% Plots quality index figures for subjects and StimulusIntervals
        %   unfilteredQuality: Percentage of unfiltered eeg values outside interval for each subject
        %   and StimuInt as double[][]
        %   filteredQuality: Percentage of filtered eeg values outside interval for each subject
        %   and StimuInt as double[][]
        %   validStimuIntsPerSubject: Number of valid baseline eeg, tv
        %   programm and tv commercial StimulusIntervals per subject as double[][]
        %   validSubjects: Total number of valid subjects as double
        %   StimuIntDefs: StimulusInterval definitions as Cell<StimuIntDef>
        %   config: Config
        %   numSubjects: total number of subjects as double
        
%         Kreitzberg: Commented out, until functionality and usecase is declared
%         or function is change
        
%         function plotEEGQualityFigures(self,unfilteredQuality,filteredQuality,validStimuIntsPerSubject,validSubjects,StimuIntDefs,config,numSubjects) %Tim ID 12 plot of QualityFigs
%             StimuIntIndex = length(StimuIntDefs);
%             outputFolder= config.OutputDirectory;
%             h = waitbar(0,['Writing EEG quality figures for ' num2str(StimuIntIndex) ' StimulusInterval(s)']);
%             xtick = 0:numSubjects;
%             for i = 1:StimuIntIndex
%                 fig = figure('Visible','off');
%                 numberExcluded = length(find(filteredQuality(:,i) >= config.QualityIndex));
%                 plot(unfilteredQuality(:,i),'b');
%                 hold on;
%                 plot(filteredQuality(:,i),'k');
%                 grid;
%                 hold off;
%                 line('XData',[1 numSubjects],'YData',[config.QualityIndex config.QualityIndex],'Color','r')
%                 hold off;
%                 legend('Unfiltered EEG Data','Filtered EEG Data',[num2str(config.QualityIndex) '% cutoff for filtered EEG data']);
%                 thresholdString = ['[' num2str(config.LowerThreshold) ',' num2str(config.UpperThreshold) ']'];
%                 StimuIntClass = StimuIntDefs{1,i}(1);
%                 title (['Quality index (% of data outside ' thresholdString 'uV interval) for EEG data for ',StimuIntClass.stimuIntDescrp,' ',int2str(i),' = ',int2str(numberExcluded),' data sets are excluded']);
%                 ylabel('Quality index [%]');
%                 xlabel('subject [#]');
%                 axis([1 numSubjects 0 100]);
%                 set(gca,'XTick',xtick,'xTickLabel',xtick);
%                 set(fig, 'PaperType', 'A4');
%                 set(fig, 'PaperOrientation', 'portrait');
%                 set(fig, 'PaperUnits', 'centimeters');
%                 set(fig, 'PaperPositionMode', 'auto');
%                 set(fig, 'PaperPosition', [0.2 0.1 20 29 ]);
%                 print(['-f',int2str(fig.Number)],'-dpdf',[outputFolder,'\EEG Quality ',StimuIntClass.stimuIntDescrp,'.pdf']);
%                 close(fig);
%                 waitbar(i/StimuIntIndex);
%             end
%             fig = figure('Visible','off');
%             ytick = 0:StimuIntIndex;
%             xtick = 0:numSubjects;
%             bar(validStimuIntsPerSubject,'stack');
%             grid on;
%             legend('Baseline','TV commercial','TV program');
%             [~,y] = size(validStimuIntsPerSubject);
%             axis([0 numSubjects+1 0 y+1]);
%             set(gca,'YTick',ytick,'yTickLabel',ytick);
%             set(gca,'XTick',xtick,'xTickLabel',xtick);
%             tMessage = ['Number of subjects reaching EEG quality criteria: ',int2str(validSubjects)];
%             title(tMessage);
%             ylabel('Number of StimulusInterval [#]');
%             xlabel('subject [#]');
%             set(fig, 'PaperType', 'A4');
%             set(fig, 'PaperOrientation', 'landscape');
%             set(fig, 'PaperUnits', 'centimeters');
%             set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
%             print(['-f',int2str(fig.Number)],'-dpdf',[outputFolder,'\EEG Quality Index - Subjects.pdf']);
%             close(fig)
%             close(h);
%         end
        
        %% Plots EDA figures for given StimulusIntervals to given file name
        %   StimuIntIndex: StimulusInterval indicies of StimulusIntervals to plot as doubel[]
        %   edaValues: eda values of subject as Cell of double[]
        %   StimuIntDefs: Cell<StimuIntDefinition>
        %   subjectName: the name of the subject as String
        %   fPath: file path as String 
        %   stats: eda statistics for subject as String 
        function plotSubStimuIntEDA(self,StimuIntIndex,edaValues,StimuIntDefs,subjectName,fPath,stats)
            fig = figure('Visible','off');
            allValues=  edaValues(StimuIntIndex);
            allValues = vertcat(allValues{:});
            yMin = min(allValues);
            yMax = max(allValues);
            yL = [yMin yMax];
            % choose x axis interval on base of StimulusInterval length
            for i=1:length(StimuIntIndex)
                StimuIntClass = StimuIntDefs{1,i}(1);
                StimuIntNum = StimuIntIndex(i);
                StimuIntLength = StimuIntDefs{StimuIntNum}.length;
                labels = [];
                if StimuIntLength > 30
                    xName = 0:5:StimuIntLength;
                    labels = StimuIntDefs{StimuIntNum}.intervals;
                else
                    xName = 0:StimuIntLength;
                end
                xTime = xName .* 5;
                subplot(6,1,i);
                plot(edaValues{StimuIntNum},'k');
                self.plotIntervals(StimuIntDefs{StimuIntNum}.intervals,yL,max(xTime)/max(xName),labels,'r');
                grid;
                ylabel([StimuIntClass.stimuIntDescrp ' [µS]']);
                l = length(edaValues{StimuIntNum});
                axis([1,l, yL]);
                set(gca,'XTick',xTime,'XTickLabel',xName);
                if (i==1)
                    title(['EDA values for the StimulusInterval ' mat2str(StimuIntIndex) ' of subject ' subjectName]);
                end
            end
            xlabel('Time [s]');
            axes('Position',[.08 .30 0.8 1],'Visible','off');
            text(0,0,stats,'FontName','FixedWidth','FontSize',9);
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'portrait');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPositionMode', 'auto');
            set(fig, 'PaperPosition', [0.2 0.2 20 29 ]);
            print(fPath,'-dpdf',fig);
            close(fig);
        end
        
        %% Plots complete EDA figure to given file name
        %   StimuIntDef: Cell<StimuIntDefinition>
        %   fPath: Output file path
        %   edaValues: EDA values as double[]
        %   detrended: boolean 
        function plotEDA(self,StimuIntDef,fPath,edaValues,detrended)
            maxscale = max(edaValues);
            minscale=min(edaValues);
            [StimuIntStartPoints,StimuIntLabels,intervals,completeVidLength] = self.calculateStimuIntStartPointsAndIntervals(StimuIntDef);
            xName = 0:10:completeVidLength;
            xTime = xName .* 5;
            fig = figure('Visible','off');
            plot(edaValues,'k');
            grid;
            axis([1 length(edaValues) minscale maxscale]);
            set(gca,'XTick',xTime,'XTickLabel',xName);
            xlabel('Time [s]');
            self.plotStimuIntStartPoints(StimuIntStartPoints,StimuIntLabels,[minscale, maxscale],max(xTime)/max(xName));
            self.plotIntervals(intervals,[minscale, maxscale],max(xTime)/max(xName),[],'r');
            ylabel('Skin Conductance [µS]');
            if (detrended)
                t = 'EDA values (detrended)';
            else
                t = 'EDA values';
            end
            title({t,''});
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'landscape');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPositionMode', 'auto');
            set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
            print(fPath,'-dpdf',fig);
            close(fig);
        end
        
        %% Plots eeg frequency bands for StimulusInterval
        %   StimuIntLength: Length of the StimulusInterval in seconds as double
        %   fPath: Output file path as String
        %   theta_s: Theta values as double[]
        %   alpha_s: Alpha values as double[]
        %   beta1_s: Beta1 values as double[]
        %   beta2_s: Beta2 values as double[]
        %   task_s: TEI values as double[]
        %   resolution: values per second as double 
        %   intervals: intervals of interest as int[]
        %   edaSubStimuIntList: EDA values of StimulusInterval as double[]
        function plotFrequencys(self,StimuIntLength,fPath,theta_s,alpha_s,beta1_s,beta2_s,task_s,resolution,StimuIntDef,edaSubStimuIntList)
            intervals = StimuIntDef.intervals;
            stimuIntDescrp = StimuIntDef.stimuIntDescrp;
            fig = figure('Visible','off');
            maxscale = max([max(theta_s) max(alpha_s) max(beta1_s) max(beta2_s) ]);
            labels = [];
            if StimuIntLength > 30
                xname = 0:5:StimuIntLength;
                labels = intervals;
            else
                xname = 0:StimuIntLength;
            end
            xtime = xname .* resolution;
            edaXTime = xname .* 5;
            %---------------------
            % subplot(6,1,1)
            % plot(delta_s,'Color',[65/255 105/255 225/255]);
            % grid;
            %  ylabel('Delta');
            % axis([1 length(delta_s) 0 maxscale]);
            %  set(gca,'XTick',xtime,'XTickLabel',xname);
			
            subplot(6,1,1);
            plot(theta_s,'Color',[0/255 191/255 255/255]);
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xname),labels,'r');
            grid;
            ylabel('Theta [µV]');
            axis([1 length(theta_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
            [~,subjName,~] = fileparts(fPath);
            t = title({['Frequency bands, task engagement and EDA for subject: ' strrep(subjName,'_freq_bands_',' ')],''});
            tP = get(t,'Position');
            set(t,'Position',[tP(1) tP(2)+0.3 tP(3)]);
            set(t,'FontSize',12);
            
            subplot(6,1,2);
            plot(alpha_s,'Color',[0/255 128/255 0/255]);
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xname),labels,'r');
            grid;
            ylabel('Alpha [µV]');
            axis([1 length(alpha_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
            
            subplot(6,1,3);
            plot(beta1_s,'Color',[255/255 128/255 0/255]);
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xname),labels,'r');
            grid;
            ylabel('Beta1 [µV]');
            axis([1 length(beta1_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
            
            subplot(6,1,4);
            plot(beta2_s,'Color',[255/255 69/255 0/255]);
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xname),labels,'r');
            set(gca,'XTick',xtime,'XTickLabel',xname);
            grid;
            ylabel('Beta2 [µV]');
            axis([1 length(beta2_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
            
            subplot(6,1,5);
            plot(task_s,'k');
            self.plotIntervals(intervals,[0, max(task_s)],max(xtime)/max(xname),labels,'r');
            grid;
            ylabel('TEI');
            axis([1 length(task_s) 0 max(task_s)]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
            
            subplot(6,1,6);
            plot(edaSubStimuIntList,'k');
            yL = [min(edaSubStimuIntList) max(edaSubStimuIntList)];
            self.plotIntervals(intervals,yL,max(edaXTime)/max(xname),labels,'r');
            grid;
            ylabel('EDA [µS]');
            l = length(edaSubStimuIntList);
            axis([1,l, yL]);
            set(gca,'XTick',edaXTime,'XTickLabel',xname);
            %             subplot(7,1,7);
            %             t=0:1/5:StimuIntLength;
            %             t = t(1:end-1);
            %             dydt = diff(edaSubStimuIntList)./diff(t);
            %             dydt(end+1) = dydt(end);
            %             plot(dydt,'k');
            %             yL = [min(dydt) max(dydt)];
            %             self.plotIntervals(intervals,yL,max(edaXTime)/max(xname),labels,'r');
            %             crossings = find(diff(dydt>0)~=0)+1;
            %             self.plotIntervals(t(cossings),yL,max(edaXTime)/max(xname),[],'b');
            %             line([1 l],[0,0],'Color','b','LineStyle','--');
            %             grid;
            %             xlabel('Time [s]');
            %             ylabel('d(EDA)/dt [µS/s]');
            %             l = length(dydt);
            %             axis([1,l, yL]);
            %             set(gca,'XTick',edaXTime,'XTickLabel',xname);
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'portrait');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPositionMode', 'auto');
            set(fig, 'PaperPosition', [0.2 0.1 20 29 ]);
            print(['-f',int2str(fig.Number)],'-dpdf',[fPath,'.pdf']);
            close(fig);
        end
               
        %% Plots eeg frequency bands for StimulusInterval
        %   StimuIntLength: Length in seconds as double
        %   fPath: Path to output file as String 
        %   theta_s: Theta values as double[]
        %   alpha_s: Alpha values as double[]
        %   beta1_s: Beta1 values as double[]
        %   beta2_s: Beta2 values as double[]
        %   task_s: TEI values as double[]
        %   baselineTheta: Baseline values for theta as double[]
        %   baselineAlpha: Baseline values for alpha as double[]
        %   baselineBeta1: Baseline values for beta1 as double[]
        %   baselineBeta2: Baseline values for beta2 as double[]
        %   baselineTEI: Baseline values for TEI as double[]
        %   resolution: values per second as double 
        %   intervals: intervals of interest as int[]
        %   t_title: Diagramm title as String 
        function plotFrequencysWithBaselineMagnitude(self,StimuIntLength,fPath,theta_s,alpha_s,beta1_s,beta2_s,task_s,baselineTheta,baselineAlpha,baselineBeta1,baselineBeta2,baselineTEI,resolution,intervals,t_title)
            fig = figure('Visible','off');
			maxscale = 1.2*(max([max(alpha_s) max(beta1_s) max(beta2_s) max(theta_s)])); %Add 20% to the maxscale for providing more space for the legend
            numDataPoints = StimuIntLength*resolution;
            labels = [];
            if StimuIntLength > 30
                xname = 0:5:StimuIntLength;
                labels = intervals;
            else
                xname = 0:StimuIntLength;
            end
            xtime = xname .* resolution;
            
			%subplots
			subplot(6,1,1)
            hold on
            plot(theta_s,'Color',[65/255 105/255 225/255]);
            m = mean(baselineTheta);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xname),labels,'r');
            grid;
            hold off
            massAndTime = self.calculateMassAndTime(theta_s,numDataPoints,mean(baselineTheta));
            
            if(isempty(intervals))
                legend(massAndTime,'theta baseline mean');
            else
                h=legend(massAndTime,'theta baseline mean','Stimulus');
            end
            ylabel('Theta [µV]');
            axis([0 length(theta_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
            
			title(t_title);
			
			subplot(6,1,2);
            hold on;
            plot(alpha_s,'Color',[0/255 128/255 0/255]);
            m = mean(baselineAlpha);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xname),labels,'r');
            hold off;
            massAndTime = self.calculateMassAndTime(alpha_s,numDataPoints,mean(baselineAlpha));
            if(isempty(intervals))
                legend(massAndTime,'alpha baseline mean');
            else
                h= legend(massAndTime,'alpha baseline mean','Stimulus');
            end
            grid;
            ylabel('Alpha [µV]');
            axis([0 length(alpha_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
                        
            subplot(6,1,3);
            hold on;
            plot(beta1_s,'Color',[255/255 128/255 0/255]);
            m = mean(baselineBeta1);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xname),labels,'r');
            massAndTime = self.calculateMassAndTime(beta1_s,numDataPoints,mean(baselineBeta1));
            hold off;
            if(isempty(intervals))
                legend(massAndTime,'beta1 baseline mean');
            else
                h= legend(massAndTime,'beta1 baseline mean','Stimulus');
            end
            grid;
            ylabel('Beta1 [µV]');
            axis([0 length(beta1_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
            
            subplot(6,1,4);
            hold on;
            plot(beta2_s,'Color',[255/255 69/255 0/255]);
            m = mean(baselineBeta2);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            massAndTime = self.calculateMassAndTime(beta2_s,numDataPoints,mean(baselineBeta2));
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xname),labels,'r');
            hold off;
            if(isempty(intervals))
                legend(massAndTime,'beta2 baseline mean');
            else
                h=legend(massAndTime,'beta2 baseline mean','Stimulus');
            end
            grid;
            ylabel('Beta2 [µV]');
            axis([0 length(beta2_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
			
			subplot(6,1,5);
            hold on;
            plot(task_s,'k');
            m = mean(baselineTEI);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            massAndTime = self.calculateMassAndTime(task_s,numDataPoints,mean(baselineTEI));
            self.plotIntervals(intervals,[0, (1.2*max(task_s))],max(xtime)/max(xname),labels,'r');
            hold off;
            if(isempty(intervals))
                legend(massAndTime,'TEI baseline mean');
            else
                legend(massAndTime,'TEI baseline mean','Stimulus');
            end
            grid;
            ylabel('TEI');
            axis([0 length(task_s) 0 (1.2*max(task_s))]);
            set(gca,'XTick',xtime,'XTickLabel',xname);
            			
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'portrait');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPositionMode', 'auto');
            set(fig, 'PaperPosition', [0.2 0.1 20 29 ]);
            print(['-f',int2str(fig.Number)],'-dpdf',fPath);
			close(fig);
        end
    end
    
    methods(Access=private)   
        
        %% Helper method to calculate mass and time 
        function massAndTime = calculateMassAndTime(self,values,numDataPoints, mean)
            valuesOverMean = find(values > mean);
            overCount = length(valuesOverMean);
            overMass = sum(values(valuesOverMean));
            mass = int8(overMass/sum(values)*100);
            time = int8(overCount/numDataPoints*100);
            massAndTime = [num2str(time) '% time | ' num2str(mass) '% weighted mass is over baseline'];
        end
        
        %% Helper method to calculate intervals and StimulusInterval start points
        function [StimuIntStartPoints,StimuIntLabels,intervals,completeVidLength] = calculateStimuIntStartPointsAndIntervals(self,StimuIntDef)
            StimuIntStartPoints = [];
            StimuIntLabels={};
            intervals = [];
            completeVidLength =0;
            for i=1:length(StimuIntDef)
                completeVidLength = completeVidLength + StimuIntDef{i}.length;
                StimuIntLabels{i} = ['StimuInt' num2str(i)];
                if i==1
                    StimuIntStartPoints(i) = 0;
                else
                    StimuIntStartPoints(i) = StimuIntDef{i-1}.length + StimuIntStartPoints(i-1);
                end
                curIntervals = StimuIntDef{i}.intervals;
                curIntervals= curIntervals +StimuIntStartPoints(i);
                intervals = horzcat(intervals,curIntervals');
            end
        end
        
        %% Helper method to plot intervals of interest
        function plotIntervals(self,intervals,yPos,scaleFac,labels,color)
            labels = labels';
            for i=1:length(intervals)
                xPosition = intervals(i);
                xPosition = xPosition*double(scaleFac);
                line([double(xPosition) double(xPosition)],yPos,'Color',color);
                if ~isempty(labels)
                    text([double(xPosition) double(xPosition)],[yPos(2) yPos(2)], num2str(labels(i)), 'VerticalAlignment','bottom','HorizontalAlignment','center','FontSize',8);
                end
            end
        end
        
        %% Helper method to plot the StimulusInterval start points
        function plotStimuIntStartPoints(self,startPoints,labels,yPos,scaleFac)
            for i=1:length(startPoints)
                xPosition = startPoints(i);
                xPosition = double(xPosition*scaleFac);
                line([xPosition xPosition],yPos,'Color','g');
                text([xPosition xPosition],[yPos(2) yPos(2)], labels(i), 'VerticalAlignment','bottom','HorizontalAlignment','center','FontSize',7);
            end
        end
        
    end
end

