function varargout = Injury_GUI(varargin)
% INJURY_GUI MATLAB code for Injury_GUI.fig
%      INJURY_GUI, by itself, creates a new INJURY_GUI or raises the existing
%      singleton*.
%
%      H = INJURY_GUI returns the handle to a new INJURY_GUI or the handle to
%      the existing singleton*.
%
%      INJURY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INJURY_GUI.M with the given input arguments.
%
%      INJURY_GUI('Property','Value',...) creates a new INJURY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Injury_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Injury_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Injury_GUI

% Last Modified by GUIDE v2.5 05-Nov-2017 09:18:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Injury_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Injury_GUI_OutputFcn, ...
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


% --- Executes just before Injury_GUI is made visible.
function Injury_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Injury_GUI (see VARARGIN)

% Choose default command line output for Injury_GUI
handles.output = hObject;

handles.foldername=[];
handles.files=[];
handles.stack=[];
handles.radius=20;
handles.totalframes=0;
handles.enhance_contrast = 0;

global injury_timepoints  injury_positions injury_radius injury_neurons injury_neurons_inradius injurydata 
injury_timepoints=[];
injury_positions=[;];
injury_radius=[];
injury_neurons=[];
injury_neurons_inradius={};
injurydata=struct();


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Injury_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Injury_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output ;




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


% --- Executes on button press in button_folderinput.
function button_folderinput_Callback(hObject, eventdata, handles)
% hObject    handle to button_folderinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
foldername=uigetdir;
handles.foldername=foldername;
handles.files=dir(foldername);
set(handles.listbox_foldercontent,'String',{handles.files.name}) %set string
guidata(hObject,handles);
%Update(handles);




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
[tifstack,time,fps]=ReadTiffStack(filename);                        % ! from Tapan Patel's GUI !
handles.filename=filename;
handles.stack=tifstack;

%Open first frame of selected tiff stack in video window            % !modified from Tapan Patel's GUI !
handles.enhance_contrast = 0;
handles.imin = min(min(handles.stack(:)));
handles.imax = max(max(handles.stack(:)));
I = handles.stack(:,:,1);
handles.I = I;
handles.N = size(handles.stack,3);
handles.idx = 1;
handles.fps = 20;

%Plot first frame in video window
if(handles.enhance_contrast)
    I = imadjust(I,stretchlim(I),[]);
end
imagesc(I,'Parent',handles.axes_video); colormap(gray);
set(handles.axes_video,'XTickLabel',[]);
set(handles.axes_video,'YTickLabel',[]);
set(handles.text_framenumber, 'String', handles.totalframes+1);

% Update slider
set(handles.slider1,'Min',1,'Max',handles.N,'Value',1);
set(handles.slider1,'SliderStep',[1/handles.N 20/handles.N]);


%Load and display UNREGISTERED segmentation file (binary) in segmentation window
  %use segmentation file from the _0HRS RECORDING, which should be the
  %exact same as for the injury recording; use this so that cell numbering is exactly
  %the same, and to then use the renumbering map used for the _0hrs
  %recording to renumber (register) the injury neuron numbers to match the other registered conditions
  
%filename_Iseg=[handles.foldername filesep 'Segmentation-' handles.files(index_selected).name(1:end-4) '_0hrs.tif'];  
segfilepath=dir([handles.foldername filesep 'Segmentation*.tif']); 
filename_Iseg=[handles.foldername filesep segfilepath.name];
Iseg=imread(filename_Iseg);
handles.Iseg=Iseg;
imshow(Iseg,'Parent',handles.axes_segmentation); 
set(handles.axes_segmentation,'XTickLabel',[]);
set(handles.axes_segmentation,'YTickLabel',[])

set(handles.text_currentinjury, 'String', 'NaN');
set(handles.text_injurynumber, 'String', 'NaN');
set(handles.text_injuryframes, 'String', 'NaN');
set(handles.text_radius, 'String', handles.radius);

%Load processed analysis file to grab numbered segmentation file
global L
filename_analysis=[handles.foldername filesep 'processed_analysis_othercond.mat'];
load(filename_analysis);
L=analysis(2).L;                    %FOR OLD analysis files with WRONG analysis.L, need to switch to analysis(3).L 
handles.L=L;

save_alldata(handles);

guidata(hObject,handles);




% --- Executes on button press in button_brighten.
function button_brighten_Callback(hObject, eventdata, handles)
% hObject    handle to button_brighten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

brighten(handles.axes_video,0.2);

