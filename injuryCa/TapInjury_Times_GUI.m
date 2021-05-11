function varargout = TapInjury_Times_GUI(varargin)
% TAPINJURY_TIMES_GUI MATLAB code for TapInjury_Times_GUI.fig
%      TAPINJURY_TIMES_GUI, by itself, creates a new TAPINJURY_TIMES_GUI or raises the existing
%      singleton*.
%
%      H = TAPINJURY_TIMES_GUI returns the handle to a new TAPINJURY_TIMES_GUI or the handle to
%      the existing singleton*.
%
%      TAPINJURY_TIMES_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAPINJURY_TIMES_GUI.M with the given inpnut arguments.
%
%      TAPINJURY_TIMES_GUI('Property','Value',...) creates a new TAPINJURY_TIMES_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TapInjury_Times_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TapInjury_Times_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TapInjury_Times_GUI

% Last Modified by GUIDE v2.5 06-Jun-2017 15:41:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TapInjury_Times_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TapInjury_Times_GUI_OutputFcn, ...
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





%INITIALIZING
% --- Executes just before TapInjury_Times_GUI is made visible.
function TapInjury_Times_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TapInjury_Times_GUI (see VARARGIN)

% Choose default command line output for TapInjury_Times_GUI
handles.output = hObject;

handles.foldername=[];
handles.files=[];
handles.stack=[];

global injury_periods postInjury_periods injury_times injury_start_index 
global injury_stop_index  postInjury_start_index postInjury_stop_index folder 
global num_videos file injury_toggle postInjury_toggle video_log tot_frames
injury_periods = {};
postInjury_periods = {};
injury_times=struct();
injury_start_index = 1;
injury_stop_index = 1;
postInjury_start_index = 1;
postInjury_stop_index = 1;
folder = '';
num_videos = 1;
file = '';
injury_toggle = 'start';
postInjury_toggle = 'start';
video_log = {};
tot_frames = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TapInjury_Times_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TapInjury_Times_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





%LOADING/VIDEO PLAY RELATED 
% --- Executes on button press in Input_Directory.
function Input_Directory_Callback(hObject, eventdata, handles)
% hObject    handle to Input_Directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
foldername=uigetdir;
handles.foldername=foldername;
global folder
folder = foldername;
handles.files=dir(foldername);
set(handles.FolderContent,'String',{handles.files.name}) %set string
guidata(hObject,handles);
%Update(handles);


% --- Executes on selection change in FolderContent.
function FolderContent_Callback(hObject, eventdata, handles)
% hObject    handle to FolderContent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FolderContent contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FolderContent

%Load selected tiff stack
index_selected = get(handles.FolderContent,'Value');
filename = [handles.foldername filesep handles.files(index_selected).name];
global file video_log num_videos
file = filename;
video_log{num_videos} = file;
set(handles.disp_videos, 'String', char(video_log));
[tifstack,time,fps]=ReadTiffStack(filename);
handles.filename=filename;
handles.stack=tifstack;

