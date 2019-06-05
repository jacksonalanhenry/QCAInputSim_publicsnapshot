function varargout = QCALayoutGUI(varargin)
% QCALAYOUTGUI MATLAB code for QCALayoutGUI.fig
%      QCALAYOUTGUI, by itself, creates a new QCALAYOUTGUI or raises the existing
%      singleton*.
%
%      H = QCALAYOUTGUI returns the handle to a new QCALAYOUTGUI or the handle to
%      the existing singleton*.
%
%      QCALAYOUTGUI('CALLBACK',hObject,eventData,handlesButton,...) calls the local
%      function named CALLBACK in QCALAYOUTGUI.M with the given input arguments.
%
%      QCALAYOUTGUI('Property','Value',...) creates a new QCALAYOUTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QCALayoutGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QCALayoutGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QCALayoutGUI

% Last Modified by GUIDE v2.5 22-May-2019 12:13:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QCALayoutGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @QCALayoutGUI_OutputFcn, ...
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


% --- Executes just before QCALayoutGUI is made visible.
function QCALayoutGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
% varargin   command line arguments to QCALayoutGUI (see VARARGIN)

% Choose default command line output for QCALayoutGUI
handles.output = hObject;

% Update handlesButton structure
guidata(hObject, handles)

% set(handlesButton.figure1,'Name','QCA Layout Demo');
axes(handles.MainAxes);

myCircuit = QCACircuit();
myCircuit.CircuitDraw(gca);
RightClickThings();
nodeTypepopupmenu_Callback(hObject, eventdata, handles);


clockSignalsList = {};
inputSignalsList = {};


setappdata(gcf,'clockSignalsList',clockSignalsList);
setappdata(gcf,'inputSignalsList',inputSignalsList);

setappdata(gcf, 'myCircuit', myCircuit);
Path.home = pwd;

Path.circ = './Circuits folder';

setappdata(gcf,'Path',Path);





% UIWAIT makes QCALayoutGUI wait for user response (see UIRESUME)
% uiwait(handlesButton.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = QCALayoutGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Get default command line output from handlesButton structure
varargout{1} = handles.output;


% --- Executes on button press in addNodeButton.
function addNodeButton_Callback(hObject, eventdata, handles)
% hObject    handle to addNodeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% add a new node
QCALayoutAddNode();




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);

% --------------------------------------------------------------------
function FileMenus_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------


function SaveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%saving both the circuit and the signal to a .mat file
SaveCircuit();

% --------------------------------------------------------------------
function OpenMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%open a previously made circuit
LoadCircuit(handles);



% --------------------------------------------------------------------
function NewMenu_Callback(hObject, eventdata, handles)
% hObject    handle to NewMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%get rid of the current circuit and clear its data from the appdata
NewCircuit(handles);




function chngPol_Callback(hObject, eventdata, handles)
% hObject    handle to chngPol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chngPol as text
%        str2double(get(hObject,'String')) returns contents of chngPol as a double

%change the polarization of any driver cell(s)
ChangePol(handles);



% --- Executes during object creation, after setting all properties.
function chngPol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chngPol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in makeSC.
function makeSC_Callback(hObject, eventdata, handles)
% hObject    handle to makeSC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of makeSC

%make the group of selected cells a supercell. Drivers cannot be in
%supercells
MakeSuperCellGUI();


% --- Executes on button press in disbandsupercell.
function disbandsupercell_Callback(hObject, eventdata, handles)
% hObject    handle to disbandsupercell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%if any member of a supercell is selected, the SC can be disbanded
DisbandSuperCell();


%may be depreciated
% --- Executes on button press in simbutton.
function simbutton_Callback(hObject, eventdata, handles)
% hObject    handle to simbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%currently the simulate button, but it may be deleted later since it it not
%the same as the simulation panel functionality
Simulate(handles);


% --- Executes on button press in removeNode.
function removeNode_Callback(hObject, eventdata, handles)
% hObject    handle to removeNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%Remove the node or nodes selected
RemoveNode();


% --- Executes on button press in addDriver.
function addDriver_Callback(hObject, eventdata, handles)
% hObject    handle to addDriver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%add a driver to the circuit and axis
QCALayoutAddDriver();


% --- Executes on button press in add5Cells.
function add5Cells_Callback(hObject, eventdata, handles)
% hObject    handle to add5Cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
% Add5Cells(handlesButton);

