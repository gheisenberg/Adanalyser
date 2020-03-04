function varargout = ElectrodesDialog(varargin)
% ELECTRODESDIALOG MATLAB code for ElectrodesDialog.fig
%      ELECTRODESDIALOG, by itself, creates a new ELECTRODESDIALOG or raises the existing
%      singleton*.
%
%      H = ELECTRODESDIALOG returns the handle to a new ELECTRODESDIALOG or the handle to
%      the existing singleton*.
%
%      ELECTRODESDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELECTRODESDIALOG.M with the given input arguments.
%
%      ELECTRODESDIALOG('Property','Value',...) creates a new ELECTRODESDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ElectrodesDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ElectrodesDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ElectrodesDialog

% Last Modified by GUIDE v2.5 03-Mar-2020 10:47:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ElectrodesDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @ElectrodesDialog_OutputFcn, ...
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


% --- Executes just before ElectrodesDialog is made visible.
function ElectrodesDialog_OpeningFcn(hObject, eventdata, handles, varargin)
%%Upadte Togglebutton on GUI
global eegdevice
electrodePositions = eegdevice.electrodePositions;

%Create cell array to use indize
handlesCell = struct2cell(handles);
tags = cell(length(handlesCell),1);
numElect = length(electrodePositions);
UsedElectrode = cell(numElect,1);
for i = 1:numElect
UsedElectrode{i} = electrodePositions{i};
end

%list of all tags -> needed to convert the cell Aray background into a struct
for  i = 1:length(handlesCell)
    data = handlesCell{i};
    tags{i} = data.Tag;
    if strcmp(class(data),'matlab.graphics.axis.Axes')
        tags{i} = 'background';
    end
end

%Type searched for -> buttons
typeNeeded = 'matlab.ui.control.UIControl';

%Loop for tooglebuttons
for  i = 2:length(handlesCell) 
data = handlesCell{i};
type = class(data);
%Compare types to search for togglebuttons
    if strcmp(type,typeNeeded)
      %set BackgroundColor to gray
      data.BackgroundColor = [0.9,0.9,0.9];
      for j = 1:numElect
        if strcmp(data.String,UsedElectrode{j})
            %Update togglebutton
            data.Enable = 'on';
            handlesCell{i} = data;
            %tooltip saved the original color of the button
            data.BackgroundColor = data.Tooltip;
            %set togglebutton in "pressed" if electorde state already == 1
            if eegdevice.electrodeState{j} == 1
                data.Value = true;
            end
        else
            %nothing
        end
      end
    else
         %nothing
    end
end
%Concert the cell aray to struct -> newhandle and update it
newhandles = cell2struct(handlesCell,tags,1);
handles = newhandles;
%%
% Choose default command line output for ElectrodesDialog
handles.output = hObject;
% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0.0 0.07 0.5 0.85]); 
% import the background image and show it on the axes
axes(handles.background)
imshow('EEG_Background.jpg')
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');
% Update handles structure
guidata(hObject, handles);
%% Create table
%Create Table
tableData = cell(numElect,2);
for j = 1:numElect
    tableData{j,1} =  electrodePositions{j};
    tableData{j,2} =  eegdevice.electrodeState{j};
end
%Set table data
set(handles.ElectrodeTable, 'Data',tableData);
set(handles.ElectrodeTable, 'ColumnName',{'Electrodes','Status'}) 


% --- Outputs from this function are returned to the command line.
function varargout = ElectrodesDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global eegdevice

data = get(handles.ElectrodeTable, 'Data');
dateVector = size(data);
datalength = dateVector(1);

for i = 1:datalength
    eegdevice.electrodeState{i} = data{i,2};
end
close;


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close; 


% --- Executes on button press in fp1.
function fp1_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data);
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FP1')
    data{i,2} = handles.fp1.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in fp2.
function fp2_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FP2')
    data{i,2} = handles.fp2.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in fpz.
function fpz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FPZ')
    data{i,2} = handles.fpz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in fz.
function fz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FZ')
    data{i,2} = handles.fz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in f3.
function f3_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F3')
    data{i,2} = handles.f3.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in f4.
function f4_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F4')
    data{i,2} = handles.f4.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in f7.
function f7_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F7')
    data{i,2} = handles.f7.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in f8.
function f8_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F8')
    data{i,2} = handles.f8.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in t7.
function t7_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'T7')
    data{i,2} = handles.t7.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in t8.
function t8_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'T8')
    data{i,2} = handles.t8.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in cz.
function cz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'CZ')
    data{i,2} = handles.cz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in c4.
function c4_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'C4')
    data{i,2} = handles.c4.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in c3.
function c3_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'C3')
    data{i,2} = handles.c3.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in p3.
function p3_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P3')
    data{i,2} = handles.p3.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in p4.
function p4_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P4')
    data{i,2} = handles.p4.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in pz.
function pz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'PZ')
    data{i,2} = handles.pz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in p7.
function p7_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P7')
    data{i,2} = handles.p7.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in p6.
function p6_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P6')
    data{i,2} = handles.p6.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);;

