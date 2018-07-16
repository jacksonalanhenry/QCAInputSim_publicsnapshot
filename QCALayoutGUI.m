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

% Last Modified by GUIDE v2.5 16-Jul-2018 10:56:21

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


myCircuit = QCACircuit();
myCircuit.CircuitDraw(gca);
RightClickThings();

SignalsList = {};

setappdata(gcf,'SignalsList',SignalsList);
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



function editText_Callback(hObject, eventdata, handles)
% hObject    handle to editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText as text
%        str2double(get(hObject,'String')) returns contents of editText as a double



%may be depreciated
% --- Executes during object creation, after setting all properties.
function editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    empty - handlesButton not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%may be depreciated
% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)


%may be depreciated
% --------------------------------------------------------------------
function SaveCircuit_Callback(hObject, eventdata, handles)
% hObject    handle to SaveCircuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)




% --------------------------------------------------------------------
function SaveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
SaveCircuit(handles);

% --------------------------------------------------------------------
function OpenMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
LoadCircuit(handles);



% --------------------------------------------------------------------
function NewMenu_Callback(hObject, eventdata, handles)
% hObject    handle to NewMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
NewCircuit(handles);




function chngPol_Callback(hObject, eventdata, handles)
% hObject    handle to chngPol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chngPol as text
%        str2double(get(hObject,'String')) returns contents of chngPol as a double
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
MakeSuperCellGUI();


% --- Executes on button press in disbandsupercell.
function disbandsupercell_Callback(hObject, eventdata, handles)
% hObject    handle to disbandsupercell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
DisbandSuperCell();


%may be depreciated
% --- Executes on button press in simbutton.
function simbutton_Callback(hObject, eventdata, handles)
% hObject    handle to simbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
Simulate(handles);


% --- Executes on button press in removeNode.
function removeNode_Callback(hObject, eventdata, handles)
% hObject    handle to removeNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
RemoveNode();


% --- Executes on button press in addDriver.
function addDriver_Callback(hObject, eventdata, handles)
% hObject    handle to addDriver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
QCALayoutAddDriver();


% --- Executes on button press in add5Cells.
function add5Cells_Callback(hObject, eventdata, handles)
% hObject    handle to add5Cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
% Add5Cells(handlesButton);
for i=1:5 
    QCALayoutAddNode();
end


% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
ResetCells();



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
AutoSnap(handles);


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

%for debugging
myCircuit = getappdata(gcf,'myCircuit');

f=gcf;
f.Pointer = 'arrow';

myCircuit = myCircuit.CircuitDraw(gca);

setappdata(gcf,'myCircuit',myCircuit);




% --- Executes on button press in circuitPanel.
function circuitPanel_Callback(hObject, eventdata, handles)
% hObject    handle to circuitPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of circuitPanel
% PanelSwitch(handlesButton);

MajorPanelSwitch(handles,'circuit');


    
% --- Executes on button press in signalPanel.
function signalPanel_Callback(hObject, eventdata, handles)
% hObject    handle to signalPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of signalPanel
% PanelSwitch(handlesButton);

MajorPanelSwitch(handles,'signal');


    

% --- Executes on button press in simulatePanel.
function simulatePanel_Callback(hObject, eventdata, handles)
% hObject    handle to simulatePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of simulatePanel   

MajorPanelSwitch(handles,'simulate');



    
function changeWave_Callback(hObject, eventdata, handles)
% hObject    handle to changeWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeWave as text
%        str2double(get(hObject,'String')) returns contents of changeWave as a double


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


function changePhase_Callback(hObject, eventdata, handles)
% hObject    handle to changePhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changePhase as text
%        str2double(get(hObject,'String')) returns contents of changePhase as a double



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





% --- Executes on selection change in signalType.
function signalType_Callback(hObject, eventdata, handles)
% hObject    handle to signalType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signalType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signalType
SignalTypePanelSwitch(handles);


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
CreateSignal(handles);



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

DeleteSignal(handles);



% --- Executes on button press in saveSignal.
function saveSignal_Callback(hObject, eventdata, handles)
% hObject    handle to saveSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
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

%MAKE THIS A HOTKEY.M FUNCTION
HotKeysFuncList(handles,eventdata);




% --- Executes on button press in drawElectrode.
function drawElectrode_Callback(hObject, eventdata, handles)
% hObject    handle to drawElectrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
ElectrodeDrawer(handles);



% --- Executes on button press in eraseElectrodes.
function eraseElectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to eraseElectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

ElectrodeEraser(handles);


% --- Executes on button press in clearAll.
function clearAll_Callback(hObject, eventdata, handles)
% hObject    handle to clearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

ClearAll(handles);



% --- Executes on button press in createSimulation.
function createSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to createSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
f=gcf;
% f.Pointer = 'watch';
CreateSimulationFile(handles);
f.Pointer = 'arrow';


% --- Executes on button press in visualizeSim.
function visualizeSim_Callback(hObject, eventdata, handles)
% hObject    handle to visualizeSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
f=gcf;
% f.Pointer = 'watch';
GenerateSimulationVideo(handles);
f.Pointer = 'arrow';

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
handles
gca;



% --- Executes on button press in getAppInfo.
function getAppInfo_Callback(hObject, eventdata, handles)
% hObject    handle to getAppInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
AppInfo = getappdata(gcf)
circuit = AppInfo.myCircuit
signals = AppInfo.SignalsList



function changeWaveFermi_Callback(hObject, eventdata, handles)
% hObject    handle to changeWaveFermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeWaveFermi as text
%        str2double(get(hObject,'String')) returns contents of changeWaveFermi as a double


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


% --- Executes on button press in abortButton.
function abortButton_Callback(hObject, eventdata, handles)
% hObject    handle to abortButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% AbortSimulation();
