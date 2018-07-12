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

% Last Modified by GUIDE v2.5 12-Jul-2018 10:02:28

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
QCALayoutAddNode();


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

myCircuit = myCircuit.CircuitDraw(gca);

setappdata(gcf,'myCircuit',myCircuit);




% --- Executes on button press in circuitPanel.
function circuitPanel_Callback(hObject, eventdata, handles)
% hObject    handle to circuitPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of circuitPanel
% PanelSwitch(handlesButton);
    handles.signalPanel.Value = 0;
    handles.signalButtonGroup.Visible = 'off';
    
    handles.circuitPanel.Value = 1;
    handles.circuitButtonGroup.Visible = 'on';
    
    handles.simulatePanel.Value = 0;
    handles.simulateButtonGroup.Visible = 'off';

    
% --- Executes on button press in signalPanel.
function signalPanel_Callback(hObject, eventdata, handles)
% hObject    handle to signalPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of signalPanel
% PanelSwitch(handlesButton);
    handles.signalPanel.Value = 1;
    handles.signalButtonGroup.Visible = 'on';
    
    handles.circuitPanel.Value = 0;
    handles.circuitButtonGroup.Visible = 'off';
    
    handles.simulatePanel.Value = 0;
    handles.simulateButtonGroup.Visible = 'off';
    

% --- Executes on button press in simulatePanel.
function simulatePanel_Callback(hObject, eventdata, handles)
% hObject    handle to simulatePanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of simulatePanel    
    handles.signalPanel.Value = 0;
    handles.signalButtonGroup.Visible = 'off';
    
    handles.circuitPanel.Value = 0;
    handles.circuitButtonGroup.Visible = 'off';
    
    handles.simulatePanel.Value = 1;
    handles.simulateButtonGroup.Visible = 'on';

    
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


signalTypes = cellstr(get(handles.signalType,'String'));

sigType = signalTypes{get(handles.signalType,'Value')};



switch sigType
    
    case 'Sinusoidal'
        
        handles.sinusoidPanel.Visible = 'on';
        handles.customSignal.Visible = 'off';
        handles.electrodePanel.Visible = 'off';
    
    case 'Fermi'
            
        
    case 'Custom'
        handles.sinusoidPanel.Visible = 'off';
        handles.customSignal.Visible = 'on';
        handles.electrodePanel.Visible = 'off';
    
    case 'Electrode'
        handles.sinusoidPanel.Visible = 'off';
        handles.customSignal.Visible = 'off';
        handles.electrodePanel.Visible = 'on';
        
    
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

SignalsList = getappdata(gcf,'SignalsList');

contents = cellstr(get(handles.signalType,'String')); 
sigType = contents{get(handles.signalType,'Value')} ;


transitions = cellstr(get(handles.transitionType,'String')); 
transType = transitions{get(handles.transitionType,'Value')};



% sigType = handlesButton.signalType.String;
mySignal = Signal();

switch sigType
    case 'Sinusoidal'
        mySignal.Amplitude = str2num(handles.changeAmp.String);
        mySignal.Wavelength = str2num(handles.changeWave.String);
        mySignal.Period = str2num(handles.changePeriod.String);
        mySignal.Phase = str2num(handles.changePhase.String);
        mySignal.Type = sigType;
        
    case 'Fermi'
        mySignal.Amplitude = str2num(handles.changeAmp.String);
        %mySignal.Sharpness = str2num(handles.changeSharp.String);
        mySignal.Period = str2num(handles.changePeriod.String);
        mySignal.Phase = str2num(handles.changePhase.String);
        %mySignal.MeanValue = str2num(handles.changeMV.String);
        mySignal.Type = sigType;
        
    case 'Custom'
        
        
        
        transType;
        mySignal.Type = sigType;
        
    case 'Electrode'
        mySignal.Type = sigType;
        mySignal.InputField = str2num(handles.changeInputField.String);
end



if ~isempty(handles.signalName.String)
    mySignal.Name = handles.signalName.String;
    
    handles.signalList.String{end+1,1} = handles.signalName.String;
    SignalsList{end+1} = mySignal;
    
    setappdata(gcf,'SignalsList',SignalsList);
    handles.signalName.String = 'Input Name';
    handles.signalName.Value = 1;
end


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
contents = cellstr(get(handles.signalList,'String'));