% --- Executes on button press in o1.
function o1_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'O1')
    data{i,2} = handles.o1.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in o2.
function o2_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'O2')
    data{i,2} = handles.o2.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes on button press in oz.
function oz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'OZ')
    data{i,2} = handles.oz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function ElectrodeTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ElectrodeTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in af3.
function af3_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'AF3')
    data{i,2} = handles.af3.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in af4.
function af4_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'AF4')
    data{i,2} = handles.af4.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in poz.
function poz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'POZ')
    data{i,2} = handles.poz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in t10.
function t10_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'T10')
    data{i,2} = handles.t10.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in t9.
function t9_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'T9')
    data{i,2} = handles.t9.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in nz.
function nz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'NZ')
    data{i,2} = handles.nz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in afz.
function afz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'AFZ')
    data{i,2} = handles.afz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in af7.
function af7_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'AF7')
    data{i,2} = handles.af7.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in af8.
function af8_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'AF8')
    data{i,2} = handles.af8.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in f5.
function f5_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F5')
    data{i,2} = handles.f5.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in f6.
function f6_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F6')
    data{i,2} = handles.f6.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in f1.
function f1_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F1')
    data{i,2} = handles.f1.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in f2.
function f2_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F2')
    data{i,2} = handles.f2.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in f9.
function f9_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F9')
    data{i,2} = handles.f9.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in f10.
function f10_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'F10')
    data{i,2} = handles.f10.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in ft9.
function ft9_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FT9')
    data{i,2} = handles.ft9.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in fcz.
function fcz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FCZ')
    data{i,2} = handles.fcz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in fc4.
function fc4_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FC4')
    data{i,2} = handles.fc4.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in ft8.
function ft8_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FT8')
    data{i,2} = handles.ft8.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in fc6.
function fc6_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FC6')
    data{i,2} = handles.fc6.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in fc2.
function fc2_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FC2')
    data{i,2} = handles.fc2.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in ft10.
function ft10_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FT19')
    data{i,2} = handles.ft10.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in a1.
function a1_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'A1')
    data{i,2} = handles.a1.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in c5.
function c5_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'C5')
    data{i,2} = handles.c5.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in c1.
function c1_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'C1')
    data{i,2} = handles.c1.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in a2.
function a2_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'A2')
    data{i,2} = handles.a2.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in c6.
function c6_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'C6')
    data{i,2} = handles.c6.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in c2.
function c2_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'C2')
    data{i,2} = handles.c2.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in cp3.
function cp3_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'CP3')
    data{i,2} = handles.cp3.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in fp7.
function fp7_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'FP7')
    data{i,2} = handles.fp7.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in cp5.
function cp5_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'CP5')
    data{i,2} = handles.cp5.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in cp1.
function cp1_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'CP1')
    data{i,2} = handles.cp1.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in tp9.
function tp9_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'TP9')
    data{i,2} = handles.tp9.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in cpz.
function cpz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'CPZ')
    data{i,2} = handles.cpz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in cp4.
function cp4_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'CP4')
    data{i,2} = handles.cp4.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in tp8.
function tp8_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'TP8')
    data{i,2} = handles.tp8.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in cp6.
function cp6_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'CP6')
    data{i,2} = handles.cp6.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in cp2.
function cp2_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'CP2')
    data{i,2} = handles.cp2.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in tp10.
function tp10_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'TP10')
    data{i,2} = handles.tp10.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in p5.
function p5_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P5')
    data{i,2} = handles.p5.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in p1.
function p1_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P1')
    data{i,2} = handles.p1.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in p9.
function p9_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P9')
    data{i,2} = handles.p9.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in p8.
function p8_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P8')
    data{i,2} = handles.p8.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in p2.
function p2_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P2')
    data{i,2} = handles.p2.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in p10.
function p10_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'P10')
    data{i,2} = handles.p10.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in po3.
function po3_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'PO3')
    data{i,2} = handles.po3.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in po4.
function po4_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'PO4')
    data{i,2} = handles.po4.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in po7.
function po7_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'PO7')
    data{i,2} = handles.po7.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in po8.
function po8_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'PO8')
    data{i,2} = handles.po8.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in iz.
function iz_Callback(hObject, eventdata, handles)
data = get(handles.ElectrodeTable,'data');
dataVector = size(data); 
dataL = dataVector(1);
for i = 1:dataL
    if strcmp(data{i,1},'IZ')
    data{i,2} = handles.iz.Value;
    end
end
set(handles.ElectrodeTable, 'Data', data);


% --- Executes on button press in fc3.
function fc3_Callback(hObject, eventdata, handles)
% hObject    handle to fc3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fc3


% --- Executes on button press in ft7.
function ft7_Callback(hObject, eventdata, handles)
% hObject    handle to ft7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ft7


% --- Executes on button press in fc5.
function fc5_Callback(hObject, eventdata, handles)
% hObject    handle to fc5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fc5


% --- Executes on button press in fc1.
function fc1_Callback(hObject, eventdata, handles)
% hObject    handle to fc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fc1