guidata(hObject,handles);


% --- Executes on button press in button_play.
function button_play_Callback(hObject, eventdata, handles)
% hObject    handle to button_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Play all images in the stack at frame rate specified, start from current
% index
global cancel;
cancel=0;
fps = handles.fps;

imshow(handles.Iseg,'Parent',handles.axes_segmentation); 
set(handles.axes_segmentation,'XTickLabel',[]);
set(handles.axes_segmentation,'YTickLabel',[])

for i=handles.idx:handles.N
    if(~cancel)
%         if(handles.enhance_contrast)
%             I = imadjust(handles.stack(:,:,i),stretchlim([handles.cmin handles.cmax]));
%         else
%             I = handles.stack(:,:,i);
%         end
        I = handles.stack(:,:,i);
        
        imagesc(I,'Parent',handles.axes_video); colormap(gray);
        handles.idx = i;
        set(handles.axes_video,'XTickLabel',[]);
        set(handles.axes_video,'YTickLabel',[]);
        set(handles.slider1,'Value',i);
        set(handles.text_framenumber, 'String', num2str(i));
        pause(1/fps);
        
        else
        guidata(hObject,handles);
        handles.idx=i-1;
        break;
    end
end
guidata(hObject,handles);



% --- Executes on button press in button_stop.
function button_stop_Callback(hObject, eventdata, handles)
% hObject    handle to button_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cancel;
cancel=1;
guidata(hObject,handles);



