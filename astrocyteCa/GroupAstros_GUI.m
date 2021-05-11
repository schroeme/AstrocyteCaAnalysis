function varargout = GroupAstros_GUI(varargin)
% GROUPASTROS_GUI MATLAB code for GroupAstros_GUI.fig
%      GROUPASTROS_GUI, by itself, creates a new GROUPASTROS_GUI or raises the existing
%      singleton*.
%
%      H = GROUPASTROS_GUI returns the handle to a new GROUPASTROS_GUI or the handle to
%      the existing singleton*.
%
%      GROUPASTROS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GROUPASTROS_GUI.M with the given input arguments.
%
%      GROUPASTROS_GUI('Property','Value',...) creates a new GROUPASTROS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GroupAstros_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GroupAstros_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GroupAstros_GUI

% Last Modified by GUIDE v2.5 20-Feb-2019 12:19:15

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GroupAstros_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GroupAstros_GUI_OutputFcn, ...
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

% --- Executes just before GroupAstros_GUI is made visible.
function GroupAstros_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GroupAstros_GUI (see VARARGIN)

% Choose default command line output for GroupAstros_GUI
handles.output = hObject;

handles.files=[];
handles.total_grouped_astros=0;

global astro_group grouped_astro_count;
astro_group = [];
grouped_astro_count = 0;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes GroupAstros_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GroupAstros_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in load_folder_pushbutton.
function load_folder_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to load_folder_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = 'Enter folder path ';
global folderpath
folderpath = input(prompt);
handles.foldername=folderpath;

%Load processed analysis file to grab numbered segmentation file
global L
filename_analysis=[handles.foldername filesep 'processed_analysis_astrocheck_spikech_actfilt.mat'];
load(filename_analysis);
L=analysis(1).L; 
handles.L=L;
astrocytes = analysis(1).neuroastro.astrocytes;
toplot = ismember(analysis(1).L, astrocytes);

imshow(toplot,'Parent',handles.segmentation); 
set(handles.segmentation,'XTickLabel',[]);
set(handles.segmentation,'YTickLabel',[])

guidata(hObject,handles);

% --- Executes on button press in group_astros.
function group_astros_Callback(hObject, eventdata, handles)
% hObject    handle to group_astros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%update displayed variables
global grouped_astro_count

segment_positions = [];

grouped_astro_count = grouped_astro_count + 1

%mark injury position
button = 1;
segment_count = 0;
 while sum(button) <=1   % read ginputs until a mouse right-button occurs
   segment_count = segment_count + 1; %increment by one
   [segment_positions(segment_count,1), segment_positions(segment_count,2),button] = myginput(1, 'arrow');
   hold(handles.segmentation,'on');
   plot(handles.segmentation,segment_positions(segment_count,1),segment_positions(segment_count,2),'r*','MarkerSize', 4);
 end
hold(handles.segmentation,'off');

%find astro number at injury site
global L astro_group

for sindex = 1:length(segment_positions) %loop through all segments
    segment_IDs(sindex,1) = L(floor(segment_positions(sindex,2)), floor(segment_positions(sindex,1))); %get the segment number
end

[unique_segments,ia] = unique(segment_IDs); %eliminate repeats
if unique_segments(1) == 0  %eliminate zeros
    unique_segments = unique_segments(2:end)';
end

astro_group_temp(:,1) = unique_segments
astro_group_temp(1:length(unique_segments),2) = grouped_astro_count %get the astro number

astro_group = [astro_group; astro_group_temp]; %add this on

guidata(hObject,handles);

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

afile=[handles.foldername filesep 'processed_analysis_astrocheck_spikech_actfilt.mat'];
astrofile=[handles.foldername filesep 'astrodata' filesep 'astrodata.mat'];
load(afile);
load(astrofile);

global grouped_astro_count astro_group

astrodata.grouped_astro_count = grouped_astro_count;
astrodata.astro_group = astro_group;

for cindex=1:length(analysis)
    %save astrocyte numbers as astrocytes
    analysis(cindex).neuroastro.grouped_astro_count = grouped_astro_count;
    analysis(cindex).neuroastro.astro_group = astro_group;
    
end

disp('Saving data');
save([handles.foldername filesep 'astrodata' filesep 'astrodata.mat'],'astrodata');
save([handles.foldername filesep 'processed_analysis_astrocheck_spikech_actfilt.mat'],'analysis');