%Open first frame of selected tiff stack in video window
imin = min(handles.stack(:));
imax = max(handles.stack(:));
%adjust max (account for large bursts during lamp on...helps scale
if (imax-imin)>1150
    imax = 1000 + imin;
end
handles.bitDepth = class(handles.stack);
handles.enhance_contrast = 0;
handles.cmin = imin;
handles.cmax = imax;
I = handles.stack(:,:,1);
handles.I = I;
handles.N = size(handles.stack,3);
handles.idx = 1;
handles.fps = 20;

%Plot first frame in video window
if(handles.enhance_contrast)
    I = imadjust(I,stretchlim([handles.cmin handles.cmax]));
    disp('enhanced');
end
imagesc(I,'Parent',handles.axes_video,[handles.cmin handles.cmax]); 
set(handles.axes_video,'XTickLabel',[]);
set(handles.axes_video,'YTickLabel',[]);
set(handles.CurrFrameNum, 'String', 1);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function FolderContent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FolderContent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~strcmp(get(handles.GoToNum,'String'), 'Edit Text')
    handles.idx = str2double(get(handles.GoToNum,'String'));
end

global cancel;
cancel=0;
fps = handles.fps;

for i=handles.idx:handles.N
    if(~cancel)
        if(handles.enhance_contrast)
            I = imadjust(handles.stack(:,:,i),stretchlim([handles.cmin handles.cmax]));
        else
            I = handles.stack(:,:,i);
        end
        imagesc(I,'Parent',handles.axes_video,[handles.cmin handles.cmax]);
        handles.idx = i;
        set(handles.axes_video,'XTickLabel',[]);
        set(handles.axes_video,'YTickLabel',[]);
        set(handles.CurrFrameNum, 'String', num2str(i));
        set(handles.GoToNum, 'String', num2str(i));
        pause(1/fps);
        
        else
        guidata(hObject,handles);
        handles.idx=i-1;
        break;
    end
end
guidata(hObject,handles);


% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cancel;
cancel=1;
guidata(hObject,handles);


function GoToNum_Callback(hObject, eventdata, handles)
% hObject    handle to GoToNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GoToNum as text
%        str2double(get(hObject,'String')) returns contents of GoToNum as a double


% --- Executes during object creation, after setting all properties.
function GoToNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GoToNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in previous_frame.
function previous_frame_Callback(hObject, eventdata, handles)
% hObject    handle to previous_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.idx = handles.idx-1;
%update video
if(handles.enhance_contrast)
    I = imadjust(handles.stack(:,:,handles.idx),stretchlim([handles.cmin handles.cmax]));
else
    I = handles.stack(:,:,handles.idx);
end
imagesc(I,'Parent',handles.axes_video,[handles.cmin handles.cmax]);
set(handles.axes_video,'XTickLabel',[]);
set(handles.axes_video,'YTickLabel',[]);
%update variables
set(handles.CurrFrameNum, 'String', num2str(handles.idx));
set(handles.GoToNum, 'String', num2str(handles.idx));
guidata(hObject,handles);


% --- Executes on button press in next_frame.
function next_frame_Callback(hObject, eventdata, handles)
% hObject    handle to next_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.idx = handles.idx+1;
%updtae video 
if(handles.enhance_contrast)
    I = imadjust(handles.stack(:,:,handles.idx),stretchlim([handles.cmin handles.cmax]));
else
    I = handles.stack(:,:,handles.idx);
end
imagesc(I,'Parent',handles.axes_video,[handles.cmin handles.cmax]);
set(handles.axes_video,'XTickLabel',[]);
set(handles.axes_video,'YTickLabel',[]);
%update variables 
set(handles.CurrFrameNum, 'String', num2str(handles.idx));
set(handles.GoToNum, 'String', num2str(handles.idx));
guidata(hObject,handles);





%BUTTONS UNDER VIDEO
% --- Executes on button press in Inj_Start.
function Inj_Start_Callback(hObject, eventdata, handles)
% hObject    handle to Inj_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global injury_periods injury_start_index num_videos injury_toggle tot_frames
injury_periods{injury_start_index, 1}(1) = tot_frames + handles.idx;
%update displayed variables
display = '';
for i = 1:length(injury_periods)
    display = strcat(display, mat2str(injury_periods{i}));
end
set(handles.InjPer_Entries, 'String', display);
injury_start_index = injury_start_index + 1;
injury_toggle = 'start';
guidata(hObject,handles);


% --- Executes on button press in Inj_Stop.
function Inj_Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Inj_Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global injury_periods injury_stop_index num_videos injury_toggle tot_frames
injury_periods{injury_stop_index, 1}(2) = tot_frames + handles.idx;
%update displayed variables
display = '';
for i = 1:length(injury_periods)
    display = strcat(display, mat2str(injury_periods{i}));
end
set(handles.InjPer_Entries, 'String', display);
injury_stop_index = injury_stop_index + 1;
injury_toggle = 'stop';

%calc total num injuries
total = length(injury_periods);
set(handles.TotInjPerNum, 'String', num2str(total));
guidata(hObject,handles);


% --- Executes on button press in PostInj_Start.
function PostInj_Start_Callback(hObject, eventdata, handles)
% hObject    handle to PostInj_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global postInjury_periods postInjury_start_index num_videos postInjury_toggle tot_frames
postInjury_periods{postInjury_start_index, 1}(1) = tot_frames + handles.idx;
%update displayed variables
display = '';
for i = 1:length(postInjury_periods)
    display = strcat(display, mat2str(postInjury_periods{i}));
end
set(handles.PostInjPer_Entries, 'String', display);
postInjury_start_index = postInjury_start_index + 1;
postInjury_toggle = 'start';
guidata(hObject,handles);


% --- Executes on button press in PostInj_Stop.
function PostInj_Stop_Callback(hObject, eventdata, handles)
% hObject    handle to PostInj_Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global postInjury_periods postInjury_stop_index num_videos postInjury_toggle tot_frames
postInjury_periods{postInjury_stop_index, 1}(2) = tot_frames + handles.idx;
%update displayed variables
display = '';
for i = 1:length(postInjury_periods)
    display = strcat(display, mat2str(postInjury_periods{i}));
end
set(handles.PostInjPer_Entries, 'String', display);
postInjury_stop_index = postInjury_stop_index + 1;
postInjury_toggle = 'stop';

total = length(postInjury_periods);
set(handles.TotPostInjPerNum, 'String', num2str(total));
guidata(hObject,handles);


% --- Executes on button press in Clear_injury.
function Clear_injury_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_injury (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global injury_periods injury_start_index injury_toggle injury_stop_index 
if strcmp(injury_toggle, 'start')
    if injury_start_index == 2
        injury_periods = {};
        injury_start_index = 1;
    else
        injury_periods = injury_periods(1:(injury_start_index-2));
        injury_start_index = injury_start_index - 1;
        injury_toggle = 'stop';
    end
else
    injury_periods{injury_stop_index-1} = injury_periods{injury_stop_index-1}(1);
    injury_stop_index = injury_stop_index - 1;
    injury_toggle = 'start';
end
%update display
display = '';
for i = 1:length(injury_periods)
    display = strcat(display, mat2str(injury_periods{i}));
end
set(handles.InjPer_Entries, 'String', display);
guidata(hObject,handles);


% --- Executes on button press in Clear_postInjury.
function Clear_postInjury_Callback(hObject, eventdata, handles)
% hObject    handle to Clear_postInjury (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global postInjury_periods postInjury_start_index postInjury_toggle postInjury_stop_index 
if strcmp(postInjury_toggle, 'start')
    if postInjury_start_index == 2
        postInjury_periods = {};
        postInjury_start_index = 1;
        postInjury_toggle = 'stop';
    else
        postInjury_periods = postInjury_periods(1:(postInjury_start_index-2));
        postInjury_start_index = postInjury_start_index - 1;
        postInjury_toggle = 'stop';
    end
else
    postInjury_periods{postInjury_stop_index-1} = postInjury_periods{postInjury_stop_index-1}(1);
    postInjury_stop_index = postInjury_stop_index - 1;
    postInjury_toggle = 'start';
end
%update display
display = '';
for i = 1:length(postInjury_periods)
    display = strcat(display, mat2str(postInjury_periods{i}));
end
set(handles.PostInjPer_Entries, 'String', display);
guidata(hObject,handles);





%DISPLAY 
function CurrFrameNum_Callback(hObject, eventdata, handles)
% hObject    handle to CurrFrameNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrFrameNum as text
%        str2double(get(hObject,'String')) returns contents of CurrFrameNum as a double


% --- Executes during object creation, after setting all properties.
function CurrFrameNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrFrameNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in InjPer_Entries.
function InjPer_Entries_Callback(hObject, eventdata, handles)
% hObject    handle to InjPer_Entries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns InjPer_Entries contents as cell array
%        contents{get(hObject,'Value')} returns selected item from InjPer_Entries


% --- Executes during object creation, after setting all properties.
function InjPer_Entries_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InjPer_Entries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PostInjPer_Entries.
function PostInjPer_Entries_Callback(hObject, eventdata, handles)
% hObject    handle to PostInjPer_Entries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PostInjPer_Entries contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PostInjPer_Entries


% --- Executes during object creation, after setting all properties.
function PostInjPer_Entries_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PostInjPer_Entries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TotInjPerNum_Callback(hObject, eventdata, handles)
% hObject    handle to TotInjPerNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TotInjPerNum as text
%        str2double(get(hObject,'String')) returns contents of TotInjPerNum as a double


% --- Executes during object creation, after setting all properties.
function TotInjPerNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotInjPerNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TotPostInjPerNum_Callback(hObject, eventdata, handles)
% hObject    handle to TotPostInjPerNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TotPostInjPerNum as text
%        str2double(get(hObject,'String')) returns contents of TotPostInjPerNum as a double


% --- Executes during object creation, after setting all properties.
function TotPostInjPerNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotPostInjPerNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





%CONTINUING ANALYSIS/SAVE
% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global injury_periods postInjury_periods injury_times num_videos file
injury_times(num_videos).filename = file;
injury_times(num_videos).injury_periods = injury_periods;
injury_times(num_videos).postInjury_periods = postInjury_periods;

global folder
save([folder filesep 'injury_times'], 'injury_times');


% --- Executes on button press in Next.
function Next_Callback(hObject, eventdata, handles)
% hObject    handle to Next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes_video);
global num_videos tot_frames
num_videos = num_videos+1;
set(handles.GoToNum, 'String', '1');
handles.idx = str2double(get(handles.GoToNum,'String'));
tot_frames = tot_frames + handles.N;

guidata(hObject,handles);


% --- Executes on button press in Previous_video.
function Previous_video_Callback(hObject, eventdata, handles)
% hObject    handle to Previous_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global num_videos injury_times video_log tot_frames
num_videos = num_videos-1;
injury_times = injury_times(1:end-1);
video_log = video_log(1:end-1);
set(handles.disp_videos, 'String', char(video_log));
tot_frames = tot_frames - handles.N;

[tifstack,time,fps]=ReadTiffStack(video_log{end});
handles.filename=video_log{end};
handles.stack=tifstack;

%Open first frame of selected tiff stack in video window
imin = min(handles.stack(:));
imax = max(handles.stack(:));
handles.bitDepth = class(handles.stack);
handles.enhance_contrast = 0;
handles.cmin = imin;
handles.cmax = imax;
I = handles.stack(:,:,1);
handles.I = I;
handles.N = size(handles.stack,3);
handles.idx = 1;
handles.fps = 20;

%Plot first frame in video window
if(handles.enhance_contrast)
    I = imadjust(I,stretchlim([handles.cmin handles.cmax]));
end
imagesc(I,'Parent',handles.axes_video,[handles.cmin handles.cmax]); 
set(handles.axes_video,'XTickLabel',[]);
set(handles.axes_video,'YTickLabel',[]);
set(handles.CurrFrameNum, 'String', 1);
set(handles.GoToNum, 'String', '1');
handles.idx = str2double(get(handles.GoToNum,'String'));
guidata(hObject,handles);


function disp_videos_Callback(hObject, eventdata, handles)
% hObject    handle to disp_videos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of disp_videos as text
%        str2double(get(hObject,'String')) returns contents of disp_videos as a double


% --- Executes during object creation, after setting all properties.
function disp_videos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disp_videos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
