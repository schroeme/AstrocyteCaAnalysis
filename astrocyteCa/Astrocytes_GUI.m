function varargout = Astrocytes_GUI(varargin)
% ASTROCYTES_GUI MATLAB code for Astrocytes_GUI.fig
%      ASTROCYTES_GUI, by itself, creates a new ASTROCYTES_GUI or raises the existing
%      singleton*.
%
%      H = ASTROCYTES_GUI returns the handle to a new ASTROCYTES_GUI or the handle to
%      the existing singleton*.
%
%      ASTROCYTES_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASTROCYTES_GUI.M with the given input arguments.
%
%      ASTROCYTES_GUI('Property','Value',...) creates a new ASTROCYTES_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Astrocytes_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Astrocytes_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Astrocytes_GUI

% Last Modified by GUIDE v2.5 07-Jun-2018 20:59:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Astrocytes_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Astrocytes_GUI_OutputFcn, ...
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


% --- Executes just before Astrocytes_GUI is made visible.
function Astrocytes_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Astrocytes_GUI (see VARARGIN)

% Choose default command line output for Astrocytes_GUI
handles.output = hObject;

handles.foldername=[];
handles.files=[];
handles.radius=20;
handles.total_astros=0;

global  astro_positions neighbor_radius astro_numbers neighbor_neurons astrodata astro_count
astro_positions=[;];
neighbor_radius=[];
astro_numbers=[];
neighbor_neurons={};
astrodata=struct();
astro_count = 0;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Astrocytes_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Astrocytes_GUI_OutputFcn(hObject, eventdata, handles) 
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
handles.filename=filename;

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

set(handles.text_astronumber, 'String', 'NaN');
set(handles.text_astrocount, 'String', 'NaN');
set(handles.text_radius, 'String', handles.radius);

%Load processed analysis file to grab numbered segmentation file
global L
filename_analysis=[handles.foldername filesep 'processed_analysis.mat'];
load(filename_analysis);
L=analysis(1).L;                    %FOR OLD analysis files with WRONG analysis.L, need to switch to analysis(3).L 
handles.L=L;

guidata(hObject,handles);

% --- Executes on button press in button_add_astro.
function button_add_astro_Callback(hObject, eventdata, handles)
% hObject    handle to button_add_astro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%update displayed variables
global astro_positions
global astro_count
global astro_number

astro_count = astro_count + 1;
set(handles.text_astrocount, 'String', num2str(astro_count));

%mark injury position
global neighbor_radius
[astro_positions(astro_count,1), astro_positions(astro_count,2)]=myginput(1,'arrow');
hold(handles.axes_segmentation,'on');
plot(handles.axes_segmentation,astro_positions(astro_count,1),astro_positions(astro_count,2),'r*','MarkerSize', 4);
plot(handles.axes_segmentation,astro_positions(astro_count,1),astro_positions(astro_count,2),'ro','MarkerSize', handles.radius);
hold(handles.axes_segmentation,'off');
neighbor_radius=[neighbor_radius handles.radius];

%find neuron number at injury site
global L astro_numbers
astro_number =L(floor(astro_positions(astro_count,2)), floor(astro_positions(astro_count,1)));
astro_numbers=[astro_numbers astro_number];
set(handles.text_astronumber, 'String', num2str(astro_number));
set(handles.text_astronumbers, 'String', num2str(astro_numbers));

