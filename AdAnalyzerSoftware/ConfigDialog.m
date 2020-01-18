function varargout = ConfigDialog(varargin)
% CONFIGDIALOG MATLAB code for ConfigDialog.fig
%      CONFIGDIALOG, by itself, creates a new CONFIGDIALOG or raises the existing
%      singleton*.
%
%      H = CONFIGDIALOG returns the handle to a new CONFIGDIALOG or the handle to
%      the existing singleton*.
%
%      CONFIGDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGDIALOG.M with the given input arguments.
%
%      CONFIGDIALOG('Property','Value',...) creates a new CONFIGDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConfigDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConfigDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConfigDialog

% Last Modified by GUIDE v2.5 18-Jan-2020 15:18:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConfigDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @ConfigDialog_OutputFcn, ...
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


% --- Executes just before ConfigDialog is made visible.
function ConfigDialog_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
updateUI(handles); 


% --- Outputs from this function are returned to the command line.
function varargout = ConfigDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
global conf
% Output flags
conf.EEG_DEVICE_USED = get(handles.rawEEG,'Value'); 
conf.FrequencyFig = get(handles.frequency,'Value');
conf.EDA_DEVICE_USED = get(handles.rawEDA,'Value');
conf.DetrendedEDAFig = get(handles.detrendedEDA,'Value');
conf.RecurrenceFig = get(handles.recurrenceFig,'Value');
conf.HRV_DEVICE_USED = get(handles.rawHRV,'Value');
conf.SubStimuIntEDAFig = get(handles.subStimuIntEDA,'Value');
conf.QualityFig = get(handles.qualityFigures,'Value');
conf.BehaveFig = get(handles.behavioralCharacteristics,'Value');
conf.Statistics = get(handles.statistics,'Value');
% Quality Settings
valid = 1; 
str = get(handles.lowerEEGThreshold ,'String');
str = strrep(str, ',', '.');
str = strrep(str, ' ', '');
if isempty(str2num(str))
    set(handles.lowerEEGThreshold,'string','-100');
    warndlg('Input must be numerical','Invalid lower threshold');
    valid =0;
else
    conf.LowerThreshold = str2num(str);
end
str = get(handles.upperEEGThreshold,'String');
str = strrep(str, ',', '.');
str = strrep(str, ' ', '');
if isempty(str2num(str))
    set(handles.upperEEGThreshold,'string','-100');
    warndlg('Input must be numerical','Invalid upper threshold');
    valid =0;
else
    conf.UpperThreshold = str2num(str);
end
str = get(handles.recurrenceTreshold,'String');
str = strrep(str, ',', '.');
str = strrep(str, ' ', '');
if isempty(str2num(str))
    set(handles.recurrenceTreshold,'string','0');
    warndlg('Input must be numerical','Invalid recurrence treshold');
    valid =0;
else
    conf.RecurrenceThreshold = str2num(str);
end
str = get(handles.qualityIndex,'String');
str = strrep(str, ',', '.');
str = strrep(str, ' ', '');
num = str2num(str);
if isempty(num)
    set(handles.qualityIndex,'string','10');
    warndlg('Input must be numerical','Invalid quality index');
    valid =0;
elseif num > 100 || num < 1
    warndlg('Input must be between 1 and 100','Invalid quality index');
    valid =0;
else
    conf.QualityIndex = num;
end
if (valid==1)
    close; 
end

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
close; 

% --- Executes during object creation, after setting all properties.
function lowerEEGThreshold_CreateFcn(hObject, eventdata, handles)
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

% --- Executes on button press in allOutputs.
function allOutputs_Callback(hObject, eventdata, handles)
set(handles.rawEEG,'Value',1);
set(handles.rawEDA,'Value',1);
set(handles.qualityFigures,'Value',1);
set(handles.detrendedEDA,'Value',1); 
set(handles.frequency,'Value',1);
set(handles.statistics,'Value',1);
set(handles.recurrenceFig,'Value',1);
set(handles.behavioralCharacteristics,'Value',1);
set(handles.rawHRV,'Value',1);
set(handles.subStimuIntEDA,'Value',1);