if ~isempty(contents)
    sigName = contents{get(handles.signalList,'Value')};
    
    SignalsList = getappdata(gcf,'SignalsList');
    
    if ~isempty(SignalsList)
        for i=1:length(SignalsList)
            SignalsList{i}.Name;
            if strcmp(sigName,SignalsList{i}.Name)
                mySignal = SignalsList{i};
                pick = i;
            end
        end
        
        
        handles.signalEditor.String = sigName;
        handles.signalEditType.String = mySignal.Type;
        
        switch mySignal.Type
            
            case 'Sinusoidal'
                
                handles.changeAmp.String = num2str(mySignal.Amplitude);
                handles.changeWave.String = num2str(mySignal.Wavelength);
                handles.changePeriod.String = num2str(mySignal.Period);
                handles.changePhase.String = num2str(mySignal.Phase);
                
            case 'Fermi'
                handles.changeAmp.String = num2str(mySignal.Amplitude);
                %handles.changeSharp.String= num2str(mySignal.Sharpness);
                handles.changePeriod.String = num2str(mySignal.Period);
                handles.changePhase.String = num2str(mySignal.Phase);
                %handles.changeMV.String = num2str(mySignal.MeanValue);
                
                
            case 'Custom'
                %nothing yet
                
            case 'Electrode'
                handles.changeInputField.String = num2str(mySignal.InputField);
                
        end
        SignalsList{pick} = mySignal;
        
        
        setappdata(gcf,'SignalsList',SignalsList);
    end
end





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

contents = cellstr(get(handles.signalList,'String'));

SignalsList = getappdata(gcf,'SignalsList');

if ~isempty(contents)
   
    handles.signalEditor.String = '';
    handles.signalEditType.String = '';
    
    sigName = contents{get(handles.signalList,'Value')};
   
    newSigs = {};
    contents = {};
    
    delete = handles.signalList.Value;
    
    SignalsList{delete} = {};
    
    
    
    for i=1:length(SignalsList)
                if ~isempty(SignalsList{i})               
        
                    newSigs{end+1} = SignalsList{i};
                    contents{end+1,1} = SignalsList{i}.Name;
                end
    end
   
   handles.signalList.String = contents;
   
   SignalsList = newSigs;
   handles.signalList.Value = 1;

    
  handles.signalName.String = 'Input Name';
   
    setappdata(gcf,'SignalsList',SignalsList);
    
end





% --- Executes on button press in saveSignal.
function saveSignal_Callback(hObject, eventdata, handles)
% hObject    handle to saveSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
contents = cellstr(get(handles.signalList,'String'));

SignalsList = getappdata(gcf,'SignalsList');
myCircuit = getappdata(gcf,'myCircuit');

if ~isempty(contents)
    sigName = contents{get(handles.signalList,'Value')};
    
        for i=1:length(SignalsList)
            if strcmp(sigName,SignalsList{i}.Name)
                mySignal = SignalsList{i};
                pick = i;
            end
        end       
    
    if ~isempty(mySignal)
        sigType = mySignal.Type;
        
        handles.signalEditor.String = '';
        handles.signalEditType.String = '';
        
        
        switch sigType
            
            case 'Sinusoidal'
                
                mySignal.Amplitude = str2num(handles.changeAmp.String);
                mySignal.Wavelength = str2num(handles.changeWave.String);
                mySignal.Period = str2num(handles.changePeriod.String);
                mySignal.Phase = str2num(handles.changePhase.String);
                %mySignal.MeanValue = str2num(handles.changeMV.String);
                
                
                
            case 'Custom'
                
            case 'Fermi'
                mySignal.Amplitude = str2num(handles.changeAmp.String);
                %mySignal.Sharpness = str2num(handles.changeSharp.String);
                mySignal.Period = str2num(handles.changePeriod.String);
                mySignal.Phase = str2num(handles.changePhase.String);
                %mySignal.MeanValue = str2num(handles.changeMV.String);
                
            case 'Electrode'
                mySignal.InputField = str2num(handles.changeInputField.String);
        end
        SignalsList{pick} = mySignal;
        setappdata(gcf,'SignalsList',SignalsList);
        myCircuit = myCircuit.CircuitDraw(gca);
        setappdata(gcf,'myCircuit',myCircuit);
        
        
        
        handles.signalName.String = 'Input Name';
    end
end


% --- Executes on button press in plotSignal.
function plotSignal_Callback(hObject, eventdata, handles)
% hObject    handle to plotSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
contents = cellstr(get(handles.signalList,'String'));

