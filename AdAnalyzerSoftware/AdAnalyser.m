% adanalyser class
% gui controller
function varargout = AdAnalyser(varargin)
% ADANALYSER MATLAB code for AdAnalyser.fig
%      ADANALYSER, by itself, creates a new ADANALYSER or raises the existing
%      singleton*.
%
%      H = ADANALYSER returns the handle to a new ADANALYSER or the handle to
%      the existing singleton*.
%
%      ADANALYSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADANALYSER.M with the given input arguments.
%
%      ADANALYSER('Property','Value',...) creates a new ADANALYSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AdAnalyser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AdAnalyser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AdAnalyser

% Last Modified by GUIDE v2.5 14-Sep-2015 15:39:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AdAnalyser_OpeningFcn, ...
    'gui_OutputFcn',  @AdAnalyser_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%% Executes just before AdAnalyser is made visible.
%   global variables initialisation happens here 
function AdAnalyser_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
global conf
global configManager
conf = Config;
configManager = ConfigManager; 

%global edadevice
%global DeviceFactory
%edaDevice = Device;
%global edaDevice; 
%global hrvDevice;

% --- Outputs from this function are returned to the command line.
function varargout = AdAnalyser_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%% Executes when save config button pressed.
%   Uses _ConfigManager_ to save config 
function saveSettings_Callback(hObject, eventdata, handles)
global conf;
global configManager
configManager.save(conf);

%% Executes on button press in loadconf.
%   Loads _Config_ from file using global _ConfigManager_ instance
%   TODO error handling
function loadSettings_Callback(hObject, eventdata, handles)
global conf;
global configManager;
global eegdevice edadevice hrvdevice;
[conf,eegdevice,edadevice,hrvdevice] = configManager.load();
updateUI(handles);

%% Helper method to update ui on base of _Config_ values
function updateUI(handles)
global conf;
set(handles.outputDirectory,'String',conf.OutputDirectory);
set(handles.StimuIntDef,'String',conf.StimuIntDef);
set(handles.edaFiles,'String',conf.EDAFiles);
set(handles.eegFiles,'String',conf.EEGFiles);
set(handles.hrvFiles,'String',conf.HRVFiles);

%% Brings up choose file dialog and saves choosen EDA files in _Config_
function browseEDA_Callback(hObject, eventdata, handles)
global conf;
[filenames, pathname] = uigetfile('.\data\*.txt;*.csv', 'Select EDA files','MultiSelect', 'on');
empty = isempty(pathname) || pathname(1:1)==0;
if empty==0
    if ~iscell(filenames) && ischar(filenames)
        filenames = {filenames}; % force it to be a cell array of strings
    end
    edaFiles = cell(size(filenames))
    for file = 1:numel(filenames)
        fullpath = fullfile(pathname,filenames{file});
        edaFiles = [edaFiles, fullpath];
    end
    edaFiles(cellfun('isempty',edaFiles)) = [];
    conf.EDAFiles = edaFiles;
    set(handles.edaFiles,'Value',1); %needed to avoid selection error
    set(handles.edaFiles,'String',conf.EDAFiles);
end

%% Brings up choose file dialog and saves choosen EEG files in _Config_
function browseEEG_Callback(hObject, eventdata, handles)
global conf;
[filenames, pathname] = uigetfile('.\data\*.txt;*.csv', 'Select EEG files','MultiSelect', 'on');
empty = isempty(pathname) || pathname(1:1)==0;
if empty==0
    if ~iscell(filenames) && ischar(filenames)
        filenames = {filenames}; % force it to be a cell array of strings
    end
    eegFiles = cell(size(filenames));
    for file = 1:numel(filenames)
        fullpath = fullfile(pathname,filenames{file});
        eegFiles = [eegFiles, fullpath];
    end
    eegFiles(cellfun('isempty',eegFiles)) = [];
    conf.EEGFiles = eegFiles;
    set(handles.eegFiles,'Value',1); %needed to avoid selection error
    set(handles.eegFiles,'String',conf.EEGFiles);
end