% --- Executes on button press in button_injury.
function button_injury_Callback(hObject, eventdata, handles)
% hObject    handle to button_injury (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%update displayed variables
global injury_timepoints injury_positions
injury_timepoints=[injury_timepoints handles.idx+handles.totalframes];
set(handles.text_currentinjury, 'String', num2str(handles.idx+handles.totalframes));
set(handles.text_injurynumber, 'String', num2str(length(injury_timepoints)));
set(handles.text_injuryframes, 'String', num2str(injury_timepoints));

%mark injury position
global injury_radius
[injury_positions(length(injury_timepoints),1), injury_positions(length(injury_timepoints),2)]=myginput(1,'arrow');
hold(handles.axes_segmentation,'on');
plot(handles.axes_segmentation,injury_positions(length(injury_timepoints),1),injury_positions(length(injury_timepoints),2),'r*','MarkerSize', 4);
plot(handles.axes_segmentation,injury_positions(length(injury_timepoints),1),injury_positions(length(injury_timepoints),2),'ro','MarkerSize', handles.radius);
hold(handles.axes_segmentation,'off');
injury_radius=[injury_radius handles.radius];

%find neuron number at injury site
global L injury_neurons injury_neuron_current
injury_neuron_current=L(floor(injury_positions(length(injury_timepoints),2)), floor(injury_positions(length(injury_timepoints),1)));
injury_neurons=[injury_neurons injury_neuron_current];
set(handles.text_currentneuron, 'String', num2str(injury_neuron_current));
set(handles.text_injuryneurons, 'String', num2str(injury_neurons));

%find neurons within injury radius
global neurons_inradius injury_neurons_inradius
y_min=max([0 injury_positions(length(injury_timepoints),1)-injury_radius]);
y_max=min([injury_positions(length(injury_timepoints),1)+injury_radius size(L,2)]);
x_min=max([0 injury_positions(length(injury_timepoints),2)-injury_radius]);
x_max=min([injury_positions(length(injury_timepoints),2)+injury_radius size(L,1)]);
L_restricted=L(x_min:x_max,y_min:y_max);                           %look within area defined by radius    
neurons_inradius=unique(L_restricted);                      %find all unique values (neuron #) in restricted segmentation file
injury_neurons_inradius{length(injury_timepoints)}=neurons_inradius(~(~neurons_inradius));    %eliminate 0 from the list

clear y_min y_max x_min x_max neurons_inradius

save_alldata(handles);

guidata(hObject,handles);


% --- Executes on button press in button_clearlastinj.
function button_clearlastinj_Callback(hObject, eventdata, handles)
% hObject    handle to button_clearlastinj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global injury_timepoints injury_positions injury_radius injury_neurons injury_neurons_inradius
injury_timepoints=injury_timepoints(1:end-1);
injury_positions=injury_positions(1:end-1,:);
injury_radius=injury_radius(1:end-1);
injury_neurons=injury_neurons(1:end-1);
injury_neurons_inradius=injury_neurons_inradius(1:end-1);

set(handles.text_currentinjury, 'String', 'NaN');
set(handles.text_injurynumber, 'String', num2str(length(injury_timepoints)));
set(handles.text_injuryframes, 'String', num2str(injury_timepoints));
set(handles.text_injuryneurons, 'String', num2str(injury_neurons));
set(handles.text_currentneuron, 'String', 'NaN');

imshow(handles.Iseg,'Parent',handles.axes_segmentation); 
set(handles.axes_segmentation,'XTickLabel',[]);
set(handles.axes_segmentation,'YTickLabel',[])

save_alldata(handles);

guidata(hObject,handles);



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function text_framenumber_Callback(hObject, eventdata, handles)
% hObject    handle to text_framenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_framenumber as text
%        str2double(get(hObject,'String')) returns contents of text_framenumber as a double

handles.idx=str2num(handles.text_framenumber.String);


guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function text_framenumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_framenumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_injurynumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_injurynumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_injuryframes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_injurynumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_injuryneurons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_injurynumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function text_currentinjury_Callback(hObject, eventdata, handles)
% hObject    handle to text_currentinjury (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_currentinjury as text
%        str2double(get(hObject,'String')) returns contents of text_currentinjury as a double


% --- Executes during object creation, after setting all properties.
function text_currentinjury_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_currentinjury (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function text_radius_Callback(hObject, eventdata, handles)
% hObject    handle to text_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of text_radius as text
%        str2double(get(hObject,'String')) returns contents of text_radius as a double
handles.radius=str2num(handles.text_radius.String);
global injury_radius injury_timepoints injury_positions L
injury_radius(length(injury_timepoints))=handles.radius;

%find neurons within injury radius using the UPDATED radius value
global neurons_inradius injury_neurons_inradius
y_min=max([0 injury_positions(length(injury_timepoints),1)-injury_radius]);
y_max=min([injury_positions(length(injury_timepoints),1)+injury_radius size(L,2)]);
x_min=max([0 injury_positions(length(injury_timepoints),2)-injury_radius]);
x_max=min([injury_positions(length(injury_timepoints),2)+injury_radius size(L,1)]);
L_restricted=L(x_min:x_max,y_min:y_max);                    %look within area defined by radius    
neurons_inradius=unique(L_restricted);                      %find all unique values (neuron #) in restricted segmentation file
injury_neurons_inradius{length(injury_timepoints)}=neurons_inradius(~(~neurons_inradius));    %eliminate 0 from the list

clear y_min y_max x_min x_max neurons_inradius

save_alldata(handles);

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function text_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_redraw.
function button_redraw_Callback(hObject, eventdata, handles)
% hObject    handle to button_redraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global injury_timepoints injury_positions

imshow(handles.Iseg,'Parent',handles.axes_segmentation); 
set(handles.axes_segmentation,'XTickLabel',[]);
set(handles.axes_segmentation,'YTickLabel',[])

hold(handles.axes_segmentation,'on');
plot(handles.axes_segmentation,injury_positions(length(injury_timepoints),1),injury_positions(length(injury_timepoints),2),'r*','MarkerSize', 4);
plot(handles.axes_segmentation,injury_positions(length(injury_timepoints),1),injury_positions(length(injury_timepoints),2),'ro','MarkerSize', handles.radius);
hold(handles.axes_segmentation,'off');


% --- Executes on button press in button_save.
function save_alldata(handles)

global injurydata injury_timepoints injury_positions injury_radius injury_neurons injury_neurons_inradius
injurydata.injury_timepoints=injury_timepoints;
injurydata.injury_positions=injury_positions;
injurydata.injury_radius=injury_radius;
injurydata.injury_neurons=injury_neurons;
injurydata.injury_neurons_inradius=injury_neurons_inradius;

if ~exist([handles.foldername filesep 'injurydata'], 'dir')
 mkdir([handles.foldername filesep 'injurydata']);
end

%disp('Saving data');
save([handles.foldername filesep 'injurydata' filesep 'injurydata.mat'],'injurydata');



function text_currentneuron_Callback(hObject, eventdata, handles)
% hObject    handle to text_currentneuron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_currentneuron as text
%        str2double(get(hObject,'String')) returns contents of text_currentneuron as a double


% --- Executes during object creation, after setting all properties.
function text_currentneuron_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_currentneuron (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_next.
function button_next_Callback(hObject, eventdata, handles)
% hObject    handle to button_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.totalframes=handles.totalframes+handles.N;

guidata(hObject,handles);


