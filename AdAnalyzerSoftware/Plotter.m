%Encapsulates functionality to plot PDF figures and write csv files.
classdef Plotter
    methods
        
        %% Saves all GUI and DEVICE settings to fName.pdf
        %   config: contains all configs as String
        %   fName: File name as String
        %   Devices: contains settings of different devices
        function writeSettings(self,config,eegDevice,edaDevice,hrvDevice,fName)
            fatbraid="===========================================================" + newline;
            thinbraid="------------------------------------------------------" + newline;
            
            output_text= strcat(fatbraid,"---> GUI SETTINGS"+newline);
            output_text= strcat(output_text,fatbraid);
            
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"Subject Settings"+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"Number of Subjects=" + num2str(config.numSubjects)+newline+newline);
            
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"Output Settings"+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"SubStimuIntEDAFig=" + num2str(config.SubStimuIntEDAFig)+newline);
            output_text= strcat(output_text,"Statistics=" + num2str(config.Statistics)+newline);
            output_text= strcat(output_text,"BehaveFig=" + num2str(config.BehaveFig)+newline);
            output_text= strcat(output_text,"DetrendedEDAFig=" + num2str(config.DetrendedEDAFig)+newline);
            output_text= strcat(output_text,"RecurrenceFig=" + num2str(config.RecurrenceFig)+newline);
            output_text= strcat(output_text,"QualityFig=" + num2str(config.QualityFig)+newline);
            output_text= strcat(output_text,"FrequencyFig=" + num2str(config.FrequencyFig)+newline+newline);
            output_text= strcat(output_text,thinbraid);
            
            output_text= strcat(output_text,"EEG Quality Settings"+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"LowerThreshold=" + num2str(config.LowerThreshold)+newline);
            output_text= strcat(output_text,"UpperThreshold=" + num2str(config.UpperThreshold)+newline);
            output_text= strcat(output_text,"QualityIndex=" + num2str(config.QualityIndex)+newline);
            output_text= strcat(output_text,"EEGCutoffValue=" + num2str(config.EEGCutoffValue)+newline+newline);
            output_text= strcat(output_text,thinbraid);
            
            output_text= strcat(output_text,"Resccurence Plot Settings"+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"RecurrenceTreshold=" + num2str(config.RecurrenceThreshold)+newline+newline);
            output_text= strcat(output_text,thinbraid);
            
            output_text= strcat(output_text,"2D Topology Plot and Brain Activity Plot"+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"Video Frame Rate[fps]=" + num2str(config.UserFrameRate)+newline);
            output_text= strcat(output_text,"2D Topology Intervals[s]=" + num2str(config.UserFrameRate)+newline);
            output_text= strcat(output_text,"Brain Acivity Intervals[s]=" + num2str(config.UserFrameRate)+newline+newline);

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
            text(0.0,0.8,output_text{1},'FontName','FixedWidth','FontSize',8);
            print(fName,'-dpdf',fig,'-r0');
            close(fig);
        end
        
        %% Saves ADIndex settings to fName.pdf
        %   StimuInt: contains settings for all Stimulus Intervals
        %   fName: File name as String
        function writeAdIndex(self,StimuInt,fName)
            fatbraid="==================================================================================" + newline;
            thinbraid="----------------------------------------------------------------------------------" + newline;
            
            output_text = strcat(fatbraid,"---> AdIndex SETTINGS"+newline);
            output_text= strcat(output_text,fatbraid);
            output_text= strcat(output_text,"Stimulus length | Stimulus Type | Stimulus Description |         Stimulus Interval" + newline);
            output_text= strcat(output_text,thinbraid);
            
            %create textboxes
            for i = 1:length(StimuInt)
                
                %Stimulus length
                CharStimuLength = blanks(15);
                CharStimuLength([9:15]) = 'seconds';
                counter = length(num2str(StimuInt{1, i}.Stimulength));
                if counter == 1
                    CharStimuLength(7) = num2str(StimuInt{1, i}.Stimulength);
                elseif counter == 2
                    CharStimuLength(6:7) = num2str(StimuInt{1, i}.Stimulength);
                else
                    CharStimuLength(5:7) = num2str(StimuInt{1, i}.Stimulength);
                end
                
                %Stimulus type
                %create blank char array
                CharStimuType = blanks(13);
                CharStimuType([8:11]) = 'Type';
                CharStimuType(13) = num2str(StimuInt{1, i}.stimuIntType);
                
                %Stimulus Description
                CharStimuDesc = blanks(20);
                CharStartDesc = 20-length(StimuInt{1, i}.stimuIntDescrp)+1;
                CharStimuDesc([CharStartDesc:end]) = StimuInt{1, i}.stimuIntDescrp;
                
                %Stimulus Intervals
                CharStimuInt = blanks(26);            
                hold = num2str(StimuInt{1, i}.intervals);
                IntChar = '';
                for i = 1:length(hold)
                IntChar = append(IntChar,hold(i,:));
                IntChar = append(IntChar,' ');
                end
                CharStartInt = 26-length(IntChar)+1;
                CharStimuInt([CharStartInt:end]) = IntChar;
                
                %Save text
                output_text= strcat(output_text,[CharStimuLength ' | ' CharStimuType ' | ' CharStimuDesc ' | ' CharStimuInt]);
                output_text= strcat(output_text," " + newline);
            end                
         
            fig = figure('Visible','off');
            axes('Position',[0 0.1 1 1],'Visible','off');
            text(0.0,0.99,output_text{1},'FontName','FixedWidth','FontSize',8);
            print(fName,'-dpdf',fig,'-r0');
            close(fig);
        end
        
        %% Saves statistics as PDF
        %   stats: statistics as String
        %   fName: File name as String
        function writeStatistics(self,stats,fName)
            fig = figure('Visible','off');
            axes('Position',[0.0 0.0 1 1],'Visible','off');
            fig.PaperPositionMode='auto';
            text(0.0,0.85,stats,'FontName','FixedWidth','FontSize',6); %Changed font size to 6 (from 8) for displaying the whole text
            print(fName,'-dpdf',fig,'-r0');
            close(fig);
        end
        
        %% Saves in/valid Subjects and status
        %   index: index as String
        %   fName: File name as String
        function writeValid(self,index, fName)
            fig = figure('Visible','off');
            axes('Position',[0.1 0.1 1 1],'Visible','off');
            text(0.0,0.85,index,'FontName','FixedWidth','FontSize',10);
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
        
        
        %% Print 2D Topo of EEG Data
        %  Print of 2D Topology map over a certain timeframe
        %  config: contains all configs as String
        %  EEG: contains EEG Structur for topoplot function
        %  subject: contains all Subjects 
        %  StimuDef: Simulus Class, with length, type, definition
        %  electrodes: contains all used electrodes as String
        %  vidFrameReSize: Contains struct with each video frame     
        function printTopo(self,config,subject,EEG,StimuDef,electrodes,vidFrameReSize)            
            %Variables needed for loop
            numStimuInts = length(StimuDef);
            interval = config.TopoRange;
            subjectName = subject.name;
            TopoStart = 0;
            
            %loop for each StimuInt
            for i = 1:numStimuInts
                StimuInt = StimuDef{i};

                % video obj
                vName = [config.OutputDirectory '\2D_Topo' '/' subjectName '_' StimuInt.stimuIntDescrp '_2D Topo_Video.mp4'];
                vidObj = VideoWriter(vName);
                vidObj.Quality = 100;       
                vidObj.FrameRate = config.UserFrameRate; %get framerate from video

                %prepare print range
                TopoEnd = StimuInt.Stimulength*1000 + TopoStart;
                range = TopoStart:interval:TopoEnd;
                range = double(range);
                TopoStart = TopoEnd; %defined for the next loop

                %only print Type > 4 = Video/Images/Audio Stimulus
                if StimuInt.stimuIntType >= 4

                    %prepare data for print
                    SIGTMP = reshape(EEG.data, EEG.nbchan, EEG.pnts, EEG.trials);
                    pos = round((range/1000-EEG.xmin)/(EEG.xmax-EEG.xmin) * (EEG.pnts-1))+1;
                        if pos(end) == EEG.pnts+1
                            pos(end) = pos(end)-1; %Cut 1 so index of pnts and pos is ==
                        end
                    nanpos = find(isnan(pos));
                    pos(nanpos) = 1;
                    
                    %prepare task variable
                    numPos = length(pos)-1;
                    numValues = subject.eegValuesForElectrodes; 
                    numElec = length(numValues);
                    task = zeros(numElec,numPos);

                    %get TEI
                    for m = 1:numPos
                        for j = 1:numElec
                        %Theta(5-7 Hz)
                        theta(j) = mean(sqrt((eegfiltfft(SIGTMP(j,pos(m):pos(m+1),:),EEG.srate,5,7)).^2));
                        %Alpha(8-13 Hz)
                        alpha(j) = mean(sqrt((eegfiltfft(SIGTMP(j,pos(m):pos(m+1),:),EEG.srate,8,13)).^2));
                        %Beta1(14-24 Hz)
                        beta1(j) = mean(sqrt((eegfiltfft(SIGTMP(j,pos(m):pos(m+1),:),EEG.srate,14,24)).^2));
                        %Task-Engagement
                            if alpha(j) > 0 && theta(j) > 0
                            task(j,m) = beta1(j)/(alpha(j)+theta(j));
                            else
                            task(j,m) = zeros(1,length(range)-1);
                            end
                        end
                    end
                    
                    %loop preperation
                    numofprint = length(range)-1;
                    open(vidObj);
                    
                    for k = 1:numofprint
                        %print preparation
                        mainfig = figure('Visible','on');
                        set(mainfig,'PaperUnits','inches','PaperPosition',[0 0 12 7.5])
                        hold on

                        %Print of 2D Topo
                        subplot(2,2,3);
                        title({['AVG TEI between ' num2str(range(k)-range(1)) '-' num2str(range(k+1)-range(1)) 'ms'];...
                               ['in test range from ' num2str(range(k)) '-' num2str(range(k+1)) 'ms'               ]});
                        topoplot(task(:,k),EEG.chanlocs,'electrodes','ptslabels');
                        cb = colorbar;
                        cb.Limits = [0,1];

                        %print of histogram
                        barsimg = self.plotElectrodeBars(electrodes,pos(k),pos(k+1),SIGTMP,EEG.srate);    
                        barschart = subplot(2,2,4);
                        barschart.Position = barschart.Position + [-0.075 -0.075 0.15 0.15];
                        imshow(barsimg);

                        %Subplot title
                        sgtitle([StimuInt.stimuIntDescrp ' for subject ' subject.name]);

                        % Folgende Befehle beschleunigen das Plotten
                        % innerhalb der Schleife %englisch
                        set(gcf,'renderer','opengl') 
                        drawnow nocallbacks
                        for t = 1:vidObj.FrameRate
                            %insert video frames
                            videochart = subplot(2,2,[1 2]);
                            imshow(vidFrameReSize(:,:,:,t+(vidObj.FrameRate*(numofprint-1)))); %10 -> 30
                            
                            %save as image
                            fName = [config.OutputDirectory '\2D_Topo' '/' subjectName '_' StimuInt.stimuIntDescrp '_' num2str(range(k+1)) 'ms_2D Topo.png'];
                            print(fName,'-dpng','-r300',mainfig);
                            
                            %create video
                            writeVideo(vidObj, imread(fName));
                        end
                        %close figure
                        close
                    end     
                end
            end
        end
        
        %% Overview of all Simulus in one chart 
        %  Print of 2D Topology map over a certain timeframe
        %  config: contains all configs as String
        %  subject: contains all Subjects 
        %  EEG: contains EEG Structur for topoplot function
        %  StimuDef: Simulus Class, with length, type, definition
        function stimulusOverviewChart(self,config,subject,EEG,StimuDef)
            
            % Variables needed for loop
            numStimuInts = length(StimuDef);
            interval = config.BrainRange;
            TopoStart = 0;
            rangeALL = 0;
            StimulusIntervals = 0;
            StimuIntDefinitions = [];
            
            %main figure
            mainfig = figure('Visible','on');
            set(mainfig,'Units','pixels');
            
            %prepare vector to draw lines
            for i = 1:numStimuInts
                StimuInt = StimuDef{i};   
                if StimuInt.stimuIntType > 2
                    %Initialisation for first loop
                    if TopoStart == 0
                        rangeALL = double(StimuInt.Stimulength*1000);
                        TopoStart = double(StimuInt.Stimulength*1000);
                    end
                    %prepare print range
                    TopoEnd = StimuInt.Stimulength*1000 + TopoStart;
                    range = TopoStart:interval:TopoEnd;
                    range = double(range);
                    if range(end) ~= TopoEnd
                        range(end+1) = TopoEnd;
                    end
                    TopoStart = TopoEnd; %defined for the next loop

                    rangeALL = [rangeALL range(1,2:end)];
                    if StimulusIntervals == 0
                        StimulusIntervals = size(rangeALL);
                        StimulusIntervals(2) = StimulusIntervals(2)-1;
                    else
                        StimulusIntervals = [StimulusIntervals, StimulusIntervals(end)+1,length(rangeALL)-1];
                    end
                    
                    StimuIntDefinitions = [StimuIntDefinitions, convertCharsToStrings(StimuInt.stimuIntDescrp)];
                end
            end

            %prepare data for print
            SIGTMP = reshape(EEG.data, EEG.nbchan, EEG.pnts, EEG.trials);
            pos = round((rangeALL/1000-EEG.xmin)/(EEG.xmax-EEG.xmin) * (EEG.pnts-1))+1;
            if pos(end) == EEG.pnts+1
                pos(end) = pos(end)-1; %Cut 1 so index of pnts and pos is ==
            end
            nanpos = find(isnan(pos));
            pos(nanpos) = 1;

            %prepare task variable
            numPrints = length(pos)-1;
            numValues = subject.eegValuesForElectrodes; 
            numElec = length(numValues);
            task = zeros(numElec,numPrints);

            %get TEI
            for m = 1:numPrints
                for j = 1:numElec
                    %Theta(5-7 Hz)
                    theta(j) = mean(sqrt((eegfiltfft(SIGTMP(j,pos(m):pos(m+1),:),EEG.srate,5,7)).^2));
                    %Alpha(8-13 Hz)
                    alpha(j) = mean(sqrt((eegfiltfft(SIGTMP(j,pos(m):pos(m+1),:),EEG.srate,8,13)).^2));
                    %Beta1(14-24 Hz)
                    beta1(j) = mean(sqrt((eegfiltfft(SIGTMP(j,pos(m):pos(m+1),:),EEG.srate,14,24)).^2));
                    %Task-Engagement
                    if alpha(j) > 0 && theta(j) > 0
                        task(j,m) = beta1(j)/(alpha(j)+theta(j));
                    else
                        task(j,m) = zeros(1,length(range)-1);
                    end
                end
            end

            
            %print preparation
            sizey = 300; %height of image
            Pos = cell(1,numPrints); %vector for position
            topoX = 100; %X position of first head in print
            mainfig.Position = [mainfig.Position(1), mainfig.Position(2), numPrints*150 , sizey]; 
            
            for j = 1:numPrints
                %Print of 2D Topo
                topo = subplot(1,numPrints,j);
                topo.Units = 'pixels';
                topo.Position = [topoX, 40, 90, 90]; %set position
                topoplot(task(:,j),EEG.chanlocs,'electrodes','on');
                topoX = topoX + 110; %move X position for next head

                %get Positions of topo plots
                Pos{j} = topo.Position;
            end
            
            %set sizeX to mainfig position length
            sizex = mainfig.Position(3);
            
            %loop for legend
            counter = 1;
            for m = 1:(length(StimulusIntervals)/2)
                %get index for Pos vector
                lowindex = StimulusIntervals(counter);
                counter = counter + 1;
                index = StimulusIntervals(counter);
                counter = counter + 1;
                if length(Pos) > index
                    %get position of left/right
                    SubplotLeft = Pos{index};
                    SubplotRight = Pos{index+1};
                    %get X coordinate between both heads
                    x = ((SubplotLeft(1)+ SubplotLeft(3) + SubplotRight(1))/2)/sizex;%convert from pixels to normazied unit
                else
                    SubplotLeft = Pos{index};
                    x = (SubplotLeft(1) + SubplotLeft(3))/sizex;
                end
                y = SubplotLeft(2)/sizey; %convert from pixels to normazied unit
                %timestamp line
                timeLine = annotation('line',[x,x],[0.6,y]);
                timeLine.LineWidth = 1;
                %timestamp text
                str = strcat(num2str(rangeALL(index+1)-rangeALL(1)),' ms');
                timestamp = annotation('textbox',[x,0.035,0.1,0.1],'String',str,'EdgeColor','none','FitBoxToText','on');
                drawnow %force figure update
                %move text for half its size, because start getting printed on X position
                timestamp.Position = timestamp.Position - [(timestamp.Position(3)/2),0,0,0];
                
                %dotted lines for clarity 
                numOfLines = (index - lowindex);
                linesPos = lowindex;
                for k = 1:numOfLines
                    if length(Pos) > linesPos
                        SubplotLeft = Pos{linesPos};
                        SubplotRight = Pos{linesPos+1};
                        x = ((SubplotLeft(1)+ SubplotLeft(3) + SubplotRight(1))/2)/sizex;%convert to normazied unit
                    else
                        SubplotLeft = Pos{linesPos};
                        x = (SubplotLeft(1) + SubplotLeft(3))/sizex;
                    end
                    y = SubplotLeft(2)/sizey; %convert to normazied unit
                    %line
                    tickLines = annotation('line',[x,x],[0.6,y]);
                    tickLines.Color = 'b'; %blue
                    tickLines.LineStyle = '--'; %dotted
                    tickLines.LineWidth = 0.25; 
                    linesPos = linesPos + 1;
                    
                    %timestamp text
                    if length(rangeALL) > linesPos
                    str = strcat(num2str(rangeALL(linesPos)-rangeALL(1)),' ms');
                    addLines = annotation('textbox',[x,0.035,0.1,0.1],'String',str,'EdgeColor','none','FitBoxToText','on','FontSize', 8);
                    drawnow
                    addLines.Position = addLines.Position - [(addLines.Position(3)/2),0,0,0];
                    end
                end
                
                %Stimulus definiton text
                %get Stimulus
                str = StimuIntDefinitions(m);
                %get position of first and last head of Interval
                if length(Pos) > index
                    SubplotLeft = Pos{lowindex};
                    SubplotRight = Pos{index};
                else
                    SubplotLeft = Pos{lowindex};
                    SubplotRight = Pos{index-1};
                end
                %get x for middle of this interval
                x = ((SubplotLeft(1) + SubplotRight(1) + SubplotRight(3))/2)/sizex;
                StimulusDefinition = annotation('textbox',[x,0.575,0.1,0.1],'String',str,'EdgeColor','none','FitBoxToText','on');
                drawnow
                %move text for half its size
                StimulusDefinition.Position = StimulusDefinition.Position - [(StimulusDefinition.Position(3)/2),0,0,0];
            end
            
            %upper horizontal timeline
            SubplotLeft = Pos{1};
            SubplotRight = Pos{end};
            x1 = SubplotLeft(1)/sizex;
            x2 = (SubplotRight(1)+SubplotRight(3))/sizex;
            timeLine = annotation('line',[x1,x2],[0.6,0.6]);
            timeLine.LineWidth = 1;
            
            %first timestamp line
            SubplotTopo = Pos{1};
            x = SubplotTopo(1)/sizex;
            y = SubplotTopo(2)/sizey;
            timeLine = annotation('line',[x,x],[0.6,y]);
            timeLine.LineWidth = 1;
            %first timestamp text
            timestamp = annotation('textbox',[x,0.035,0.1,0.1],'String','0 ms','EdgeColor','none');
            drawnow
            timestamp.Position = timestamp.Position - [(timestamp.Position(3)/2),0,0,0];
            
            %Subplot title
            str = 'Per Electrode Brain Activity over all Stimulus Intervals';
            x = (SubplotRight(1)+SubplotRight(3)-100)/2/sizex;
            annotation('textbox',[x,0.8,0.1,0.1],'String',str,'EdgeColor','none','FitBoxToText','on');
   
            %save as pdf
            newWidth = SubplotRight(1)+ SubplotRight(3) + 100; %get right width of image
            fName = [config.OutputDirectory '\' subject.name '_Brain activity over entire stimulus period.png'];
            set(gcf,'color','w');
            F = getframe(mainfig); %get frame of figure
            ImageSize = size(F.cdata); %get length of figure
            F.cdata(:,newWidth:ImageSize(2),:) = []; %delete empty pixel
            imwrite(F.cdata, fName, 'png');
            
            %close figure
            close
        end
        
        %% Prints of electrode frequency
        % electrodes: List of used electrodes
        % startpos/endpos: Range of the printed data
        % data: data
        % srate: Frequency of the device used
        function barsimg = plotElectrodeBars(self,electrodes,startpos,endpos,data,srate)
            
            %prepare plot
            numelec = length(electrodes);
            barsfig = figure('visible','off','DefaultAxesFontSize',12);
            set(barsfig,'color','w');
            set(barsfig,'Position', [1, 1, 1200, 1200]);
            data = data(:,startpos:endpos);
            
            %get frequency bands
            for i = 1:numelec
                %Delta (1-4 Hz)
                delta(i) = mean(sqrt((eegfiltfft(data(i,:),srate,1,4)).^2));
                %Theta(5-7 Hz)
                theta(i) = mean(sqrt((eegfiltfft(data(i,:),srate,5,7)).^2));
                %Alpha(8-13 Hz)
                alpha(i) = mean(sqrt((eegfiltfft(data(i,:),srate,8,13)).^2));
                %Beta1(14-24 Hz)
                beta1(i) = mean(sqrt((eegfiltfft(data(i,:),srate,14,24)).^2));
                %Beta2(25-40 Hz)
                beta2(i) = mean(sqrt((eegfiltfft(data(i,:),srate,25,40)).^2));
            end
            allfreq = [delta theta alpha beta1 beta2];
            ymax = max(max(allfreq)); %y max for graph
            
            %Print
            for i = 1:numelec
                hold on
                %create subplot for each electrode
                subplot(3,3,i);
                names = categorical({'delta','theta','alpha','beta1','beta2'});
                names = reordercats(names,{'delta','theta','alpha','beta1','beta2'});
                bars = [delta(i), theta(i), alpha(i), beta1(i), beta2(i)];
                h = bar(names,bars,'FaceColor','flat');
                ylim([0 ymax]);
                title(electrodes(i),'FontSize', 24)
                %recolor bars
                h.CData(1,:) = [1 0 0];
                h.CData(2,:) = [0.8500 0.3250 0.0980];
                h.CData(3,:) = [0.9290 0.6940 0.1250];
                h.CData(4,:) = [0 1 0];
                h.CData(5,:) = [0.3010 0.7450 0.9330];
            end
            
            %save as img
            barsFrame = getframe(barsfig);
            barsimg = barsFrame.cdata;
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
        
        %% Prints recurrence plots for EDA
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
            title(['Behavioral characteristics for subject' subjectName ' ' stimuIntDescrp]);
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
            fName = [outputDir '/' subjectName '_' stimuIntDescrp '_characteristics.pdf'];
            print(fName,'-dpdf',fig);
            close(fig);
        end      
        
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
            print([config.OutputDirectory '/' subject.name '_' char(electrode) '_EEG.pdf'],'-dpdf',fig);
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
                StimuIntLength = StimuIntDefs{StimuIntNum}.Stimulength;
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
            axes('Position',[.08 .10 0.8 1],'Visible','off'); %Tim Position Hardcoded bei mehr Stimus kommt es zu Problemen! 
            text(0,0,stats,'FontName','FixedWidth','FontSize',8);
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
                completeVidLength = completeVidLength + StimuIntDef{i}.Stimulength;
                StimuIntLabels{i} = ['StimuInt' num2str(i)];
                if i==1
                    StimuIntStartPoints(i) = 0;
                else
                    StimuIntStartPoints(i) = StimuIntDef{i-1}.Stimulength + StimuIntStartPoints(i-1);
                end
                curIntervals = StimuIntDef{i}.intervals;
                curIntervals= curIntervals + StimuIntStartPoints(i);
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