% --- Executes on button press in browseHRV.
function browseHRV_Callback(hObject, eventdata, handles)
global conf;
[filenames, pathname] = uigetfile('.\data\*.txt;*.csv', 'Select HRV files','MultiSelect', 'on');
empty = isempty(pathname) || pathname(1:1)==0;
if empty==0
    if ~iscell(filenames) && ischar(filenames)
        filenames = {filenames}; % force it to be a cell array of strings
    end
    hrvFiles = cell(size(filenames));
    for file = 1:numel(filenames)
        fullpath = fullfile(pathname,filenames{file});
        hrvFiles = [hrvFiles, fullpath];
    end
    hrvFiles(cellfun('isempty',hrvFiles)) = [];
    conf.HRVFiles = hrvFiles;
    set(handles.hrvFiles,'Value',1); %needed to avoid selection error
    set(handles.hrvFiles,'String',conf.HRVFiles);
end

%% Brings up choose file dialog and saves choosen StimulusInterval definition file in _Config_
function browseStimuIntDefinitions_Callback(hObject, eventdata, handles)
global conf;
[filename, pathname]=uigetfile('.\config\AdIndex\*.txt;*.csv','Select a File with SimulationsInterval');
if filename~=0
    conf.StimuIntDef = fullfile(pathname, filename);
    set(handles.StimuIntDef,'String',conf.StimuIntDef);
end

%% Brings up choose directory dialog and saves value in _Config_
function browseOutput_Callback(hObject, eventdata, handles)
global conf;
% this results in 'C:\Program Files\MATLAB\R2019b'
%outputDirectory=uigetdir(ctfroot,'Choose an Output Directory');
% so it is better to set it to ".\"
outputDirectory=uigetdir(".\",'Choose an Output Directory');
if outputDirectory~=0
    conf.OutputDirectory=outputDirectory;
    set(handles.outputDirectory,'String',conf.OutputDirectory);
end

%% Reads data from files using _DataFactory_ when prepare button was pressed
function prepare_Callback(hObject, eventdata, handles)
global conf; 
global data;
global eegdevice edadevice hrvdevice;
fprintf('\nPrepare subjects\n\n');
action = PrepareAction(); 
data = action.prepare(conf,eegdevice,edadevice,hrvdevice); 
if (data.isValid)
    fprintf('Done\n');
    set(handles.filter,'enable','on');
end

%% Starts _FilterAction_ when filter button was pressed
function filter_Callback(hObject, eventdata, handles)
global conf
global data
global eegdevice edadevice hrvdevice;
fprintf('\nFilter subjects');
filter = FilterAction();
data = filter.filter(data,conf,eegdevice,edadevice,hrvdevice);
set(handles.analyse,'enable','on');
fprintf('\n\nDone\n');


%% Starts _AnalyseAction_ when analyse button was pressed
function analyse_Callback(hObject, eventdata, handles)
global conf;
global data;
global eegdevice edadevice hrvdevice;
fprintf('\nAnalyse all data sets');
a = AnalyseAction();
a.analyse(data,conf,eegdevice,edadevice,hrvdevice);
fprintf('Done\n');

%% Output directory textfield
function outputDir_Callback(hObject, eventdata, handles)
global conf
input = get(hObject,'String');
conf.OutputDirectory = input;

%% StimulusInterval definition textfield
function StimuIntDef_Callback(hObject, eventdata, handles)
global conf
input = get(hObject,'String');
conf.StimuIntDef = input;



%%% Create functions and unused callbacks generated by matlab gui editor 

% --- Executes during object creation, after setting all properties.
function outputDir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edaFiles_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edaFiles_Callback(hObject, eventdata, handles)

function eegFiles_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function eegFiles_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function lowerEEGThreshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function StimuIntDef_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.

function upperEEGThreshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function qualityIndex_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function hrvFiles_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in settings.
function settings_Callback(hObject, eventdata, handles)
ConfigDialog; 

% --- Executes on button press in electrodesSettings.
function electrodesSettings_Callback(hObject, eventdata, handles)
ElectrodesDialog; 