%add 5 nodes instead of just 1 (we could desire certain shapes of
%additions, something to think about)
for i=1:5 
    QCALayoutAddNode();
end

% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%set all nodes to a polarization of 0
ResetCells();


%OBSOLETE
function chngClock_Callback(hObject, eventdata, handles)
% hObject    handle to chngClock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chngClock as text
%        str2double(get(hObject,'String')) returns contents of chngClock as a double
ChangeClockField(handles);

% --- Executes during object creation, after setting all properties.
function chngClock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chngClock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in autoSnap.
function autoSnap_Callback(hObject, eventdata, handles)
% hObject    handle to autoSnap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoSnap

%this is the switch function for turning snap2grid functionality on and off
AutoSnap(handles);


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%for debugging, we redraw the circuit
myCircuit = getappdata(gcf,'myCircuit');

% f=gcf;
% f.Pointer = 'arrow';

myCircuit = myCircuit.CircuitDraw(0,gca);

setappdata(gcf,'myCircuit',myCircuit);




% --- Executes on button press in circuitPanel.
function circuitPanel_Callback(hObject, eventdata, handles)
% hObject    handle to circuitPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of circuitPanel
% PanelSwitch(handlesButton);

%switching between the three main panels (circuit, signal, simulation)
%MajorPanelSwitch(handles,'circuit');


    
% --- Executes on button press in signalPanel.
function signalPanel_Callback(hObject, eventdata, handles)
% hObject    handle to signalPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of signalPanel
% PanelSwitch(handlesButton);

%switching between the three main panels (circuit, signal, simulation)
%MajorPanelSwitch(handles,'signal');


    

% --- Executes on button press in simulatePanel.
function simulatePanel_Callback(hObject, eventdata, handles)
% hObject    handle to simulatePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of simulatePanel   

%switching between the three main panels (circuit, signal, simulation)
%MajorPanelSwitch(handles,'simulate');



    
function changeWave_Callback(hObject, eventdata, handles)
% hObject    handle to changeWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeWave as text
%        str2double(get(hObject,'String')) returns contents of changeWave as a double
RePlotSignal(handles)

% --- Executes during object creation, after setting all properties.
function changeWave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function changeAmp_Callback(hObject, eventdata, handles)
% hObject    handle to changeAmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeAmp as text
%        str2double(get(hObject,'String')) returns contents of changeAmp as a double
RePlotSignal(handles)

% --- Executes during object creation, after setting all properties.
function changeAmp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeAmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function changePeriod_Callback(hObject, eventdata, handles)
% hObject    handle to changePeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changePeriod as text
%        str2double(get(hObject,'String')) returns contents of changePeriod as a double
RePlotSignal(handles)

function changePhase_Callback(hObject, eventdata, handles)
% hObject    handle to changePhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changePhase as text
%        str2double(get(hObject,'String')) returns contents of changePhase as a double
RePlotSignal(handles)


% --- Executes during object creation, after setting all properties.
function changePhase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changePhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function changeMeanValue_Callback(hObject, eventdata, handles)
% hObject    handle to changeMeanValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeMeanValue as text
%        str2double(get(hObject,'String')) returns contents of changeMeanValue as a double


% --- Executes during object creation, after setting all properties.
function changeMeanValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeMeanValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in signalType.
function signalType_Callback(hObject, eventdata, handles)
% hObject    handle to signalType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signalType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signalType

%switch between the different signal type panels within the major signal
%panel

signalTypes = cellstr(get(handles.signalType,'String')); %get the list of signal types from handles

sigType = signalTypes{get(handles.signalType,'Value')}; %find which one is selected

SignalTypePanelSwitch(handles, sigType);

if ~isempty(handles.signalEditor.String) %changing the signal type and replotting if a signal is being edited
    clockSignalsList = getappdata(gcf,'clockSignalsList');
    
    for i=1:length(clockSignalsList)
        if strcmp(clockSignalsList{i}.Name,handles.signalEditor.String)
            clockSignalsList{i}.Type = sigType;
        end
    end
    setappdata(gcf,'clockSignalsList',clockSignalsList);
    
    RePlotSignal(handles);
end





% --- Executes during object creation, after setting all properties.
function signalType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function changePeriod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changePeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in createSignal.
function createSignal_Callback(hObject, eventdata, handles)
% hObject    handle to createSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%create a signal of a designated type
CreateSignal(handles, 'clockSignal');



