% Creates videos of specific stimuli at specific times
% the user can select them in the GUI
%
% Author: Gernot Heisenberg, Tim Kreitzberg
%

function BrainMapAction(StimulusChosen,interval,timeframe,videoRes)
    
    % get global var
    global data
    global conf
    global eegdevice
    
    allSubjects = data.subjects;
    config = conf;
    
    message = ['Rendering videos for ', num2str(length(allSubjects)), ' subject(s)'];
    h = waitbar(0,message);
    
    %create subfolder
    subfolder_name = '2D_BrainMaps';

    if ~exist([config.OutputDirectory '\' subfolder_name], 'dir')
    parentfolder = config.OutputDirectory;
    mkdir(fullfile(parentfolder, subfolder_name));
    end
    
    for i = 1:length(allSubjects)
        
        subject = allSubjects{i};
        
        if ~exist([config.OutputDirectory '\' subfolder_name subject.name], 'dir')
        parentfolder = [config.OutputDirectory '\' subfolder_name];
        mkdir(fullfile(parentfolder, subject.name));
        end
        
        % Preparing EEG Data for print
        % Import of Standard 10-20 System channel locs for electrodes
        load Standard-10-20-Cap81.mat;

        % Data preparation
        Usedelectrodes = subject.Electrodes;
        numValues = subject.eegValuesForElectrodes; 
        numElectrodes = length(numValues);
        for j = 1:numElectrodes              
            eegValues(:,j) =  subject.eegValuesForElectrodes{1, j}.eegValues;     
        end
        PlotDataOverTime = eegValues';

        % needed variables for chanloc preparation
        chanloc = Chanloc; % get Chanloc included in Standard-10-20-Cap81.mat
        electrodes = Usedelectrodes'; % transfrom vector
        numUsedElectrodes = length(electrodes);
        lengthStandardChanloc = length(Chanloc);
        deleteRow = zeros(1,lengthStandardChanloc);
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
        EEG.srate = eegdevice.samplingRate; % sampling rate (in Hz)
        EEG.xmin = 0;                       % epoch start time (in seconds)
        EEG.xmax = (EEG.pnts-1)/EEG.srate;  % epoch end time (in seconds)

        % Variables needed for loop
        for j = 1:length(data.stimuIntDefs)
            if strcmp(StimulusChosen, data.stimuIntDefs{1, j}.stimuIntDescrp)
                StimuInt = data.stimuIntDefs{1, j};
            end
        end
        
        timestamps = [];

        % video obj
        vName = [config.OutputDirectory '\' subfolder_name '/' subject.name '/' subject.name '_' StimuInt.stimuIntDescrp '_2D Topo_Video'];
        vidObj = VideoWriter(vName);
        vidObj.Quality = 100;       
        vidObj.FrameRate = config.UserFrameRate; % get framerate from video

        % prepare print range
        range = timeframe(1):interval:timeframe(2); % devided by 1000 to convert ms into s
        range = double(range);

        % prepare video for print
        fileDirectory = [config.videoString '\' StimuInt.stimuIntDescrp '.mp4']; % get directory
        %fileDirectory = regexprep(fileDirectory, ' ', '_');
        vid = VideoReader(fileDirectory); % import video
        numOfFrames = round(vid.FrameRate*vid.Duration); % calculate number of frames
        vidFrame = read(vid,[1 numOfFrames]);
        % resize video according to UserFrameRate
        vidFrameReSize = vidFrame(:,:,:,round(1:vid.FrameRate/config.UserFrameRate:end));

        % prepare data for print
        SIGTMP = reshape(EEG.data, EEG.nbchan, EEG.pnts, EEG.trials);
        pos = round((range/1000-EEG.xmin)/(EEG.xmax-EEG.xmin) * (EEG.pnts-1))+1; % Gernot / Tim -> 1000 abändern, auf mögliche 364 - Testen
            if pos(end) == EEG.pnts+1
                pos(end) = pos(end)-1; % Cut 1 so index of pnts and pos is ==
            end
        nanpos = find(isnan(pos));
        pos(nanpos) = 1;

        % create variable for .csv export with all timestamps
        timestamps = cat(1,timestamps,range(1:end-1)'/1000);

        % prepare task variable
        numPos = length(pos)-1;
        numValues = subject.eegValuesForElectrodes; 
        numElec = length(numValues);
        task = zeros(numElec,numPos);

        % get TEI
        for m = 1:numPos
            for j = 1:numElec
            % eegfiltfft is a eeglab function for (high|low|band) - 
            % pass filter data using inverse fft - for more
            % information please look at eegfiltfft.m

            % Theta(5-7 Hz)
            theta(j) = mean(sqrt((eegfiltfft(SIGTMP(j,pos(m):pos(m+1),:),EEG.srate,5,7)).^2)); %Warum wird Theta 0 bei Werten > 1000ms?
            % Alpha(8-13 Hz)
            alpha(j) = mean(sqrt((eegfiltfft(SIGTMP(j,pos(m):pos(m+1),:),EEG.srate,8,13)).^2));
            % Beta1(14-24 Hz)
            beta1(j) = mean(sqrt((eegfiltfft(SIGTMP(j,pos(m):pos(m+1),:),EEG.srate,14,24)).^2));
            % TEI Index
                if alpha(j) > 0 && theta(j) > 0 % Theta = 0 bei 900ms, geht in else - else war falsch programmiert
                task(j,m) = beta1(j)/(alpha(j)+theta(j));
                else
                task(j,m) = 0; % zeros(1,length(range)-1); alter Befehl, welcher für die erzeugung von einem ganzen Vector gedacht war
                end
            end
        end



        % loop preperation - open VideoObject
        numofprint = length(range)-1;
        open(vidObj);

        for k = 1:numofprint
            % print preparation
            mainfig = figure('Visible','on');
            set(mainfig,'PaperUnits','inches','PaperPosition',[0 0 12 7.5])
            hold on

            % Print of 2D Topo
            subplot(2,2,3);
            % double () in case we want to add a multiplier
            title(['AVG TEI between ' num2str((range(k))) '-' num2str((range(k+1))) 'ms']);
            % topoplot is a function of the eeglab libary
            topoplot(task(:,k),EEG.chanlocs,'electrodes','ptslabels');
            cb = colorbar;
            cb.Limits = [0,1];

            % print of histogram
            barsimg = plotElectrodeBars(electrodes,pos(k),pos(k+1),SIGTMP,EEG.srate);    
            barschart = subplot(2,2,4);
            barschart.Position = barschart.Position + [-0.075 -0.075 0.15 0.15];
            imshow(barsimg);

            % Subplot title
            sgtitle([StimuInt.stimuIntDescrp ' for subject ' subject.name]);

            % print out first frame
            videochart = subplot(2,2,[1 2]);
            imshow(vidFrameReSize(:,:,:,(vidObj.FrameRate*k)));
            fName = [config.OutputDirectory '\' subfolder_name '/' subject.name '/' subject.name '_' StimuInt.stimuIntDescrp '_' num2str((range(k+1))) 'ms_2D Topo.png'];
            print(fName,'-dpng','-r300',mainfig);

            % set render to opengl
            set(mainfig,'units','pixels','position',[0 0 videoRes(1) videoRes(2)]) 
            set(gcf,'renderer','opengl') 
            drawnow nocallbacks

            % add to test VM - delete comment
            % set(videoObj, 'LoggingMode', 'memory');

            %create video in plot
            for t = 1:vidObj.FrameRate
                % insert video frames
                videochart = subplot(2,2,[1 2]);
                imshow(vidFrameReSize(:,:,:,t+(vidObj.FrameRate*k)));

                % get frame from figure
                currentFrame = getframe(mainfig);

                % create video
                writeVideo(vidObj, currentFrame);
            end
            % close figure
            close
        end
        waitbar(i/length(data.subjects));
    end
    close(h);
end

%% Prints of electrode frequency
        % electrodes: List of used electrodes
        % startpos/endpos: Range of the printed data
        % data: data
        % srate: Frequency of the device used
        function barsimg = plotElectrodeBars(electrodes,startpos,endpos,data,srate)
            
            % prepare plot
            numelec = length(electrodes);
            barsfig = figure('visible','off','DefaultAxesFontSize',12);
            set(barsfig,'color','w');
            set(barsfig,'Position', [1, 1, 1200, 1200]);
            data = data(:,startpos:endpos);
            
            % get frequency bands
            for i = 1:numelec
                % Delta (1-4 Hz)
                delta(i) = mean(sqrt((eegfiltfft(data(i,:),srate,1,4)).^2));
                % Theta(5-7 Hz)
                theta(i) = mean(sqrt((eegfiltfft(data(i,:),srate,5,7)).^2));
                % Alpha(8-13 Hz)
                alpha(i) = mean(sqrt((eegfiltfft(data(i,:),srate,8,13)).^2));
                % Beta1(14-24 Hz)
                beta1(i) = mean(sqrt((eegfiltfft(data(i,:),srate,14,24)).^2));
                % Beta2(25-40 Hz)
                beta2(i) = mean(sqrt((eegfiltfft(data(i,:),srate,25,40)).^2));
            end
            allfreq = [delta theta alpha beta1 beta2];
            ymax = max(max(allfreq)); % y max for graph
            
            % Print
            for i = 1:numelec
                hold on
                % create subplot for each electrode
                subplot(3,3,i);
                names = categorical({'delta','theta','alpha','beta1','beta2'});
                names = reordercats(names,{'delta','theta','alpha','beta1','beta2'});
                bars = [delta(i), theta(i), alpha(i), beta1(i), beta2(i)];
                h = bar(names,bars,'FaceColor','flat');
                ylim([0 ymax]);
                title(electrodes(i),'FontSize', 24)
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