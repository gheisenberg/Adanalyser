% Performs different plots
%   Gets utilized by diffferent other functions
%   Plots settings of the GUI
%   Plots settings of the different stimulus
%   Plots statistics 
%   Plots valid/invalid tabel of subjects
%   Plots 2D Topology Maps
%   Plots Brain Activity 
%   Plots quality figures and HRV/EDA figues
%
% Author: Gernot Heisenberg, Tim Kreitzberg
%


classdef Plotter
    methods
        
        %% Saves all GUI and DEVICE settings to fName.pdf
        %   config: contains all configs as String
        %   fName: File name as String
        %   Devices: contains settings of different devices
        function writeSettings(self,config,eegDevice,edaDevice,hrvDevice, fName)    
            fatbraid="===========================================================" + newline;
            thinbraid="------------------------------------------------------" + newline;
            
            output_text= strcat(fatbraid,"---> GUI SETTINGS"+newline);
            output_text= strcat(output_text,fatbraid);
            
            % hardcoded structure of the settings sheet
            % each section gets seperated by a fat/thinbraid
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
            output_text= strcat(output_text,"HRVRecurrence=" + num2str(config.HRVRecurrence)+newline);
            output_text= strcat(output_text,"EDARecurrence=" + num2str(config.EDARecurrence)+newline);
            output_text= strcat(output_text,"QualityFig=" + num2str(config.QualityFig)+newline);
            output_text= strcat(output_text,"FrequencyFig=" + num2str(config.FrequencyFig)+newline);
            output_text= strcat(output_text,"Statistics=" + num2str(config.Statistics)+newline);
            output_text= strcat(output_text,"TopologyPlot=" + num2str(config.topoplot)+newline);
            output_text= strcat(output_text,"BrainActivityPlot=" + num2str(config.brainactivity)+newline+newline);
            
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"Data Export Settings"+newline);
            output_text= strcat(output_text,thinbraid);
            output_text= strcat(output_text,"EEGData=" + num2str(config.EEGData)+newline);
            output_text= strcat(output_text,"EDAData=" + num2str(config.EDAData)+newline);
            output_text= strcat(output_text,"HRVData=" + num2str(config.HRVData)+newline);
            output_text= strcat(output_text,"SignalSpectra=" + num2str(config.signalSpec)+newline+newline);
            
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
            output_text= strcat(output_text,"Electrode Positions=" + eegDevice.electrodePositions);
            
            if length(config.electrodes) > 1
                electrodes = config.electrodes;
                for indexElec = 2:length(electrodes)
                    output_text= strcat(output_text,", " + electrodes(indexElec));
                end
            end
            output_text= strcat(output_text,""+newline);
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
            % set it full size for pdf page
            set(fig,'Units','centimeters');
            fig.Position = [0,0,20.635, 29.35];
            descrp = text(0.1,0.9,output_text{1},'FontName','FixedWidth','FontSize',8);
            descrp.VerticalAlignment = 'top';
            
            print(fName,'-dpdf',fig,'-r0');
            close(fig);
        end
        
        %% Saves ADIndex settings to fName.pdf
        %   StimuInt: contains settings for all Stimulus Intervals
        %   fName: File name as String
        function writeAdIndex(self,StimulusInterval,fName)
            fatbraid="==================================================================================" + newline;
            thinbraid="----------------------------------------------------------------------------------" + newline;
            
            output_text = strcat(fatbraid,"---> AdIndex SETTINGS"+newline);
            output_text= strcat(output_text,fatbraid);
            output_text= strcat(output_text,"Stimulus length | Stimulus Type | Stimulus Description |         Stimulus Interval" + newline);
            output_text= strcat(output_text,thinbraid);
            
            % create textboxes
            for indexStimu = 1:length(StimulusInterval)
                % Creates blanks to create a certain structure in the 
                % AdIndex file - see AdIndex.pdf
                
                % Stimulus length
                CharStimuLength = blanks(15);
                CharStimuLength(9:15) = 'seconds';
                % Maintain the length of the stimulus and place it in the 
                % respective place
                % 1 = 1 digit number, 2 digit number or 3 digit number
                lengthOfStimlus = length(num2str(StimulusInterval{1, indexStimu}.Stimulength));
                if lengthOfStimlus == 1 
                    CharStimuLength(7) = num2str(StimulusInterval{1, indexStimu}.Stimulength);
                elseif lengthOfStimlus == 2
                    CharStimuLength(6:7) = num2str(StimulusInterval{1, indexStimu}.Stimulength);
                elseif lengthOfStimlus == 3
                    CharStimuLength(5:7) = num2str(StimulusInterval{1, indexStimu}.Stimulength);
                else
                    CharStimuLength(4:7) = num2str(StimulusInterval{1, indexStimu}.Stimulength);
                end
                
                % Stimulus type
                % create blank char array
                % type allways have to be a one digit number
                CharStimuType = blanks(13);
                CharStimuType(8:11) = 'Type';
                CharStimuType(13) = num2str(StimulusInterval{1, indexStimu}.stimuIntType);
                
                % Stimulus Description
                % the chars have to be place accordingly to their length,
                % therefor a 20 char vector gets created, substracted the
                % individual length of the Stimlus Interval and set on the
                % respective place
                CharStimuDesc = blanks(20);
                CharStartDesc = 20-length(StimulusInterval{1, indexStimu}.stimuIntDescrp)+1;
                CharStimuDesc(CharStartDesc:end) = StimulusInterval{1, indexStimu}.stimuIntDescrp;
                
                % Stimulus Intervals
                CharStimuInt = blanks(26);            
                hold = num2str(StimulusInterval{1, indexStimu}.intervals);
                IntChar = '';
                % loop through all interval chars and seperate them with a
                % ' '
                numInt = size(hold);
                for index = 1:numInt(1)
                    IntChar = append(IntChar,hold(index,:));
                    IntChar = append(IntChar,' ');
                end
                CharStartInt = 26-length(IntChar)+1;
                CharStimuInt(CharStartInt:end) = IntChar;
                
                % Save text
                output_text= strcat(output_text,[CharStimuLength ' | ' CharStimuType ' | ' CharStimuDesc ' | ' CharStimuInt]);
                output_text= strcat(output_text," " + newline);
            end                
            
            %plots data to pdf
            fig = figure('Visible','off');
            axes('Position',[0 0.1 1 1],'Visible','off');
            % set it full size for pdf page
            set(fig,'Units','centimeters');
            fig.Position = [0,0,20.635, 29.35];
            descrp = text(0.1,0.9,output_text{1},'FontName','FixedWidth','FontSize',8);
            descrp.VerticalAlignment = 'top';
            
            print(fName,'-dpdf',fig,'-r0');
            close(fig);
        end
        
        %% Saves in/valid Subjects and status
        %   index: index as String
        %   fName: File name as String
        function writeValid(self,index,fName)
            header = index(1:3);
            index = index(4:end);
            numberOfPages = ceil(length(index)/50);
                
            for indexPage = 1:numberOfPages
                % setup fig
                fig = figure('Visible','off');
                axes('Position',[0.1 0.1 1 1],'Visible','off');
                fig.PaperPositionMode='auto';
                % set it full size for pdf page
                set(fig,'Units','centimeters');
                fig.Position = [0,0,20.635, 29.35];
                
                % get index for subject < 50
                if numberOfPages == 1
                    pageNum = index(1:end);
                
                % subject > 50
                % get first 50 subjects
                elseif indexPage == 1
                    pageNum = index(1:50);
                    
                % subjects for the last page
                elseif indexPage == numberOfPages
                    pageNum = index(50*(indexPage-1):end);
                    
                % get all subjects in the middel
                else
                    pageNum = index(50*indexPage-1:50*indexPage);
                    
                end

                % print fig and save as pdf
                pageNum = cat(1,header,pageNum);
                descrp = text(0,0.9,pageNum,'FontName','FixedWidth','FontSize',8);
                descrp.VerticalAlignment = 'top';
                if numberOfPages == 1
                    fNamePage = [fName(1:length(fName)-4) '.pdf'];
                else
                    fNamePage = [fName(1:length(fName)-4) '_' num2str(indexPage) '.pdf'];
                end
                print(fNamePage,'-dpdf',fig,'-r0','-fillpage');
            end
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
        function printTopo(self,config,subject,StimuDef)
            % Variables needed for loop
            EEG = subject.EEG;
            electrodes = config.electrodes;
            numStimuInts = length(StimuDef);
            interval = config.TopoRange;
            subjectName = subject.name;
            
            %create subfolder
            subfolder_name = '2D_TopologyMap';
                
            if ~exist([subject.OutputDirectory '\' subfolder_name], 'dir')
                parentfolder = subject.OutputDirectory;
                mkdir(fullfile(parentfolder, subfolder_name));
            end
            
            % loop for each Stimulus Interval
            for indexStimu = 1:numStimuInts
                StimuInt = StimuDef{indexStimu};
                
                % video obj
                vName = [subject.OutputDirectory '\' subfolder_name '/' subjectName '_' StimuInt.stimuIntDescrp '_2D Topo_Video.mp4'];
                vidObj = VideoWriter(vName);
                vidObj.Quality = 100;       
                vidObj.FrameRate = config.UserFrameRate; % get framerate from video
                
                StimulusEnd = StimuInt.Stimulength *1000;
                range = 0:interval:StimulusEnd;
                
                % only print Type > 4 = Video/Images/Audio Stimulus
                if StimuInt.stimuIntType >= 4
                    
                    % prepare video for print
                    fileDirectory = [config.videoString '\' StimuInt.stimuIntDescrp '.mp4']; % get directory
                    %fileDirectory = regexprep(fileDirectory, ' ', '_');
                    videoFReader = vision.VideoFileReader(fileDirectory);
                    %vid = VideoReader(fileDirectory); % import video
                    %numOfFrames = vid.NumFrames; % calculate number of frames
                    %vidFrame = read(vid,[1 numOfFrames]);
                    % resize video according to UserFrameRate
                    %vidFrameReSize = vidFrame(:,:,:,round(1:vid.FrameRate/config.UserFrameRate:end));
                                       
                    pos = range/1000*EEG.srate;
                    pos(pos == 0) = 1; 
                    
                    % prepare task variable
                    numPos = length(pos)-1;
                    numValues = subject.eegDataPerElectrode; 
                    numElec = length(numValues);
                    task = zeros(numElec,numPos);

                    % get TEI 
                    % looping through all position and electrodes
                    % eegSpecBandPerStim{indexStimu,6} -> the 6th row
                    % contains the values for the TEI - see EEGData.m and
                    % EEGDataPerElectrode.m
                    for indexPos = 1:numPos
                        for indexElec = 1:numElec
                            task(indexElec,indexPos) = mean(subject.eegDataPerElectrode{indexElec}.eegSpecBandPerStim{indexStimu,6}(pos(indexPos):pos(indexPos+1)));
                        end
                    end
                    
                    % loop preperation
                    numofprint = length(range)-1;
                    if config.videoOutput == 1
                        open(vidObj);
                    end
                    
                    for indexPrint = 1:numofprint
                        % print preparation
                        mainfig = figure('Visible','on');
                        set(mainfig,'PaperUnits','inches','PaperPosition',[0 0 12 7.5])
                        hold on

                        % Print of 2D Topo
                        subplot(2,2,3);
                        % double () in case we want to add a multiplier
                        title({['AVG TEI between ' num2str(range(indexPrint)) '-' num2str(range(indexPrint+1)) 'ms']});
                        % topoplot is a function of the eeglab libary
                        topoplot(task(:,indexPrint),EEG.chanlocs,'electrodes','ptslabels');
                        cb = colorbar;
                        cb.Limits = [0,1];

                        % print of histogram
                        barsimg = self.plotElectrodeBars(electrodes,subject.eegDataPerElectrode,[pos(indexPrint) pos(indexPrint+1)],indexStimu);
                        barschart = subplot(2,2,4);
                        barschart.Position = barschart.Position + [-0.075 -0.075 0.15 0.15];
                        imshow(barsimg);

                        % Subplot title
                        sgtitle([StimuInt.stimuIntDescrp ' for subject ' subject.name]);
                        
                        % print out first frame
                        subplot(2,2,[1 2]);
                        imshow(videoFReader());
                        fName = [subject.OutputDirectory '\' subfolder_name '/' subjectName '_' StimuInt.stimuIntDescrp '_' num2str((range(indexPrint+1))) 'ms_2D Topo.png'];
                        print(fName,'-dpng','-r300',mainfig);
                        
                        if config.videoOutput == 1
                            % set render to opengl
                            set(mainfig,'units','pixels','position',[0 0 640 480]) 
                            set(gcf,'renderer','opengl') 
                            drawnow nocallbacks
                            
                            %create video in plot
                            for indexFrame = 1:vidObj.FrameRate
                                % insert video frames
                                subplot(2,2,[1 2]);
                                %imshow(vidFrameReSize(:,:,:,indexFrame+(vidObj.FrameRate*indexPrint)));
                                imshow(videoFReader());
                                
                                % get frame from figure
                                currentFrame = getframe(mainfig);
                                
                                % create video
                                writeVideo(vidObj, currentFrame);
                            end
                        end
                        % close figure
                        close
                    end     
                end
            end
        end
        
        %% Overview of all Simulus in one chart 
        %  Print of 2D Topology map over a certain timeframe
        %  The plots are strung together over the entire time frame of the 
        %  experiment and divided into their stimlus intervals
        
        %  config: contains all configs as String
        %  subject: contains all Subjects 
        %  EEG: contains EEG Structur for topoplot function
        %  StimuDef: Simulus Class, with length, type, definition
        function stimulusOverviewChart(self,config,subject,StimuDef,StimulusIndex) 
            % Variables needed for loop
            EEG = subject.EEG;
            interval = config.BrainRange;
            StimuIntDefinitions = [];
            numElec = length(config.electrodes);
            numStimuInt = length(StimulusIndex);
            
            % prelocate size of vectors for speed
            totalLength = 0;
            taskcounter = 0;
            for indexStimu = StimulusIndex
                totalLength = StimuDef{1, indexStimu}.Stimulength + totalLength;
            end
            numPrints = (totalLength*1000)/interval;
            task = zeros(numElec,numPrints);
            
            % prelocate time
            time = 0:interval:totalLength*1000;
                
            % prepare vector to draw lines
            for indexStimu = StimulusIndex
                
                % get current Stimulus Interval
                StimuInt = StimuDef{indexStimu};
                    
                % get first and last postioin of each Stimulus Interval
                StimulusIntervals = zeros(1,numStimuInt*2);
                preNumber = 2;
                for indexStimuLines = 2:2:numStimuInt*2
                    StimulusIntervals(indexStimuLines-1) = 1 + StimulusIntervals(preNumber);
                    StimulusIntervals(indexStimuLines) = (StimuInt.Stimulength*1000)/interval + StimulusIntervals(preNumber);
                    preNumber = indexStimuLines;
                end
                
                % save the Name
                StimuIntDefinitions = [StimuIntDefinitions, convertCharsToStrings(StimuInt.stimuIntDescrp)];
                
                % get postions for TEI
                StimulusEnd = StimuInt.Stimulength *1000;
                invervalStim = 0:interval:StimulusEnd;

                pos = invervalStim/1000*EEG.srate;
                pos(pos == 0) = 1;

                for indexTask = 1:length(invervalStim)-1
                    taskcounter = taskcounter + 1;
                    for indexElec = 1:numElec
                        task(indexElec,taskcounter) = mean(subject.eegDataPerElectrode{indexElec}.eegSpecBandPerStim{indexStimu,6}(pos(indexTask):pos(indexTask+1)));
                    end
                end
            end

            % print preparation
            sizey = 300; % height of image
            numPrints = length(task);
            Pos = cell(1,numPrints); % vector for position
            sizex = numPrints*150;
            indexTask = 1;
            
            topoPerLine = 8; % fixed for the res of 1280
            topoLines = 5; % fiex for the res of 1024
            topoPerPlot = topoPerLine * topoLines; 
            
            % get needed number of plots
            numberOfPlot = ceil(numPrints/topoPerPlot);
            
            for indexPlot = 1:numberOfPlot
                
                % main figure
                mainfig = figure('Visible','on');
                set(mainfig,'Units','pixels');
                mainfig.Position = [0, 0, 1250, 900];
                
                topoX = 25; % X position of first head in print
                topoY = 700; % Y position for the first row of heads
                
                for indexLines = 1:topoLines
                    for indexTopos = 1:topoPerLine
                        % Print of 2D Topo
                        topo = subplot(topoLines,topoPerLine,indexTask);
                        topo.Units = 'pixels';
                        topo.Position = [topoX, topoY, 100, 100]; % set position
                        % topoplot is a function of the eeglab libary
                        topoplot(task(:,indexTask),EEG.chanlocs,'electrodes','on');
                        drawnow;
                        topoX = topoX + 150; % move X position for next head

                        % get Positions of topo plots
                        Pos{indexTask} = topo.Position;

                        indexTask = indexTask + 1;
                        
                        if indexTask == numPrints
                           break 
                        end
                    end
                    if indexTask == numPrints
                       break 
                    end
                    topoX = 25;
                    topoY = topoY - 150;
                end
                indexTask = 1;
                set(gcf,'color','w');
                F = getframe(mainfig); % get frame of figure

                % save as png
                fName = [subject.OutputDirectory '\' subject.name '_Brain activity over entire stimulus period' int2str(indexPlot) '.png'];
                imwrite(F.cdata, fName, 'png');
                
                close
            end
%             
%             % set sizeX to mainfig position length
%             % will be needed to position the topoplots accordingly
%             sizex = mainfig.Position(3);
%             
%             % loop for legend in topoplot
%             indexTask = 1;
%             for indexPlot = 1:(length(StimulusIntervals)/2)
%                 % get index for Postions vector
%                 lowindex = StimulusIntervals(indexTask); % last topoplot
%                 indexTask = indexTask + 1;
%                 index = StimulusIntervals(indexTask); % latest topoplot
%                 indexTask = indexTask + 1;
%                 if length(Pos) > index
%                     % get position of figures left/right
%                     SubplotLeft = Pos{index};
%                     SubplotRight = Pos{index+1};
%                     % get X coordinate between both heads
%                     x = ((SubplotLeft(1)+ SubplotLeft(3) + SubplotRight(1))/2)/sizex;% convert from pixels to normazied unit
%                 else
%                     SubplotLeft = Pos{index};
%                     x = (SubplotLeft(1) + SubplotLeft(3))/sizex;
%                 end
%                 y = SubplotLeft(2)/sizey; % convert from pixels to normazied unit
%                 % timestamp line for each interval
%                 timeLine = annotation('line',[x,x],[0.6,y]);
%                 drawnow 
%                 %pause(drawforce) % force figure update
%                 timeLine.LineWidth = 1;
%                 % timestamp text
%                 str = strcat(num2str(time(index+1)),' ms');
%                 timestamp = annotation('textbox',[x,0.035,0.1,0.1],'String',str,'EdgeColor','none','FitBoxToText','on');
%                 drawnow 
%                 %pause(drawforce) % force figure update
%                 % move text for half its size, because start getting printed on X position
%                 timestamp.Position = timestamp.Position - [(timestamp.Position(3)/2),0,0,0];
%                 
%                 % dotted lines for clarity between each head of the same
%                 % interval
%                 numOfLines = (index - lowindex);
%                 linesPos = lowindex;
%                 for indexLines = 1:numOfLines
%                     if length(Pos) > linesPos
%                         SubplotLeft = Pos{linesPos};
%                         SubplotRight = Pos{linesPos+1};
%                         x = ((SubplotLeft(1)+ SubplotLeft(3) + SubplotRight(1))/2)/sizex;% convert to normazied unit
%                     else
%                         SubplotLeft = Pos{linesPos};
%                         x = (SubplotLeft(1) + SubplotLeft(3))/sizex;
%                     end
%                     y = SubplotLeft(2)/sizey; % convert to normazied unit
%                     % line
%                     tickLines = annotation('line',[x,x],[0.6,y]);
%                     drawnow 
%                     %pause(drawforce) % force figure update
%                     tickLines.Color = 'b'; % blue
%                     tickLines.LineStyle = '--'; % dotted
%                     tickLines.LineWidth = 0.25; 
%                     linesPos = linesPos + 1;
%                     
%                     % timestamp text
%                     if length(time) > linesPos
%                     str = strcat(num2str(time(linesPos)),' ms');
%                     addLines = annotation('textbox',[x,0.035,0.1,0.1],'String',str,'EdgeColor','none','FitBoxToText','on','FontSize', 8);
%                     drawnow 
%                     %pause(drawforce) % force figure update
%                     addLines.Position = addLines.Position - [(addLines.Position(3)/2),0,0,0];
%                     end
%                 end
%                 
%                 % Stimulus definiton text
%                 % get Stimulus
%                 str = StimuIntDefinitions(indexPlot);
%                 % get position of first and last head of Interval
%                 if length(Pos) > index
%                     SubplotLeft = Pos{lowindex};
%                     SubplotRight = Pos{index};
%                 else
%                     SubplotLeft = Pos{lowindex};
%                     SubplotRight = Pos{index-1};
%                 end
%                 % get x for middle of this interval
%                 x = ((SubplotLeft(1) + SubplotRight(1) + SubplotRight(3))/2)/sizex;
%                 StimulusDefinition = annotation('textbox',[x,0.575,0.1,0.1],'String',str,'EdgeColor','none','FitBoxToText','on');
%                 drawnow 
%                 %pause(drawforce)
%                 % move text for half its size
%                 StimulusDefinition.Position = StimulusDefinition.Position - [(StimulusDefinition.Position(3)/2),0,0,0];
%             end
%             
%             % upper horizontal timeline
%             SubplotLeft = Pos{1};
%             SubplotRight = Pos{end};
%             x1 = SubplotLeft(1)/sizex;
%             x2 = (SubplotRight(1)+SubplotRight(3))/sizex;
%             timeLine = annotation('line',[x1,x2],[0.6,0.6]);
%             drawnow 
%             %pause(drawforce) % force figure update
%             timeLine.LineWidth = 1;
%             
%             % first timestamp line
%             SubplotTopo = Pos{1};
%             x = SubplotTopo(1)/sizex;
%             y = SubplotTopo(2)/sizey;
%             timeLine = annotation('line',[x,x],[0.6,y]);
%             drawnow 
%             %pause(drawforce) % force figure update
%             timeLine.LineWidth = 1;
%             % first timestamp text
%             timestamp = annotation('textbox',[x,0.035,0.1,0.1],'String','0 ms','EdgeColor','none');
%             drawnow 
%             %pause(drawforce)
%             timestamp.Position = timestamp.Position - [(timestamp.Position(3)/2),0,0,0];
%             
%             % Subplot title
%             str = 'Per Electrode Brain Activity over all Stimulus Intervals';
%             x = (SubplotRight(1)+SubplotRight(3)-SubplotLeft(1))/2/sizex;
%             annotation('textbox',[x,0.8,0.1,0.1],'String',str,'EdgeColor','none','FitBoxToText','on');
%             drawnow 
%    
%             % cut the mainfig
%             newWidth = SubplotRight(1)+ SubplotRight(3) + 100; % get right width of image
%             set(gcf,'color','w');
%             F = getframe(mainfig); % get frame of figure
%             ImageSize = size(F.cdata); % get length of figure
%             F.cdata(:,newWidth:ImageSize(2),:) = []; % delete empty pixel
%             
%             % save as png
%             fName = [subject.OutputDirectory '\' subject.name '_Brain activity over entire stimulus period.png'];
%             imwrite(F.cdata, fName, 'png');
%             
%             % close figure
%             close
        end
        
        %% Prints of electrode frequency
        % electrodes: List of used electrodes
        % startpos/endpos: Range of the printed data
        % data: data
        % srate: Frequency of the device used
        function barsimg = plotElectrodeBars(self,electrodes,data,pos,Stimulus)
            % prepare plot
            numelec = length(electrodes);
            barsfig = figure('visible','off','DefaultAxesFontSize',12);
            set(barsfig,'color','w');
            set(barsfig,'Position', [1, 1, 1200, 1200]);
            
            delta = zeros(1,numelec);
            theta = zeros(1,numelec);
            alpha = zeros(1,numelec);
            beta1 = zeros(1,numelec);
            beta2 = zeros(1,numelec);
            
            for indexElec = 1:numelec
                % Delta (1-4 Hz)
                delta(indexElec) = mean(data{indexElec}.eegSpecBandPerStim{Stimulus,1}(pos(1):pos(2)));                              
                % Theta(5-7 Hz)
                theta(indexElec) = mean(data{indexElec}.eegSpecBandPerStim{Stimulus,2}(pos(1):pos(2)));
                % Alpha(8-13 Hz)
                alpha(indexElec) = mean(data{indexElec}.eegSpecBandPerStim{Stimulus,3}(pos(1):pos(2)));
                % Beta1(14-24 Hz)
                beta1(indexElec) = mean(data{indexElec}.eegSpecBandPerStim{Stimulus,4}(pos(1):pos(2)));
                % Beta2(25-40 Hz)
                beta2(indexElec) = mean(data{indexElec}.eegSpecBandPerStim{Stimulus,5}(pos(1):pos(2)));
            end
            
            allfreq = [delta theta alpha beta1 beta2];
            ymax = max(max(allfreq)); % y max for graph
            
            % Print
            for indexElec = 1:numelec
                hold on
                % create subplot for each electrode
                subplot(3,3,indexElec);
                names = categorical({'delta','theta','alpha','beta1','beta2'});
                names = reordercats(names,{'delta','theta','alpha','beta1','beta2'});
                bars = [delta(indexElec), theta(indexElec), alpha(indexElec), beta1(indexElec), beta2(indexElec)];
                h = bar(names,bars,'FaceColor','flat');
                ylim([0 ymax]);
                title(electrodes(indexElec),'FontSize', 24)
                % recolor bars
                h.CData(1,:) = [1 0 0];
                h.CData(2,:) = [0.8500 0.3250 0.0980];
                h.CData(3,:) = [0.9290 0.6940 0.1250];
                h.CData(4,:) = [0 1 0];
                h.CData(5,:) = [0.3010 0.7450 0.9330];
            end
            
            % save as img
            barsFrame = getframe(barsfig);
            barsimg = barsFrame.cdata;
        end
        
        %% Prints recurrence plots for HRV
        %  subjectName: Name of the Subject as String
        %  config: Config 
        %  StimuIntName: String
        %  hrvData: HRV values for Subject as double[] 
        function plotHRVRecurrence(self,subject,config,StimuIntName,hrvData,StimuIntDefs)
            % get the timestamps for each interval over the hole timeframe
            % see function for further explanation
            [~,~,intervals,~] = self.calculateStimuIntStartPointsAndIntervals(StimuIntDefs);
            N = length(hrvData);
            S = zeros(N, N);
            time = 1:N; % zeros(N,1);
            %  Calculate time in seconds for x axis
            % for i=1:N
            %     time(i) = round(sum(hrvData(1:i))/1000);
            % end
            % create Recurrence plot
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
            % get length of Axis
            ax = gca;
            % plot marker for the intervals
            self.plotIntervals(intervals,[0, ax.YLim(2)],1,[],'r');
            title(['Distance map of ' StimuIntName ' phase space trajectory for subject' subject.name]);
            
            % plot distance map based on Recurrence plot
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
            self.plotIntervals(intervals,[0, ax.YLim(2)],1,[],'r');
            title([StimuIntName ' recurrence plot for subject ' subject.name ' with threshold ' num2str(maxDiff)]);
            % file name
            fName = [subject.OutputDirectory '/' subject.name '_' StimuIntName '_recurrence.pdf'];
            print(fName,'-dpdf',fig);
        end
        
        %% Prints recurrence plots for EDA
        %  subjectName: Name of the Subject as String
        %  config: Config 
        %  StimuIntName: String
        %  edaData: EDA values for Subject as double[] 
        function plotEDARecurrence(self,subject,config,StimuIntDefs,edaData,edaDevice)
            % get the timestamps for each interval over the hole timeframe
            % see function for further explanation
            [~,~,intervals,~] = self.calculateStimuIntStartPointsAndIntervals(StimuIntDefs);
            
            SamplingRate=edaDevice.samplingRate;
            N = length(edaData);
            S = zeros(N, N);
            time = 1:length(edaData)/SamplingRate;
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
            % plot marker
            ax = gca;
            self.plotIntervals(intervals,[0, ax.YLim(2)],1,[],'r'); %changed
            title(['Distance map of  EDA data phase space trajectory for subject' subject.name]); %changed   
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
            % plot marker
            ax = gca;
            self.plotIntervals(intervals,[0, ax.YLim(2)],1,[],'r');
            title([' recurrence plot for subject ' subject.name ' with threshold ' num2str(maxDiff)]);
            
            % file name
            fName = [subject.OutputDirectory '/' subject.name '_EDA_recurrence.pdf'];
            print(fName,'-dpdf',fig);
        end
        
        %% Plots behavioral characteristics % Tim - Code nochmal überschauen
        %  subjectName: String 
        %  StimuIntNum: Number of the StimulusInterval
        %  outputDir: Path to output directory as String
        %  frequencies: eeg frequency data for subject as CellArray of double[] 
        %  intervals: intervals of interest as int[]
        function plotBehavioralCharacteristics(self,subjectName,outputDir,frequencies,StimuIntDef,eegDevice)   
            EEGSamplingRate=eegDevice.samplingRate;
            intervals = StimuIntDef.intervals;
            stimuIntDescrp = StimuIntDef.stimuIntDescrp;
            StimuIntLength = length(frequencies{1,1})/EEGSamplingRate; 
            stepWith = 1;
            if StimuIntLength > 1000
                xAxis = 0:100:StimuIntLength;
                stepWith = 100;
            elseif StimuIntLength > 300
                xAxis = 0:25:StimuIntLength;
                stepWith = 25;
            elseif StimuIntLength > 30
                xAxis = 0:5:StimuIntLength;
                stepWith = 5;
            else
                xAxis = 0:StimuIntLength;
            end
            xTime = xAxis./stepWith; 
            absolutValuesPerSecond = zeros(length(frequencies),StimuIntLength/stepWith); 
            [numFrq,lenStimu] = size(absolutValuesPerSecond);
            % make values discrete (calculate mean per second)
            for indexFrq = 1:numFrq
                start = 1; 
                ende = EEGSamplingRate*stepWith; 
                freqValues = frequencies{:,indexFrq}; 
                for indexSecond = 1:lenStimu
                   absolutValuesPerSecond(indexFrq,indexSecond) = mean(freqValues(start:ende)); 
                   start = start +EEGSamplingRate*stepWith;
                   ende = ende +EEGSamplingRate*stepWith; 
                end
            end
            % Normalize percental 
            valuesToPlot = zeros(numFrq,lenStimu);
            % Add TEI values
            valuesToPlot(numFrq,:) = absolutValuesPerSecond(numFrq,:);
            for indexFrq = 1:numFrq 
                for indexSecond = 1:lenStimu
                   maxPerSecond = max(absolutValuesPerSecond(:,indexSecond));
                   maximumPos = absolutValuesPerSecond(:,indexSecond) == maxPerSecond;
                   valuesToPlot(maximumPos,indexSecond) = maxPerSecond/sum(absolutValuesPerSecond(:,indexSecond))*100; % Nomierung ist falsch Gernot Tim
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
            set(gca,'XTick',xTime,'XTickLabel',xAxis);
            xlabel('time [s]');
            ylabel('[%]'); 
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'landscape');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
            
            % file name
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
            numValues = length(hrvValues);
            time = 1:numValues;
            % plot values
            plot(hrvValues,'k');
            grid;
            yMin = min(hrvValues);
            yMax = max(hrvValues);
            % get values for intervals over hole time frame with starting
            % points, to plot marker on each Stimulus 
            [StimuIntStartPoints,StimuIntTyps,intervals,~] = self.calculateStimuIntStartPointsAndIntervals(StimuIntDef);
            
            % get index and length of EDA Orientation, to build HRV
            % Baseline
            for indexStimu = 1:length(StimuIntDef)
                if StimuIntDef{1, indexStimu}.stimuIntType == 0
                    index = indexStimu;
                    StimuIntLength = StimuIntDef{1, indexStimu}.Stimulength;
                end
            end
            % calculate the HRV Baseline
            BaselineSignal = mean(hrvValues(ceil(StimuIntStartPoints(index)):round(StimuIntStartPoints(index))+StimuIntLength));
            self.plotIntervals(intervals,[yMin, yMax],1,[],'r');
            self.plotStimuIntStartPoints(StimuIntStartPoints,StimuIntTyps,[yMin, yMax],1);
            yline(BaselineSignal,'-g');
            axis([1 max(time) yMin yMax]);
            ylabel('RR intervals [ms]');
            xlabel('time [s]');
            m = sprintf('%.2f',mean(hrvValues));
            sd = sprintf('%.2f',std(hrvValues));
            hold on
            
            % create custom legend
            h = zeros(4,1);
            h(1) = plot(NaN,NaN,'-k');
            h(2) = plot(NaN,NaN,'-g');
            h(3) = plot(NaN,NaN,'-r');
            h(4) = plot(NaN,NaN,'--b');
            
            legend(h,'Signal', 'Baseline', 'Stimulus', 'Begin/End of Stimulus Interval','location','southoutside','Orientation','horizontal')
            
            title({['HRV values for subject ' subjName ' (mean=' m 'ms, sd=' sd 'ms)'],''});
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'landscape');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
            
            % file name
            fName = [outputDir '/' subjName '_HRV.pdf'];  
            print(fName,'-dpdf',fig);
            close(fig);
        end   
        
        %% RawEEG figure plot
        %   get rawEEG data and plot it
        %   rawValues: Raw eeg values as double[]
        %   filteredValues: Filteres eeg values as double[]
        %   quality: Two double values. First is percent outside for
        %   rawValues. Second is percent outside for filtered values
        %   subject: Data of Subject
        %   config: Config  
        function plotRawEEGFigures(self,rawValues,filteredValues,quality,subject,electrode,config) 
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
            
            % file name
            fName = [subject.OutputDirectory '/' subject.name '_' char(electrode) '_EEG.pdf'];
            print(fName,'-dpdf',fig);
            close(fig);
        end 
     
        %% Plots EDA figures for given Stimulus Intervals
        %   StimuIntIndex: StimulusInterval indicies of StimulusIntervals to plot as doubel[]
        %   edaValues: eda values of subject as Cell of double[]
        %   StimuIntDefs: Cell<StimuIntDefinition>
        %   subjectName: the name of the subject as String
        %   fPath: file path as String 
        %   stats: eda statistics for subject as String 
        function plotSubStimuIntEDA(self,StimuIntIndex,edaValues,StimuIntDefs,subjectName,fPath,stats)
            numberofPages = ceil(length(StimuIntIndex)/5);
            index = 1;
            allValues=  edaValues(StimuIntIndex);
            allValues = vertcat(allValues{:});
            yMin = min(allValues);
            yMax = max(allValues);
            yL = [yMin yMax];
            
            for indexPage = 1:numberofPages
                fig = figure('Visible','off');
                subplotCounter = 1;
                % choose x axis interval on base of StimulusInterval length
                loopcounter = 1;
                while loopcounter ~= 6
                    i = StimuIntIndex(index);
                    if index +1 <= length(StimuIntIndex)
                        index = index + 1;
                    else
                        loopcounter = 5;
                    end
                    StimuIntType = StimuIntDefs{1,i}(1);
                    StimuIntLength = StimuIntDefs{i}.Stimulength;
                    % get x Axis for long and short Stimulus Intervals
                    if StimuIntLength > 1000
                        xAxis = 0:100:StimuIntLength;
                    elseif StimuIntLength > 300
                        xAxis = 0:25:StimuIntLength;
                    elseif StimuIntLength > 30
                        xAxis = 0:5:StimuIntLength;
                    else
                        xAxis = 0:StimuIntLength;
                    end
                    labels = StimuIntDefs{i}.intervals;
                    xTime = xAxis .* 5; % Warum 5?
                    subplot(6,1,subplotCounter);
                    subplotCounter = subplotCounter + 1;
                    plot(edaValues{i},'k');
                    % plot marker on EDA plot
                    self.plotIntervals(StimuIntDefs{i}.intervals,yL,max(xTime)/max(xAxis),labels,'r');
                    grid;
                    ylabel([StimuIntType.stimuIntDescrp ' [µS]']);
                    l = length(edaValues{i});
                    axis([1,l, yL]);
                    set(gca,'XTick',xTime,'XTickLabel',xAxis);
                    if (subplotCounter==1)
                        title(['Overview of all EDA values from all related StimulusInterval of subject ' subjectName]);
                    end
                    loopcounter = loopcounter + 1;
                end
                xlabel('Time [s]');
                axes('Position',[.08 .10 0.8 1],'Visible','off'); % Tim Position Hardcoded bei mehr Stimus kommt es zu Problemen! 
                text(0,0,stats,'FontName','FixedWidth','FontSize',8);
                set(fig, 'PaperType', 'A4');
                set(fig, 'PaperOrientation', 'portrait');
                set(fig, 'PaperUnits', 'centimeters');
                set(fig, 'PaperPositionMode', 'auto');
                set(fig, 'PaperPosition', [0.2 0.2 20 29 ]);
                if numberofPages > 1
                    fPathNum = [fPath '_' int2str(indexPage)];
                    print(fPathNum,'-dpdf',fig);
                else
                    print(fPath,'-dpdf',fig);
                end
                close(fig);
            end
        end
        
        %% Plots complete EDA figure to given file name
        %   StimuIntDef: Cell<StimuIntDefinition>
        %   fPath: Output file path
        %   edaValues: EDA values as double[]
        %   detrended: boolean 
        function plotEDA(self,StimuIntDef,fName,edaValues,detrended)
            % get scale and interval, starting points and Stimulus Interval
            % typs
            maxscale = max(edaValues);
            minscale = min(edaValues);
            [StimuIntStartPoints,StimuIntTyps,intervals,StimuIntLength] = self.calculateStimuIntStartPointsAndIntervals(StimuIntDef);
            if StimuIntLength > 1000
                xAxis = 0:100:StimuIntLength;
            elseif StimuIntLength > 300
                xAxis = 0:25:StimuIntLength;
            elseif StimuIntLength > 30
                xAxis = 0:5:StimuIntLength;
            else
                xAxis = 0:StimuIntLength;
            end
            xTime = xAxis .* 5;
            fig = figure('Visible','off');
            plot(edaValues,'k');
            grid;
            axis([1 length(edaValues) minscale maxscale]);
            set(gca,'XTick',xTime,'XTickLabel',xAxis);
            xlabel('Time [s]');
            self.plotIntervals(intervals,[minscale, maxscale],max(xTime)/max(xAxis),[],'r');
            self.plotStimuIntStartPoints(StimuIntStartPoints,StimuIntTyps,[minscale, maxscale],max(xTime)/max(xAxis));
            ylabel('Skin Conductance [µS]');
            % check for detrended data
            if (detrended)
                t = 'EDA values (detrended)';
            else
                t = 'EDA values';
            end
            title({t,''});
            
            % create custom legend
            hold on
            h = zeros(3,1);
            h(1) = plot(NaN,NaN,'-k');
            h(2) = plot(NaN,NaN,'-r');
            h(3) = plot(NaN,NaN,'--b');
            
            legend(h,'Signal', 'Stimulus', 'Begin/End of Stimulus Interval','location','southoutside','Orientation','horizontal')
            
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'landscape');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPositionMode', 'auto');
            set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
            
            % file name
            print(fName,'-dpdf',fig);
            close(fig);
        end
        
        %% Plots eeg frequency bands for StimulusInterval and each frequency band
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
            fig = figure('Visible','off');
            maxscale = max([max(theta_s) max(alpha_s) max(beta1_s) max(beta2_s) ]);
            labels = [];
            % get x Axis for long and short Stimulus Intervals and xAxis 
            % labels for interval if necessary 
            if StimuIntLength > 1000
                xAxis = 0:100:StimuIntLength;
            elseif StimuIntLength > 300
                xAxis = 0:25:StimuIntLength;
            elseif StimuIntLength > 30
                xAxis = 0:5:StimuIntLength;
            else
                xAxis = 0:StimuIntLength;
            end
            xtime = xAxis .* resolution;
            edaXTime = xAxis .* 5;
            
            % create each subplot for the each frequency band and plot them
            % in different colors
            subplot(6,1,1);
            plot(theta_s,'Color',[0/255 191/255 255/255]);
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xAxis),labels,'r');
            grid;
            ylabel('Theta [µV]');
            axis([1 length(theta_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
            % set path and titel once for the pdf
            [~,subjName,~] = fileparts(fPath);
            t = title({['Frequency bands, task engagement and EDA for subject: ' strrep(subjName,'_freq_bands_',' ')],''});
            tP = get(t,'Position');
            set(t,'Position',[tP(1) tP(2)+0.3 tP(3)]);
            set(t,'FontSize',12);
            
            subplot(6,1,2);
            plot(alpha_s,'Color',[0/255 128/255 0/255]);
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xAxis),labels,'r');
            grid;
            ylabel('Alpha [µV]');
            axis([1 length(alpha_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
            
            subplot(6,1,3);
            plot(beta1_s,'Color',[255/255 128/255 0/255]);
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xAxis),labels,'r');
            grid;
            ylabel('Beta1 [µV]');
            axis([1 length(beta1_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
            
            subplot(6,1,4);
            plot(beta2_s,'Color',[255/255 69/255 0/255]);
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xAxis),labels,'r');
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
            grid;
            ylabel('Beta2 [µV]');
            axis([1 length(beta2_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
            
            subplot(6,1,5);
            plot(task_s,'k');
            self.plotIntervals(intervals,[0, max(task_s)],max(xtime)/max(xAxis),labels,'r');
            grid;
            ylabel('TEI');
            axis([1 length(task_s) 0 max(task_s)]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
            
            subplot(6,1,6);
            plot(edaSubStimuIntList,'k');
            yL = [min(edaSubStimuIntList) max(edaSubStimuIntList)];
            % check if min/max the same
            if yL(1) == yL(1)
                yL(1) = yL(1)-yL(1)*0.05;
                yL(2) = yL(2)+yL(2)*0.05;
            end
            self.plotIntervals(intervals,yL,max(edaXTime)/max(xAxis),labels,'r');
            grid;
            ylabel('EDA [µS]');
            len = length(edaSubStimuIntList);
            axis([1,len, yL]);
            set(gca,'XTick',edaXTime,'XTickLabel',xAxis);

            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'portrait');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPositionMode', 'auto');
            set(fig, 'PaperPosition', [0.2 0.1 20 29 ]);
            print(['-f',int2str(fig.Number)],'-dpdf',[fPath,'.pdf']);
            close(fig);
        end
               
        %% Plots eeg frequency bands for StimulusInterval and each frequency band
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
        function plotFrequencysWithBaselineMagnitude(self,edaPerStim,hrvPerStim,StimuIntLength,fPath,theta_s,alpha_s,beta1_s,beta2_s,task_s,baselineTheta,baselineAlpha,baselineBeta1,baselineBeta2,baselineTEI,baseline_EDA,baseline_HRV,intervals,t_title)
            fig = figure('Visible','off');
			maxscale = (max([max(alpha_s) max(beta1_s) max(beta2_s) max(theta_s)]));
            numDataPoints = StimuIntLength*4; % Mutiply with 4, because of 4Hz
            labels = [];
            % get x Axis for long and short Stimulus Intervals and xAxis 
            % labels for interval if necessary 
            if StimuIntLength > 1000
                xAxis = 0:100:StimuIntLength;
            elseif StimuIntLength > 300
                xAxis = 0:25:StimuIntLength;
            elseif StimuIntLength > 30
                xAxis = 0:5:StimuIntLength;
            else
                xAxis = 0:StimuIntLength;
            end
            xtime = xAxis*4; % Mutiply with 4, because of 4Hz 
            
			% subplots for each frequency band with own color
			subplot(7,1,1)
            hold on
            plot(theta_s,'Color',[65/255 105/255 225/255]);
            m = mean(baselineTheta);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            % print marker on plot for each Stimulus Interval
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xAxis),labels,'r');
            grid;
            hold off
            massAndTime = self.calculateMassAndTime(theta_s,numDataPoints,mean(baselineTheta));
            
            if(isempty(intervals))
                legend(massAndTime,'theta baseline average','location','northoutside','Orientation','horizontal');
            else
                legend(massAndTime,'theta baseline average','Stimulus','location','northoutside','Orientation','horizontal');
            end
            ylabel('Theta [µV]');
            axis([0 length(theta_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
			
			subplot(7,1,2);
            hold on;
            plot(alpha_s,'Color',[0/255 128/255 0/255]);
            m = mean(baselineAlpha);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xAxis),labels,'r');
            hold off;
            massAndTime = self.calculateMassAndTime(alpha_s,numDataPoints,mean(baselineAlpha));
            if(isempty(intervals))
                legend(massAndTime,'alpha baseline average','location','northoutside','Orientation','horizontal');
            else
                legend(massAndTime,'alpha baseline average','Stimulus','location','northoutside','Orientation','horizontal');
            end
            grid;
            ylabel('Alpha [µV]');
            axis([0 length(alpha_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
                        
            subplot(7,1,3);
            hold on;
            plot(beta1_s,'Color',[255/255 128/255 0/255]);
            m = mean(baselineBeta1);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xAxis),labels,'r');
            massAndTime = self.calculateMassAndTime(beta1_s,numDataPoints,mean(baselineBeta1));
            hold off;
            if(isempty(intervals))
                legend(massAndTime,'beta1 baseline average','location','northoutside','Orientation','horizontal');
            else
                legend(massAndTime,'beta1 baseline average','Stimulus','location','northoutside','Orientation','horizontal');
            end
            grid;
            ylabel('Beta1 [µV]');
            axis([0 length(beta1_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
            
            subplot(7,1,4);
            hold on;
            plot(beta2_s,'Color',[255/255 69/255 0/255]);
            m = mean(baselineBeta2);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            massAndTime = self.calculateMassAndTime(beta2_s,numDataPoints,mean(baselineBeta2));
            self.plotIntervals(intervals,[0, maxscale],max(xtime)/max(xAxis),labels,'r');
            hold off;
            if(isempty(intervals))
                legend(massAndTime,'beta2 baseline average','location','northoutside','Orientation','horizontal');
            else
                legend(massAndTime,'beta2 baseline average','Stimulus','location','northoutside','Orientation','horizontal');
            end
            grid;
            ylabel('Beta2 [µV]');
            axis([0 length(beta2_s) 0 maxscale]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
			
			subplot(7,1,5);
            hold on;
            plot(task_s,'k');
            m = mean(baselineTEI);
            line('XData',[0 xtime(end)],'YData',[m,m],'Color','b')
            % the max scale for task band is different and has to be
            % calculated separately 
            maxscaleTask = max(task_s);
            massAndTime = self.calculateMassAndTime(task_s,numDataPoints,mean(baselineTEI));
            self.plotIntervals(intervals,[0, maxscaleTask],max(xtime)/max(xAxis),labels,'r');
            hold off;
            if(isempty(intervals))
                legend(massAndTime, 'TEI baseline average','location','northoutside','Orientation','horizontal');
            else
                legend(massAndTime, 'TEI baseline average','Stimulus','location','northoutside','Orientation','horizontal');
            end
            
            grid;
            ylabel('TEI');
            axis([0 length(task_s) 0 maxscaleTask]);
            set(gca,'XTick',xtime,'XTickLabel',xAxis);
            
            subplot(7,1,6);
            hold on;
            % calculate xtime for EDA, because its not converted into 4Hz
            xtimeEDA = xAxis * length(edaPerStim)/StimuIntLength;
            plot(edaPerStim,'k');
            maxscaleEDA = max(edaPerStim)*1.01;
            minEDA = min(edaPerStim)*0.998;
            line('XData',[0 length(edaPerStim)],'YData',[baseline_EDA,baseline_EDA],'Color','b')
            self.plotIntervals(intervals,[minEDA, maxscaleEDA],max(xtimeEDA)/max(xAxis),labels,'r');
            hold off;
            if(isempty(intervals))
                legend('EDA signal','EDA Baseline','location','northoutside','Orientation','horizontal');
            else
                legend('EDA signal','EDA Baseline','Stimulus','location','northoutside','Orientation','horizontal');
            end
            
            grid;
            ylabel('EDA');
            axis([0 length(edaPerStim) minEDA maxscaleEDA]);
            set(gca,'XTick',xtimeEDA,'XTickLabel',xAxis);
            
            subplot(7,1,7);
            hold on;
            % calculate xtime for HRV, because its not converted into 4Hz
            xtimeHRV = xAxis * length(hrvPerStim)/StimuIntLength;
            plot(hrvPerStim,'k');
            maxscaleHRV = max(hrvPerStim)*1.01;
            minHRV = min(hrvPerStim)*0.99;
            line('XData',[0 xtime(end)],'YData',[baseline_HRV,baseline_HRV],'Color','b')
            self.plotIntervals(intervals,[minHRV, maxscaleHRV],max(xtimeHRV)/max(xAxis),labels,'r');
            hold off;
            if(isempty(intervals))
                legend('HRV signal','HRV Baseline','location','northoutside','Orientation','horizontal');
            else
                legend('HRV signal','HRV Baseline','Stimulus','location','northoutside','Orientation','horizontal');
            end
            
            grid;
            ylabel('HRV');
            axis([0 length(hrvPerStim) minHRV maxscaleHRV]);
            set(gca,'XTick',xtimeHRV,'XTickLabel',xAxis);
            
            set(fig, 'PaperType', 'A4');
            set(fig, 'PaperOrientation', 'portrait');
            set(fig, 'PaperUnits', 'centimeters');
            set(fig, 'PaperPositionMode', 'auto');
            set(fig, 'PaperPosition', [0.2 0.1 20 29 ]);
            % title for the hole plot
			sgtitle(t_title);
            print(['-f',int2str(fig.Number)],'-dpdf',fPath);
			close(fig);
        end
        
        %% Computation of the momentary frequency of a given signal
        function frequency_estimation(self,tMean, tFreq, name, stimulus, conf, useData, intervals, StimuIntLength, eegData, edaData, hrvData)
            % usedata setup - EEG, EDA, HRV
            data = {eegData,edaData,hrvData};
            DataTyp = ['EEG'; 'EDA'; 'HRV'];
            labels = [];
            
            % get xAxis for Stimlus
            if StimuIntLength > 1000
                xAxis = 0:100:StimuIntLength;
            elseif StimuIntLength > 300
                xAxis = 0:25:StimuIntLength;
            elseif StimuIntLength > 30
                xAxis = 0:5:StimuIntLength;
            else
                xAxis = 0:StimuIntLength;
            end            
            
            for indexPlot = 1:sum(useData)
                if useData(indexPlot) == 1    
                    
                    % predefine needed variables
                    signalData = data{indexPlot};
                    mean1 = 0;
                    mean2 = 0;
                    mean3 = 0;
                    dataLength = length(signalData);
                    
                    % get xtime
                    scaleFactor = dataLength/max(xAxis);
                    xtime = xAxis * scaleFactor;
                    
                    resultFreq = zeros(1,dataLength-2);
                    for indexData = 3:dataLength
                        mean1 = (mean1 +  tMean .*(signalData(indexData) - mean1));

                        % check if "bigger"
                        k1 = not(mean1 < signalData(indexData-1));

                        mean2 = mean2 +  tMean*(signalData(indexData-1) - mean2);

                        % check if "bigger"
                        k2 = not(mean2 < signalData(indexData-2));

                        % check if not equal
                        w = k1 ~= k2;
                        mean3 = mean3 +  tFreq*(w - mean3);

                        % Just count half of the zero-crossings => /2
                        resultFreq(indexData-2) = mean3/2;
                    end

                    % plot
                    fig = figure('Visible','off');
                    set(fig, 'PaperType', 'A4');
                    set(fig, 'PaperOrientation', 'landscape');
                    set(fig, 'PaperUnits', 'centimeters');
                    set(fig, 'PaperPosition', [0.2 0.1 29 20 ]);
                    plot(resultFreq,'k');
                    if resultFreq ~= 0
                        ylim([0 max(resultFreq)*1.5])
                    end
                    yAxis = ylim;
                    self.plotIntervals(intervals,yAxis,scaleFactor,labels,'r');
                    hold off;

                    grid;
                    title(['Momentary frequency for ' stimulus]);
                    ylabel([DataTyp(indexPlot,:) ' data averaged over all electrode positions'])
                    
                    % set xAxis to correct length of Stimlus
                    set(gca,'XTick',xtime,'XTickLabel',xAxis);
                    
                    print(['-f',int2str(fig.Number)],'-dpdf',[conf.OutputDirectory '\' name '\' name '_' stimulus '_' DataTyp(indexPlot,:) '_frequency_estimation.pdf']);
                    close(fig);   
                end
            end
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
        %  Import the Stimulus Interval Definition Cell Array and extract 
        % the individual intervals to convert them into an interval vector 
        % over the whole timeframe of the data
        function [StimuIntStartPoints,StimuIntLabels,intervals,completeVidLength] = calculateStimuIntStartPointsAndIntervals(self,StimuIntDef)
            StimuIntStartPoints = zeros(1,length(StimuIntDef));
            StimuIntLabels= cell(1,length(StimuIntDef));
            intervals = [];
            completeVidLength =0;
            for indexStimu = 1:length(StimuIntDef)
                completeVidLength = completeVidLength + StimuIntDef{indexStimu}.Stimulength;
                StimuIntLabels{indexStimu} = StimuIntDef{1, indexStimu}.stimuIntDescrp;
                % Starting value needs to be != 0, because of calculations
                % later on -> changed from 0 -> 0.2
                if indexStimu == 1
                    StimuIntStartPoints(indexStimu) = 0.2;
                % the second value must be used separately, 
                % because of the exchange of 0 -> 0.2
                elseif indexStimu == 2
                    StimuIntStartPoints(indexStimu) = StimuIntDef{indexStimu-1}.Stimulength;
                % then the values can simply be added up
                else
                    StimuIntStartPoints(indexStimu) = StimuIntDef{indexStimu-1}.Stimulength + StimuIntStartPoints(indexStimu-1);
                end
                currentIntervals = StimuIntDef{indexStimu}.intervals;
                currentIntervals= currentIntervals + StimuIntStartPoints(indexStimu);
                intervals = horzcat(intervals,currentIntervals');
            end
        end
        
        %% Helper method to plot intervals of interest
        function plotIntervals(self,intervals,yPos,scaleFac,labels,color)
            labels = labels';
            for i=1:length(intervals)
                xPosition = intervals(i);
                xPosition = xPosition*double(scaleFac);
                line([double(xPosition) double(xPosition)],yPos,'Color',color);
                % only used if the graph does not contain all distances
                if ~isempty(labels)
                    text([double(xPosition) double(xPosition)],[yPos(2) yPos(2)], num2str(labels(i)), 'VerticalAlignment','bottom','HorizontalAlignment','center','FontSize',8);
                end
            end
        end
        
        %% Helper method to plot the StimulusInterval start points
        function plotStimuIntStartPoints(self,startPoints,labels,yPos,scaleFac)
            for i = 1:length(startPoints)
                xPosition = startPoints(i);
                xPosition = double(xPosition*scaleFac);
                line([xPosition xPosition],yPos,'Color','b','LineStyle','--');
                t = text([xPosition xPosition],[yPos(2) yPos(2)], labels(i), 'VerticalAlignment','top','HorizontalAlignment','right','FontSize',9);
                set(t,'Rotation',90);
            end
        end

    end
end