%find neurons within injury radius
global neurons_inradius neighbor_neurons
y_min=max([0 astro_positions(astro_count,1)-neighbor_radius]);
y_max=min([astro_positions(astro_count,1)+neighbor_radius size(L,2)]);
x_min=max([0 astro_positions(astro_count,2)-neighbor_radius]);
x_max=min([astro_positions(astro_count,2)+neighbor_radius size(L,1)]);
L_restricted=L(x_min:x_max,y_min:y_max);                           %look within area defined by radius    
neurons_inradius=unique(L_restricted);                      %find all unique values (neuron #) in restricted segmentation file
neighbor_neurons{astro_count}=neurons_inradius(~(~neurons_inradius));    %eliminate 0 from the list

clear y_min y_max x_min x_max neurons_inradius

guidata(hObject,handles);

% --- Executes on button press in button_clearlastinj.
function button_clearlastinj_Callback(hObject, eventdata, handles)
% hObject    handle to button_clearlastinj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global astro_positions neighbor_radius astro_numbers neighbor_neurons astro_count
astro_positions=astro_positions(1:end-1,:);
neighbor_radius=neighbor_radius(1:end-1);
astro_numbers=astro_numbers(1:end-1);
neighbor_neurons=neighbor_neurons(1:end-1);
astro_count = astro_count-1;

set(handles.text_astronumber, 'String', 'NaN');
set(handles.text_astrocount, 'String', num2str(astro_count));
set(handles.text_astronumbers, 'String', num2str(astro_numbers));
set(handles.text_astronumber, 'String', 'NaN');

imshow(handles.Iseg,'Parent',handles.axes_segmentation); 
set(handles.axes_segmentation,'XTickLabel',[]);
set(handles.axes_segmentation,'YTickLabel',[])

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function text_astrocount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_astrocount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function text_astronumbers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_astrocount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function text_radius_Callback(hObject, eventdata, handles)
% hObject    handle to text_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of text_radius as text
%        str2double(get(hObject,'String')) returns contents of text_radius as a double
handles.radius=str2num(handles.text_radius.String);
global neighbor_radius astro_count astro_positions L
neighbor_radius(astro_count)=handles.radius;

%find neurons within injury radius using the UPDATED radius value
global neurons_inradius neighbor_neurons
y_min=max([0 astro_positions(astro_count,1)-neighbor_radius]);
y_max=min([astro_positions(astro_count,1)+neighbor_radius size(L,2)]);
x_min=max([0 astro_positions(astro_count,2)-neighbor_radius]);
x_max=min([astro_positions(astro_count,2)+neighbor_radius size(L,1)]);
L_restricted=L(x_min:x_max,y_min:y_max);                    %look within area defined by radius    
neurons_inradius=unique(L_restricted);                      %find all unique values (neuron #) in restricted segmentation file
neighbor_neurons{astro_count}=neurons_inradius(~(~neurons_inradius));    %eliminate 0 from the list

clear y_min y_max x_min x_max neurons_inradius

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
global astro_count astro_positions

imshow(handles.Iseg,'Parent',handles.axes_segmentation); 
set(handles.axes_segmentation,'XTickLabel',[]);
set(handles.axes_segmentation,'YTickLabel',[])

hold(handles.axes_segmentation,'on');
plot(handles.axes_segmentation,astro_positions(astro_count,1),astro_positions(astro_count,2),'r*','MarkerSize', 4);
plot(handles.axes_segmentation,astro_positions(astro_count,1),astro_positions(astro_count,2),'ro','MarkerSize', handles.radius);
hold(handles.axes_segmentation,'off');

guidata(hObject,handles);


% --- Executes on button press in button_save.
function save_alldata(handles)

filename_analysis=[handles.foldername filesep 'processed_analysis.mat'];
load(filename_analysis);

global astrodata astro_positions neighbor_radius astro_numbers neighbor_neurons

[astro_numbers,ia] = unique(astro_numbers);
if astro_numbers(1) == 0 
    astro_numbers = astro_numbers(2:end);
end 
astrodata.astro_count=length(astro_numbers);
astrodata.astro_positions=astro_positions(ia,:);
astrodata.neighbor_radius=neighbor_radius(ia);
astrodata.astro_numbers=astro_numbers;
astrodata.neighbor_neurons=neighbor_neurons(ia);

for cindex=1:length(analysis)
    %save astrocyte numbers as astrocytes
    analysis(cindex).neuroastro.astrocytes=astro_numbers;
    neuron_indices = 1:size(analysis(cindex).F_cell,1);%create a vector with indices for neurons
    %create a holder matrix for neurons that are not astrocytes - later
    %separate neighboring neurons from others
    holder=setdiff(neuron_indices,astro_numbers);
    if ~isempty(neighbor_neurons(ia))
        %actual neighboring neurons are those that are not also astrocytes
        nn_mat=cell2mat(neighbor_neurons(ia)');
        neighbor_neurons_actual = setdiff(nn_mat,astro_numbers);
    end
    if ~isempty(neighbor_neurons_actual)
        %save indices of neighboring neurons
        analysis(cindex).neuroastro.neighbor_neurons=neighbor_neurons_actual;
        %save true neuron indices as difference between all indices and astro indices
        analysis(cindex).neuroastro.other_neurons=setdiff(holder,neighbor_neurons_actual);
    end 
end

if ~exist([handles.foldername filesep 'astrodata'], 'dir')
 mkdir([handles.foldername filesep 'astrodata']);
end

%disp('Saving data');
save([handles.foldername filesep 'astrodata' filesep 'astrodata.mat'],'astrodata');
save([handles.foldername filesep 'processed_analysis_astro.mat'],'analysis');


function text_astronumber_Callback(hObject, eventdata, handles)
% hObject    handle to text_astronumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_astronumber as text
%        str2double(get(hObject,'String')) returns contents of text_astronumber as a double
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function text_astronumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_astronumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function text_astronumbers_Callback(hObject, eventdata, handles)
guidata(hObject,handles);

% --- Executes on button press in save button.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

save_alldata(handles);
guidata(hObject,handles);
