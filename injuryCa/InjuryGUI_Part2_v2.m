function varargout = InjuryGUI_Part2_v2(varargin)
% INJURYGUI_PART2_V2 MATLAB code for InjuryGUI_Part2_v2.fig
%      INJURYGUI_PART2_V2, by itself, creates a new INJURYGUI_PART2_V2 or raises the existing
%      singleton*.
%
%      H = INJURYGUI_PART2_V2 returns the handle to a new INJURYGUI_PART2_V2 or the handle to
%      the existing singleton*.
%
%      INJURYGUI_PART2_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INJURYGUI_PART2_V2.M with the given input arguments.
%
%      INJURYGUI_PART2_V2('Property','Value',...) creates a new INJURYGUI_PART2_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before InjuryGUI_Part2_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to InjuryGUI_Part2_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help InjuryGUI_Part2_v2

% Last Modified by GUIDE v2.5 25-Apr-2017 18:54:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @InjuryGUI_Part2_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @InjuryGUI_Part2_v2_OutputFcn, ...
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


% --- Executes just before InjuryGUI_Part2_v2 is made visible.
function InjuryGUI_Part2_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to InjuryGUI_Part2_v2 (see VARARGIN)

% Choose default command line output for InjuryGUI_Part2_v2
handles.output = hObject;

handles.foldername=[];
handles.files=[];
handles.stack=[];
handles.F_cell=[];
handles.currentinjury=[];

global injurydata injury_neurons_revised
injurydata.injury_neurons_revised=[];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes InjuryGUI_Part2_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = InjuryGUI_Part2_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_load.
function button_load_Callback(hObject, eventdata, handles)
% hObject    handle to button_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
foldername=uigetdir;
handles.foldername=foldername;
handles.files=dir(foldername);
set(handles.listbox_foldercontent,'String',{handles.files.name}) %set string

%Load processed analysis file to grab raw fluorescence data
global F_cell
filename_analysis=[handles.foldername filesep 'processed_analysis.mat'];
load(filename_analysis);
F_cell=analysis(1).F_cell_scaled;
handles.F_cell=F_cell;

%Load injury file to grab injured neuron numbers
global neurons_main neurons_inradius neuronindex numberofinjuries currentinjury timepoints currenttimepoint timewindow injury_neurons_revised
filename_injury=[handles.foldername filesep 'injurydata' filesep 'injurydata.mat'];
load(filename_injury);
neurons_main=injurydata.injury_neurons;
neurons_inradius=injurydata.injury_neurons_inradius;
timepoints=injurydata.injury_timepoints;

numberofinjuries=length(injurydata.injury_neurons);

injury_neurons_revised=[];

currentinjury=0;
neuronindex=0;
handles.currentinjury=currentinjury;

%initialize display boxes
set(handles.text_neuroncurrent, 'String', '0');
set(handles.text_injurycurrent, 'String', num2str(currentinjury));
set(handles.text_injurytotal, 'String', num2str(length(timepoints)));

guidata(hObject,handles);




% --- Executes on selection change in listbox_foldercontent.
function listbox_foldercontent_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_foldercontent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_foldercontent contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_foldercontent

