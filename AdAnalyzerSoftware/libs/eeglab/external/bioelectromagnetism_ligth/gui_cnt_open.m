function [p] = gui_cnt_open(p,command,parent)

% gui_cnt_open - Load a CNT data file into matlab workspace
% 
% Usage: [p] = gui_cnt_open(p,[command],[parent])
%
% p is a structure, generated by 'eeg_toolbox_defaults'
% command is either 'init' or 'load'
% parent is a handle to the gui that calls this gui, useful
% for updating the UserData field of the parent from this gui.
% The p structure is returned to the parent when the parent 
% handle is given.
%
% This function returns values into p.cnt
%

% $Revision: 1.1 $ $Date: 2009-04-28 22:13:56 $

% Licence:  GNU GPL, no express or implied warranties
% History:  10/2003, Darren.Weber_at_radiology.ucsf.edu
%                    created
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('p','var'),
 [p] = eeg_toolbox_defaults;
elseif isempty(p),
 [p] = eeg_toolbox_defaults;
end

if ~exist('command','var'), command = 'init'; end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paint the GUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch command,
  
  case 'init',
    
    if exist('parent','var'),
      CNTOpen = INIT(p,parent);
    else
      CNTOpen = INIT(p,'');
    end
    
  case 'plot',
    
    CNTOpen = get(gcbf,'Userdata');
    
    CNTOpen.p = cnt_open(CNTOpen.p,CNTOpen.gui);
    set(CNTOpen.gui,'Userdata',CNTOpen); % update GUI with CNT data
    
   [p] = gui_updateparent(CNTOpen,0);
    
    if isequal(get(CNTOpen.handles.Bhold,'Value'),0),
      close gcbf;
      if isfield(CNTOpen,'parent'),
        parent = CNTOpen.parent.gui;
      else
        parent = [];
      end
    else
      parent = CNTOpen.gui;
    end
    
    filename = [CNTOpen.p.cnt.path,CNTOpen.p.cnt.file];
    
    eeg_view_cnt(filename,'init',parent);
    
    
  case 'save',
    
    fprintf('\nGUI_CNT_OPEN: Save As not implemented yet.\n');
    
  case 'return',
    
    CNTOpen = get(gcbf,'Userdata');
    
    set(CNTOpen.gui,'Pointer','watch');
    
    CNTOpen.p = cnt_open(CNTOpen.p);
    
    set(CNTOpen.gui,'Pointer','arrow');
    
    if isequal(get(CNTOpen.handles.Bhold,'Value'),1),
     [p] = gui_updateparent(CNTOpen,0);
    else
     [p] = gui_updateparent(CNTOpen);
      close gcbf;
    end
    
  otherwise,
    
    CNTOpen = get(gcbf,'Userdata');
    GUI.parent = CNTOpen.parent;
    gui_updateparent(GUI);
    close gcbf;
    
end

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [CNTOpen] = INIT(p,parent)
% GUI General Parameters

GUIwidth  = 500;
GUIheight = 120;

version = '$Revision: 1.1 $';
name = sprintf('CNT File Open [v %s]\n',version(11:15));

GUI = figure('Name',name,'Tag','CNT_OPEN',...
  'NumberTitle','off',...
  'MenuBar','none','Position',[1 1 GUIwidth GUIheight]);
movegui(GUI,'center');

Font.FontName   = 'Helvetica';
Font.FontUnits  = 'Pixels';
Font.FontSize   = 12;
Font.FontWeight = 'normal';
Font.FontAngle  = 'normal';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CNT Data Selection and Parameters

G.Title_data = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
  'Position',[.01 .75 .17 .2],...
  'String','Data Type:','HorizontalAlignment','left');

switch lower(p.cnt.type),
  case 'scan4x_cnt',  cntType = 1;
  case 'scan3x_cnt',  cntType = 2;
  otherwise,          cntType = 1;
end

%  'String',{'ASCII_CNT' 'Scan4x_CNT' 'Scan3x_CNT' 'EEGLAB'},'Value',cntType,...

G.PcntType = uicontrol('Tag','PcntType','Parent',GUI,'Style','popupmenu',...
  'Units','Normalized',Font,  ...
  'Position',[.20 .75 .2 .2],...
  'String',{'scan4x_cnt' 'scan3x_cnt'},'Value',cntType,...
  'Callback',strcat('CNTOpen = get(gcbf,''Userdata'');',...
  'CNTOpen.p.cnt.type = popupstr(CNTOpen.handles.PcntType);',...
  'set(gcbf,''Userdata'',CNTOpen); clear CNTOpen;'));

G.Title_path = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
  'Position',[.01 .50 .17 .2],...
  'String','Path','HorizontalAlignment','left');