% --- Executes on button press in noOutputs.
function noOutputs_Callback(hObject, eventdata, handles)
set(handles.rawEEG,'Value',0);
set(handles.rawEDA,'Value',0);
set(handles.qualityFigures,'Value',0);
set(handles.detrendedEDA,'Value',0); 
set(handles.frequency,'Value',0);
set(handles.statistics,'Value',0);
set(handles.recurrenceFig,'Value',0);
set(handles.behavioralCharacteristics,'Value',0);
set(handles.rawHRV,'Value',0);
set(handles.subStimuIntEDA,'Value',0);

%% Helper method to update ui on base of _Config_ values
function updateUI(handles)
global conf;
set(handles.rawEEG,'Value',conf.EEG_DEVICE_USED);
set(handles.rawEDA,'Value',conf.EDA_DEVICE_USED);
set(handles.qualityFigures,'Value',conf.QualityFig);
set(handles.detrendedEDA,'Value',conf.DetrendedEDAFig); 
set(handles.frequency,'Value',conf.FrequencyFig);
set(handles.statistics,'Value',conf.Statistics);
set(handles.recurrenceFig,'Value',conf.RecurrenceFig);
set(handles.behavioralCharacteristics,'Value',conf.BehaveFig);
set(handles.rawHRV,'Value',conf.HRV_DEVICE_USED);
set(handles.subStimuIntEDA,'Value',conf.SubStimuIntEDAFig);
set(handles.upperEEGThreshold,'String',conf.UpperThreshold);
set(handles.lowerEEGThreshold,'String',conf.LowerThreshold);
set(handles.qualityIndex,'String',conf.QualityIndex);
set(handles.recurrenceTreshold,'String',conf.RecurrenceThreshold); 

function lowerEEGThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to lowerEEGThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowerEEGThreshold as text
%        str2double(get(hObject,'String')) returns contents of lowerEEGThreshold as a double


function upperEEGThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to upperEEGThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upperEEGThreshold as text
%        str2double(get(hObject,'String')) returns contents of upperEEGThreshold as a double


function qualityIndex_Callback(hObject, eventdata, handles)
% hObject    handle to qualityIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qualityIndex as text
%        str2double(get(hObject,'String')) returns contents of qualityIndex as a double


% --- Executes on button press in rawEEG.
function rawEEG_Callback(hObject, eventdata, handles)
% hObject    handle to rawEEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rawEEG


% --- Executes on button press in rawEDA.
function rawEDA_Callback(hObject, eventdata, handles)
% hObject    handle to rawEDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rawEDA


% --- Executes on button press in rawHRV.
function rawHRV_Callback(hObject, eventdata, handles)
% hObject    handle to rawHRV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rawHRV


% --- Executes on button press in detrendedEDA.
function detrendedEDA_Callback(hObject, eventdata, handles)
% hObject    handle to detrendedEDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of detrendedEDA


% --- Executes on button press in frequency.
function frequency_Callback(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frequency


% --- Executes on button press in subStimuIntEDA.
function subStimuIntEDA_Callback(hObject, eventdata, handles)
% hObject    handle to subStimuIntEDA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of subStimuIntEDA


% --- Executes on button press in qualityFigures.
function qualityFigures_Callback(hObject, eventdata, handles)
% hObject    handle to qualityFigures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of qualityFigures


% --- Executes on button press in behavioralCharacteristics.
function behavioralCharacteristics_Callback(hObject, eventdata, handles)
% hObject    handle to behavioralCharacteristics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of behavioralCharacteristics


% --- Executes on button press in statistics.
function statistics_Callback(hObject, eventdata, handles)
% hObject    handle to statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of statistics


% --- Executes on button press in recurrenceFig.
function recurrenceFig_Callback(hObject, eventdata, handles)
% hObject    handle to recurrenceFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of recurrenceFig



function recurrenceTreshold_Callback(hObject, eventdata, handles)
% hObject    handle to recurrenceTreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of recurrenceTreshold as text
%        str2double(get(hObject,'String')) returns contents of recurrenceTreshold as a double


% --- Executes during object creation, after setting all properties.
function recurrenceTreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recurrenceTreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