SignalsList = getappdata(gcf,'SignalsList');

if ~isempty(contents)
    sigName = contents{get(handles.signalList,'Value')};
    
    for i=1:length(SignalsList)
        if strcmp(sigName,SignalsList{i}.Name)
            mySignal = SignalsList{i};
            pick = i;
        end
    end
    
    if ~isempty(mySignal)
        sigType = mySignal.Type;
        
        handles.signalEditor.String = sigName;
        
        switch sigType
            
            case 'Sinusoidal'
                
                A = str2num(handles.changeAmp.String);
                L = str2num(handles.changeWave.String);
                T = str2num(handles.changePeriod.String);
                b = str2num(handles.changePhase.String);
                x=-5:.01:5;
                
                
                y = ( cos((2*pi*(x/L - 1/T) )+ b) )*A;
                
                plot(handles.plotAxes,x,y);
                handles.signalDisplayBox.String = sigName;
                
            case 'Fermi'
                
            case 'Custom'
                
                
            case 'Electrode'
                %we don't plot electrodes
                
        end
        SignalsList{pick} = mySignal;
        
        setappdata(gcf,'SignalsList',SignalsList);
    end


    
end



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

eventdata.Key;

if ~isempty(eventdata.Modifier)
    
    if strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'h')
        
        AlignHoriz();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'u')%align vertical
        AlignVert();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'m') %make a supercell
        MakeSuperCellGUI();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'f') %add a node
        QCALayoutAddNode();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'d')%add a driver
        QCALayoutAddDriver();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'b')%drag and expand box to select cells (must go over the middle)
        RectangleSelect();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'l')%disband super cell
        DisbandSuperCell();
        
        
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'g')%turn snapt to grid on and off
        snap = get(handles.autoSnap,'Value');
        
        switch snap
            case 0
                handles.autoSnap.Value = 1;
                
            case 1
                handles.autoSnap.Value = 0;
        end
        AutoSnap(handles);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'e') %reset cells
        ResetCells();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'t')%refresh
        myCircuit = getappdata(gcf,'myCircuit');
        
        myCircuit = myCircuit.CircuitDraw(gca);
        
        setappdata(gcf,'myCircuit',myCircuit);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'a')%select all
        myCircuit = getappdata(gcf,'myCircuit');
        
        if ~isempty(myCircuit.Device)
            for i = 1:length(myCircuit.Device)
                if isa(myCircuit.Device{i},'QCASuperCell')
                    
                    for j=1:length(myCircuit.Device{i}.Device)
                        
                        myCircuit.Device{i}.Device{j}.SelectBox.Selected = 'on';
                        
                        
                    end
                    
                    
                else
                    myCircuit.Device{i}.SelectBox.Selected = 'on';
                    
                end
            end
            
            DragDrop();
            setappdata(gcf,'myCircuit',myCircuit);
        end
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'q')%deselect cells (but it's really just redrawing)
        myCircuit = getappdata(gcf,'myCircuit');
        myCircuit = myCircuit.CircuitDraw(gca);
        
        setappdata(gcf,'myCircuit',myCircuit);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'c')
        CopyCells();
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'v')
        PasteCells();
        
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'n')
        NewCircuit(handles);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'o')
        LoadCircuit(handles);
        
    elseif  strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'s')
        SaveCircuit(handles);
    elseif strcmp(eventdata.Modifier,'control') && (strcmp(eventdata.Key,'delete') || strcmp(eventdata.Key,'backspace'))%remove any selected nodes
        RemoveNode();
        
    elseif strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'comma')
        ChangePol(handles, -1);
        
    elseif strcmp(eventdata.Modifier,'control') && strcmp(eventdata.Key,'period')
        ChangePol(handles, 1);
        
    end
    if   strcmp(eventdata.Modifier,'alt') && strcmp(eventdata.Key,'leftbracket')
        web('https://www.youtube.com/watch?v=TzXXHVhGXTQ');
    end
    
end


% --- Executes on button press in drawElectrode.
function drawElectrode_Callback(hObject, eventdata, handles)
% hObject    handle to drawElectrode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)


SignalsList = getappdata(gcf,'SignalsList');

contents = cellstr(get(handles.signalList,'String'));