G.EcntPath = uicontrol('Parent',GUI,'Style','edit','Units','Normalized',Font,  ...
  'Position',[.20 .50 .58 .2], 'String',p.cnt.path,...
  'Callback',strcat('CNTOpen = get(gcbf,''Userdata'');',...
  'CNTOpen.p.cnt.path = get(CNTOpen.handles.EcntPath,''String'');',...
  'set(gcbf,''Userdata'',CNTOpen); clear CNTOpen;'));

G.Title_file = uicontrol('Parent',GUI,'Style','text','Units','Normalized',Font, ...
  'Position',[.01 .25 .17 .2],...
  'String','File','HorizontalAlignment','left');
G.EcntFile = uicontrol('Parent',GUI,'Style','edit','Units','Normalized',Font,  ...
  'Position',[.20 .25 .58 .2], 'String',p.cnt.file,...
  'Callback',strcat('CNTOpen = get(gcbf,''Userdata'');',...
  'CNTOpen.p.cnt.file = get(CNTOpen.handles.EcntFile,''String'');',...
  'set(gcbf,''Userdata'',CNTOpen); clear CNTOpen;'));

Font.FontWeight = 'bold';

% BROWSE: Look for the data
browsecommand = strcat('CNTOpen = get(gcbf,''Userdata'');',...
  'cd(CNTOpen.p.cnt.path);',...
  '[file, path] = uigetfile(',...
  '{''*.cnt'', ''NeuroScan (*.cnt)'';', ...
  ' ''*.*'',   ''All Files (*.*)''},', ...
  '''Select CNT File'');',...
  'if ~isequal(path,0), CNTOpen.p.cnt.path = path; end;',...
  'if ~isequal(file,0), CNTOpen.p.cnt.file = file; end;',...
  'set(CNTOpen.handles.EcntPath,''String'',CNTOpen.p.cnt.path);',...
  'set(CNTOpen.handles.EcntFile,''String'',CNTOpen.p.cnt.file);',...
  'set(gcbf,''Userdata'',CNTOpen); clear CNTOpen file path;');
G.BcntFile = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized',Font, ...
  'Position',[.01 .01 .17 .2], 'String','BROWSE',...
  'BackgroundColor',[0.8 0.8 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback', browsecommand );

% PLOT: Load & plot the data!
G.Bplot = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.20 .01 .18 .2],...
  'String','PLOT','BusyAction','queue',...
  'TooltipString','Plot the CNT data and return p struct.',...
  'BackgroundColor',[0.0 0.5 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('CNTOpen = get(gcbf,''Userdata'');',...
  'p = gui_cnt_open(CNTOpen.p,''plot'');',...
  'clear CNTOpen;'));

% Save As
G.Bsave = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.40 .01 .18 .2],'HorizontalAlignment', 'center',...
  'String','SAVE AS','TooltipString','CNT File Conversion Tool (not implemented yet)',...
  'BusyAction','queue',...
  'Visible','off',...
  'BackgroundColor',[0.0 0.0 0.75],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('CNTOpen = get(gcbf,''Userdata'');',...
  'p = gui_cnt_open(CNTOpen.p,''save'');',...
  'clear CNTOpen;'));

% Quit, return file parameters
G.Breturn = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.60 .01 .18 .2],...
  'String','RETURN','BusyAction','queue',...
  'TooltipString','Return p struct to workspace and parent GUI.',...
  'BackgroundColor',[0.75 0.0 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('CNTOpen = get(gcbf,''Userdata'');',...
  'p = gui_cnt_open(CNTOpen.p,''return'');',...
  'clear CNTOpen;'));

% Cancel
G.Bcancel = uicontrol('Parent',GUI,'Style','pushbutton','Units','Normalized', Font, ...
  'Position',[.80 .01 .18 .2],...
  'String','CANCEL','BusyAction','queue',...
  'TooltipString','Close, do not return parameters.',...
  'BackgroundColor',[0.75 0.0 0.0],...
  'ForegroundColor', [1 1 1], 'HorizontalAlignment', 'center',...
  'Callback',strcat('CNTOpen = get(gcbf,''Userdata'');',...
  'p = gui_cnt_open(CNTOpen.p,''cancel'');',...
  'clear CNTOpen;'));

% Hold GUI Open checkbox
G.Bhold = uicontrol('Parent',GUI,'Style','checkbox','Units','Normalized', Font, ...
  'Position',[.80 .25 .18 .2],'String','Hold GUI','BusyAction','queue',...
  'TooltipString','CNT File Load GUI remains open after ''Plot'' or ''Return'' commands.',...
  'Value',p.hold,'HorizontalAlignment', 'center');


% Store userdata
if exist('parent','var'), CNTOpen.parent.gui = parent; end
CNTOpen.gui = GUI;          
CNTOpen.handles = G;
CNTOpen.p = p;
set(GUI,'Userdata',CNTOpen);
set(GUI,'HandleVisibility','callback');

return