function signalName_Callback(hObject, eventdata, handles)
% hObject    handle to signalName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of signalName as text
%        str2double(get(hObject,'String')) returns contents of signalName as a double


% --- Executes during object creation, after setting all properties.
function signalName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in signalList.
%THIS IS THE MENU LIST THAT HOLDS ALL THE SIGNALS
function signalList_Callback(hObject, eventdata, handles)
% hObject    handle to signalList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signalList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signalList

%attain signal properties by selecting that signal in the gui listbox

GetSignalPropsGUI(handles);



% --- Executes during object creation, after setting all properties.
function signalList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in deleteSignal.
function deleteSignal_Callback(hObject, eventdata, handles)
% hObject    handle to deleteSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%Delete a signal from the gui listbox and from the appdata
DeleteSignal(handles);



% --- Executes on button press in saveSignal.
function saveSignal_Callback(hObject, eventdata, handles)
% hObject    handle to saveSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%save the current signal that is being edited
SaveEditedSignal(handles);



% --- Executes on selection change in transitionType.
function transitionType_Callback(hObject, eventdata, handles)
% hObject    handle to transitionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns transitionType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from transitionType




% --- Executes during object creation, after setting all properties.
function transitionType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transitionType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function changeInputField_Callback(hObject, eventdata, handles)
% hObject    handle to changeInputField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeInputField as text
%        str2double(get(hObject,'String')) returns contents of changeInputField as a double
ChangeInputField(handles)



% --- Executes during object creation, after setting all properties.
function changeInputField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeInputField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%all the hotkeys are here
eventdata.Key;
eventdata.Modifier;

HotKeysFuncList(handles,eventdata);



function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f=gcf;
f.SelectionType;

Select = f.SelectionType;

ClickFunctionality(handles,eventdata,Select);


% --- Executes on button press in drawElectrode.
function drawElectrode_Callback(hObject, eventdata, handles)
% hObject    handle to drawElectrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%drawing the electrodes
ElectrodeDrawer(handles);



% --- Executes on button press in eraseElectrodes.
function eraseElectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to eraseElectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%erasing the selected electrodes
ElectrodeEraser(handles);


% --- Executes on button press in clearAll.
function clearAll_Callback(hObject, eventdata, handles)
% hObject    handle to clearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%a dialog box opens, if the use selects yes then the figure gets cleared
choosedialog(handles)



% --- Executes on button press in createSimulation.
function createSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to createSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%creating the simulation file that we will make the video from
% f=gcf;
% f.Pointer = 'watch';
CreateSimulationFile(handles);
% f.Pointer = 'arrow';


% --- Executes on button press in visualizeSim.
function visualizeSim_Callback(hObject, eventdata, handles)
% hObject    handle to visualizeSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%calling the pipelinevisualization function to create the mp4 video file
% f=gcf;
% f.Pointer = 'watch';
GenerateSimulationVideo(handles);
% f.Pointer = 'arrow';

function nameSim_Callback(hObject, eventdata, handles)
% hObject    handle to nameSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nameSim as text
%        str2double(get(hObject,'String')) returns contents of nameSim as a double


% --- Executes during object creation, after setting all properties.
function nameSim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in handlesButton.
function handlesButton_Callback(hObject, eventdata, handles)
% hObject    handle to handlesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%attaining the handles, not a necessary function and it will be gone
%eventually
handles
gca;


%WILL DELETE LATER. IT JUST MAKES IT EASIER TO GET DATA
% --- Executes on button press in getAppInfo.
function getAppInfo_Callback(hObject, eventdata, handles)
% hObject    handle to getAppInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%as said above, only getting the app data for debugging purposes
AppInfo = getappdata(gcf)
circuit = AppInfo.myCircuit
signals = AppInfo.clockSignalsList


function changeWaveFermi_Callback(hObject, eventdata, handles)
% hObject    handle to changeWaveFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeWaveFermi as text
%        str2double(get(hObject,'String')) returns contents of changeWaveFermi as a double
RePlotSignal(handles)

% --- Executes during object creation, after setting all properties.
function changeWaveFermi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeWaveFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function changePhaseFermi_Callback(hObject, eventdata, handles)
% hObject    handle to changePhaseFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changePhaseFermi as text
%        str2double(get(hObject,'String')) returns contents of changePhaseFermi as a double
RePlotSignal(handles)