%Load selected tiff stack
index_selected = get(handles.listbox_foldercontent,'Value');
filename = [handles.foldername filesep handles.files(index_selected).name];
[tifstack,time,fps]=ReadTiffStack(filename);
handles.filename=filename;
handles.stack=tifstack;
guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function listbox_foldercontent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_foldercontent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in button_injured.
function button_injured_Callback(hObject, eventdata, handles)
% hObject    handle to button_injured (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Advance to next neuron in current injury

global F_cell neurons_main neurons_inradius numberofinjuries currentinjury timepoints currenttimepoint timewindow neuronindex injury_neurons_revised

if(neuronindex<length(neurons_inradius{currentinjury}))

    neuronindex=neuronindex+1;

    set(handles.text_neuroncurrent, 'String', num2str(neurons_inradius{currentinjury}(neuronindex)));
    set(handles.text_injurycurrent, 'String', num2str(currentinjury));
    set(handles.text_injurytotal, 'String', num2str(length(timepoints)));

    axes(handles.axes_fulltrace);
    cla
    set(handles.axes_fulltrace,'XLim',[0 size(F_cell,2)]);
    hold(handles.axes_fulltrace,'on');
    plot(handles.axes_fulltrace,F_cell(neurons_inradius{currentinjury}(neuronindex),:),'b'); hold on 
    line(handles.axes_fulltrace,[max([0 currenttimepoint-timewindow]) max([0 currenttimepoint-timewindow])],get(handles.axes_fulltrace,'YLim'),'Color','r');
    line(handles.axes_fulltrace,[min([currenttimepoint+timewindow size(F_cell,2)]) min([currenttimepoint+timewindow size(F_cell,2)])],get(handles.axes_fulltrace,'YLim'),'Color','r');
    set(handles.axes_fulltrace,'XTick',[]);
    set(handles.axes_fulltrace,'YTick',[]);
    hold(handles.axes_fulltrace,'on');

    axes(handles.axes_fulltrace2);
    cla
    set(handles.axes_fulltrace2,'XLim',[0 size(F_cell,2)]);
    plot(handles.axes_fulltrace2,F_cell(neurons_inradius{currentinjury}(neuronindex),:),'b'); hold on 
    set(handles.axes_fulltrace2,'XTick',[]);
    set(handles.axes_fulltrace2,'YTick',[]);

    axes(handles.axes_zoomtrace);
    cla
    set(handles.axes_zoomtrace,'XLim',[max([0 currenttimepoint-timewindow]) min([currenttimepoint+timewindow size(F_cell,2)])]);
    plot(handles.axes_zoomtrace,F_cell(neurons_inradius{currentinjury}(neuronindex),:),'b'); hold on 
    set(handles.axes_zoomtrace,'XTick',[]);
    set(handles.axes_zoomtrace,'YTick',[]);
    hold(handles.axes_fulltrace,'on');
    
    injury_neurons_revised=[injury_neurons_revised neurons_inradius{currentinjury}(neuronindex)];
    injury_neurons_revised=unique(injury_neurons_revised);
    
    save_alldata(handles);    
    
else
    axes(handles.axes_fulltrace);
    cla
    axes(handles.axes_zoomtrace);
    cla
    text(10, 0, 'Advance Injury', 'Parent', handles.axes_fulltrace,'FontSize',20);
end
guidata(hObject,handles);





% --- Executes on button press in button_uninjured.
function button_uninjured_Callback(hObject, eventdata, handles)
% hObject    handle to button_uninjured (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Advance to next neuron in current injury

global F_cell neurons_main neurons_inradius numberofinjuries currentinjury timepoints currenttimepoint timewindow neuronindex injury_neurons_revised

if(neuronindex<length(neurons_inradius{currentinjury}))

    neuronindex=neuronindex+1;

    set(handles.text_neuroncurrent, 'String', num2str(neurons_inradius{currentinjury}(neuronindex)));
    set(handles.text_injurycurrent, 'String', num2str(currentinjury));
    set(handles.text_injurytotal, 'String', num2str(length(timepoints)));

    axes(handles.axes_fulltrace);
    cla
    set(handles.axes_fulltrace,'XLim',[0 size(F_cell,2)]);
    hold(handles.axes_fulltrace,'on');
    plot(handles.axes_fulltrace,F_cell(neurons_inradius{currentinjury}(neuronindex),:),'b'); hold on 
    line(handles.axes_fulltrace,[max([0 currenttimepoint-timewindow]) max([0 currenttimepoint-timewindow])],get(handles.axes_fulltrace,'YLim'),'Color','r');
    line(handles.axes_fulltrace,[min([currenttimepoint+timewindow size(F_cell,2)]) min([currenttimepoint+timewindow size(F_cell,2)])],get(handles.axes_fulltrace,'YLim'),'Color','r');
    set(handles.axes_fulltrace,'XTick',[]);
    set(handles.axes_fulltrace,'YTick',[]);
    hold(handles.axes_fulltrace,'on');

    axes(handles.axes_fulltrace2);
    cla
    set(handles.axes_fulltrace2,'XLim',[0 size(F_cell,2)]);
    plot(handles.axes_fulltrace2,F_cell(neurons_inradius{currentinjury}(neuronindex),:),'b'); hold on 
    set(handles.axes_fulltrace2,'XTick',[]);
    set(handles.axes_fulltrace2,'YTick',[]);

    axes(handles.axes_zoomtrace);
    cla
    set(handles.axes_zoomtrace,'XLim',[max([0 currenttimepoint-timewindow]) min([currenttimepoint+timewindow size(F_cell,2)])]);
    plot(handles.axes_zoomtrace,F_cell(neurons_inradius{currentinjury}(neuronindex),:),'b'); hold on 
    set(handles.axes_zoomtrace,'XTick',[]);
    set(handles.axes_zoomtrace,'YTick',[]);
    hold(handles.axes_fulltrace,'on');
    
    save_alldata(handles);    
    
else
    axes(handles.axes_fulltrace);
    cla
    axes(handles.axes_zoomtrace);
    cla
    text(10, 0, 'Advance Injury', 'Parent', handles.axes_fulltrace,'FontSize',20);
end
guidata(hObject,handles);




% --- Executes on button press in button_nextinjury.
function button_nextinjury_Callback(hObject, eventdata, handles)
% hObject    handle to button_nextinjury (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global F_cell neurons_main neurons_inradius numberofinjuries currentinjury timepoints currenttimepoint timewindow neuronindex

currentinjury=currentinjury+1;
handles.currentinjury=currentinjury;
neuronindex=1;

currenttimepoint=timepoints(currentinjury);
timewindow=300;

%Initialize plot for this injury by plotting data for main neuron in injury
set(handles.text_neuroncurrent, 'String', num2str(neurons_main(currentinjury)));
set(handles.text_injurycurrent, 'String', num2str(currentinjury));
set(handles.text_injurytotal, 'String', num2str(length(timepoints)));

axes(handles.axes_fulltrace);
cla
set(handles.axes_fulltrace,'XLim',[0 size(F_cell,2)]);
hold(handles.axes_fulltrace,'on');
plot(handles.axes_fulltrace,F_cell(neurons_main(currentinjury),:),'b'); hold on 
line(handles.axes_fulltrace,[max([0 currenttimepoint]) max([0 currenttimepoint])],get(handles.axes_fulltrace,'YLim'),'Color','g');
line(handles.axes_fulltrace,[max([0 currenttimepoint-timewindow]) max([0 currenttimepoint-timewindow])],get(handles.axes_fulltrace,'YLim'),'Color','r');
line(handles.axes_fulltrace,[min([currenttimepoint+timewindow size(F_cell,2)]) min([currenttimepoint+timewindow size(F_cell,2)])],get(handles.axes_fulltrace,'YLim'),'Color','r');
set(handles.axes_fulltrace,'XTick',[]);
set(handles.axes_fulltrace,'YTick',[]);

axes(handles.axes_fulltrace2);
cla
set(handles.axes_fulltrace2,'XLim',[0 size(F_cell,2)]);
plot(handles.axes_fulltrace2,F_cell(neurons_main(currentinjury),:),'b'); hold on 
set(handles.axes_fulltrace2,'XTick',[]);
set(handles.axes_fulltrace2,'YTick',[]);

axes(handles.axes_zoomtrace);
cla
plot(handles.axes_zoomtrace,F_cell(neurons_main(currentinjury),:),'b'); hold on 
line(handles.axes_fulltrace,[max([0 currenttimepoint]) max([0 currenttimepoint])],get(handles.axes_zoomtrace,'YLim'),'Color','g');
set(handles.axes_zoomtrace,'XLim',[max([0 currenttimepoint-timewindow]) min([currenttimepoint+timewindow size(F_cell,2)])]);
set(handles.axes_zoomtrace,'XTick',[]);
set(handles.axes_zoomtrace,'YTick',[]);
hold(handles.axes_fulltrace,'on');

axes(handles.axes_video);
imin = min(handles.stack(:));
imax = max(handles.stack(:));
handles.cmin = imin;
handles.cmax = imax;
I = handles.stack(:,:,currenttimepoint);
handles.I = I;
imagesc(I,'Parent',handles.axes_video,[handles.cmin handles.cmax]); 
set(handles.axes_video,'XTickLabel',[]);
set(handles.axes_video,'YTickLabel',[]);


guidata(hObject, handles);




function text_neuroncurrent_Callback(hObject, eventdata, handles)
% hObject    handle to text_neuroncurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_neuroncurrent as text
%        str2double(get(hObject,'String')) returns contents of text_neuroncurrent as a double



% --- Executes during object creation, after setting all properties.
function text_neuroncurrent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_neuroncurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function text_injurycurrent_Callback(hObject, eventdata, handles)
% hObject    handle to text_injurycurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_injurycurrent as text
%        str2double(get(hObject,'String')) returns contents of text_injurycurrent as a double


% --- Executes during object creation, after setting all properties.
function text_injurycurrent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_injurycurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_injurytotal_Callback(hObject, eventdata, handles)
% hObject    handle to text_injurytotal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_injurytotal as text
%        str2double(get(hObject,'String')) returns contents of text_injurytotal as a double


% --- Executes during object creation, after setting all properties.
function text_injurytotal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_injurytotal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function save_alldata(handles)

global injurydata injury_neurons_revised
injurydata.injury_neurons_revised=injury_neurons_revised;

if ~exist([handles.foldername filesep 'injurydata'], 'dir')
 mkdir([handles.foldername filesep 'injurydata']);
end

disp('Saving data');
save([handles.foldername filesep 'injurydata' filesep 'injurydata_revised.mat'],'injurydata');