if ~isempty(contents)
    sigName = contents{get(handles.signalList,'Value')};
    
    for i=1:length(SignalsList)
        SignalsList{i}.Name;
        SignalsList{i}.Type;
        if strcmp(SignalsList{i}.Name,sigName) && strcmp(SignalsList{i}.Type,'Electrode')
            
            SignalsList{i}.IsDrawn = 'on';
            mySignal = SignalsList{i};
            
            if ~isempty(mySignal.Height)
                mySignal = mySignal.drawElectrode();
                
            else
                [center height width field] = GetBoxTraits(handles);
                mySignal = mySignal.drawElectrode(center ,height ,width ,field);
                
                
                SignalsList{i} = mySignal;
            end
            
        end
        
    end
    
end


setappdata(gcf,'SignalsList',SignalsList);


myCircuit = getappdata(gcf,'myCircuit');
myCircuit = myCircuit.CircuitDraw(gca);



setappdata(gcf,'myCircuit',myCircuit);


% ChangeInputField(handlesButton);




% --- Executes on button press in eraseElectrodes.
function eraseElectrodes_Callback(hObject, eventdata, handles)
% hObject    handle to eraseElectrodes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
SignalsList = getappdata(gcf,'SignalsList');
myCircuit = getappdata(gcf,'myCircuit');


for i=1:length(SignalsList)
    
    if strcmp(SignalsList{i}.TopPatch.Selected,'on') || strcmp(SignalsList{i}.BottomPatch.Selected,'on')
        SignalsList{i}.IsDrawn = 'off';
    end
    
end

setappdata(gcf,'SignalsList',SignalsList);

myCircuit = myCircuit.CircuitDraw(gca);

  

setappdata(gcf,'myCircuit',myCircuit);





% --- Executes on button press in clearAll.
function clearAll_Callback(hObject, eventdata, handles)
% hObject    handle to clearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
f=gcf;

%NEED TO MAKE THIS A GLOBAL FUNCTION OTHERWISE IT CANNOT BE A HOT KEY
%add a dialog box to ask 'r u sure'

a=gca;
myCircuit = getappdata(f,'myCircuit');
SignalsList = getappdata(f,'SignalsList');
cla;%clear the axes

copies = getappdata(f,'Copies');

copies={};

SignalsList = {};
handles.signalList.String = '';
handles.signalList.Value = 1;
handles.signalEditor.String = '' ;
handles.signalEditType.String = '';
handles.signalType.Value = 1;
        handles.sinusoidPanel.Visible = 'on';
        handles.customSignal.Visible = 'off';
        handles.electrodePanel.Visible = 'off';

setappdata(f,'SignalsList',SignalsList);


myCircuit.Device{1}={};%empty first node

myCircuit.Device=myCircuit.Device{1};%the empty first device

myCircuit.Mode = 'Simulation';
myCircuit = myCircuit.CircuitDraw(gca);


setappdata(f,'myCircuit',myCircuit);
setappdata(f,'Copies',copies);





% --- Executes on button press in createSimulation.
function createSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to createSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
myCircuit = getappdata(gcf,'myCircuit');
SignalsList = getappdata(gcf,'SignalsList');
myCircuit = myCircuit.GenerateNeighborList();

name = num2str(handles.nameSim.String);


if length(SignalsList)==1
    if isempty(name)
        myCircuit = myCircuit.pipeline(SignalsList{1});
    else
        myCircuit = myCircuit.pipeline(SignalsList{1},name);
    end
    
elseif length(SignalsList) > 1
    
    
end

myCircuit = myCircuit.CircuitDraw(gca);

setappdata(gcf,'myCircuit',myCircuit);
setappdata(gcf,'SignalsList',SignalsList);



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


% --- Executes on button press in visualizeSim.
function visualizeSim_Callback(hObject, eventdata, handles)
% hObject    handle to visualizeSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
[Sim path]= uigetfile('*.mat');
path;
if Sim
    PipelineVisualization(Sim,gca,path);
    
    
end
myCircuit = getappdata(gcf,'myCircuit');
myCircuit = myCircuit.CircuitDraw(gca);
setappdata(gcf,'myCircuit',myCircuit);


% --- Executes on button press in handlesButton.
function handlesButton_Callback(hObject, eventdata, handles)
% hObject    handle to handlesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
handles;
gca;
gcf;


% --- Executes on button press in getAppInfo.
function getAppInfo_Callback(hObject, eventdata, handles)
% hObject    handle to getAppInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handlesButton    structure with handlesButton and user data (see GUIDATA)
AppInfo = getappdata(gcf)
circuit = AppInfo.myCircuit
signals = AppInfo.SignalsList