% --- Executes during object creation, after setting all properties.
function changePhaseFermi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changePhaseFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function changeAmpFermi_Callback(hObject, eventdata, handles)
% hObject    handle to changeAmpFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeAmpFermi as text
%        str2double(get(hObject,'String')) returns contents of changeAmpFermi as a double
RePlotSignal(handles)

% --- Executes during object creation, after setting all properties.
function changeAmpFermi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeAmpFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function changePeriodFermi_Callback(hObject, eventdata, handles)
% hObject    handle to changePeriodFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changePeriodFermi as text
%        str2double(get(hObject,'String')) returns contents of changePeriodFermi as a double
RePlotSignal(handles)

% --- Executes during object creation, after setting all properties.
function changePeriodFermi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changePeriodFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function changeMeanValueFermi_Callback(hObject, eventdata, handles)
% hObject    handle to changeMeanValueFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeMeanValueFermi as text
%        str2double(get(hObject,'String')) returns contents of changeMeanValueFermi as a double
RePlotSignal(handles)

% --- Executes during object creation, after setting all properties.
function changeMeanValueFermi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeMeanValueFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function changeSharpnessFermi_Callback(hObject, eventdata, handles)
% hObject    handle to changeSharpnessFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeSharpnessFermi as text
%        str2double(get(hObject,'String')) returns contents of changeSharpnessFermi as a double
RePlotSignal(handles)

% --- Executes during object creation, after setting all properties.
function changeSharpnessFermi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeSharpnessFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in helpButton.
function helpButton_Callback(hObject, eventdata, handles)
% hObject    handle to helpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
help QCAHelp
QCAHelp()


% --- Executes on selection change in nodeTypepopupmenu.
function nodeTypepopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to nodeTypepopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nodeTypepopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nodeTypepopupmenu
nodeTypes = cellstr(get(handles.nodeTypepopupmenu,'String')); %get the list of signal types from handles
nodeType = nodeTypes{get(handles.nodeTypepopupmenu,'Value')}; %find which one is selected

setappdata(gcf,'nodeType', nodeType);


% --- Executes during object creation, after setting all properties.
function nodeTypepopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nodeTypepopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadSimResults.
function loadSimResults_Callback(hObject, eventdata, handles)
% hObject    handle to loadSimResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadSimResults();


% --- Executes on button press in vizAtCertainTimeButton.
function vizAtCertainTimeButton_Callback(hObject, eventdata, handles)
% hObject    handle to vizAtCertainTimeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vizAtCertainTimeButton(handles);
DragDrop();

function vizAtCertainTimeEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to vizAtCertainTimeEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vizAtCertainTimeEditBox as text
%        str2double(get(hObject,'String')) returns contents of vizAtCertainTimeEditBox as a double

    

% --- Executes during object creation, after setting all properties.
function vizAtCertainTimeEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vizAtCertainTimeEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberOfTimeSteps_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfTimeSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfTimeSteps as text
%        str2double(get(hObject,'String')) returns contents of numberOfTimeSteps as a double



% --- Executes during object creation, after setting all properties.
function numberOfTimeSteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfTimeSteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberOfPeriods_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfPeriods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfPeriods as text
%        str2double(get(hObject,'String')) returns contents of numberOfPeriods as a double


% --- Executes during object creation, after setting all properties.
function numberOfPeriods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfPeriods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in inputSignalList.
function inputSignalList_Callback(hObject, eventdata, handles)
% hObject    handle to inputSignalList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns inputSignalList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputSignalList


% --- Executes during object creation, after setting all properties.
function inputSignalList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputSignalList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inputSignalButton.
function inputSignalButton_Callback(hObject, eventdata, handles)
% hObject    handle to inputSignalButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CreateSignal(handles, 'inputSignal');


% --- Executes on button press in circuit_energy_button.
function circuit_energy_button_Callback(hObject, eventdata, handles)
% hObject    handle to circuit_energy_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CalculateEnergyCallback(handles);


% --- Executes on button press in flip_pol_button.
function flip_pol_button_Callback(hObject, eventdata, handles)
% hObject    handle to flip_pol_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FlipPol(handles);


% --- Executes on button press in Relax_button.
function Relax_button_Callback(hObject, eventdata, handles)
% hObject    handle to Relax_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Simulate(handles);



