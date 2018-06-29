function varargout = QCALayoutGUI(varargin)
% QCALAYOUTGUI MATLAB code for QCALayoutGUI.fig
%      QCALAYOUTGUI, by itself, creates a new QCALAYOUTGUI or raises the existing
%      singleton*.
%
%      H = QCALAYOUTGUI returns the handle to a new QCALAYOUTGUI or the handle to
%      the existing singleton*.
%
%      QCALAYOUTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
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

% Last Modified by GUIDE v2.5 29-Jun-2018 12:59:53

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
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QCALayoutGUI (see VARARGIN)

% Choose default command line output for QCALayoutGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles)

% set(handles.figure1,'Name','QCA Layout Demo');



myCircuit = QCACircuit();
myCircuit.CircuitDraw(gca);
RightClickThings();


setappdata(gcf, 'myCircuit', myCircuit);
Path.home = pwd;
Path.circ = 'C:\Users\jprev\Desktop\QCA\QCA Research\QCAInputSim\Circuits folder'; %this needs to change!!!

setappdata(gcf,'Path',Path);




% UIWAIT makes QCALayoutGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = QCALayoutGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in addNodeButton.
function addNodeButton_Callback(hObject, eventdata, handles)
% hObject    handle to addNodeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
QCALayoutAddNode();




% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

delete(hObject);



function editText_Callback(hObject, eventdata, handles)
% hObject    handle to editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText as text
%        str2double(get(hObject,'String')) returns contents of editText as a double
QCALayoutAddNode();

% --- Executes during object creation, after setting all properties.
function editText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SaveCircuit_Callback(hObject, eventdata, handles)
% hObject    handle to SaveCircuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SaveCircuit(gcf);



% --------------------------------------------------------------------
function SaveMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SaveCircuit(gcf,handles);

% --------------------------------------------------------------------
function OpenMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadCircuit(gcf,handles)



% --------------------------------------------------------------------
function NewMenu_Callback(hObject, eventdata, handles)
% hObject    handle to NewMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NewCircuit(gcf,handles);




%not being used currently
function changex_Callback(hObject, eventdata, handles)
% hObject    handle to changex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changex as text
%        str2double(get(hObject,'String')) returns contents of changex as a double
ChangeX(handles);

% --- Executes during object creation, after setting all properties.
function changex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%not being used currently
function changey_Callback(hObject, eventdata, handles)
% hObject    handle to changey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changey as text
%        str2double(get(hObject,'String')) returns contents of changey as a double
ChangeY(handles);

% --- Executes during object creation, after setting all properties.
function changey_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function chngPol_Callback(hObject, eventdata, handles)
% hObject    handle to chngPol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chngPol as text
%        str2double(get(hObject,'String')) returns contents of chngPol as a double
ChangePol(handles)

% --- Executes during object creation, after setting all properties.
function chngPol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chngPol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in layoutchange.
function layoutchange_Callback(hObject, eventdata, handles)
% hObject    handle to layoutchange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of layoutchange
SwitchMode(handles);


% --- Executes on button press in makeSC.
function makeSC_Callback(hObject, eventdata, handles)
% hObject    handle to makeSC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of makeSC

MakeSuperCellGUI()


% --- Executes on button press in disbandsupercell.
function disbandsupercell_Callback(hObject, eventdata, handles)
% hObject    handle to disbandsupercell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DisbandSuperCell();


% --- Executes on button press in simbutton.
function simbutton_Callback(hObject, eventdata, handles)
% hObject    handle to simbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Simulate(handles);


% --- Executes on button press in removeNode.
function removeNode_Callback(hObject, eventdata, handles)
% hObject    handle to removeNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RemoveNode();


% --- Executes on button press in addDriver.
function addDriver_Callback(hObject, eventdata, handles)
% hObject    handle to addDriver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
QCALayoutAddDriver();


% --- Executes on button press in add5Cells.
function add5Cells_Callback(hObject, eventdata, handles)
% hObject    handle to add5Cells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Add5Cells(handles);
for i=1:5 
    QCALayoutAddNode()
end


% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ResetCells();



function chngClock_Callback(hObject, eventdata, handles)
% hObject    handle to chngClock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chngClock as text
%        str2double(get(hObject,'String')) returns contents of chngClock as a double
ChangeClockField(handles);

% --- Executes during object creation, after setting all properties.
function chngClock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chngClock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function chngPos_Callback(hObject, eventdata, handles)
% hObject    handle to chngPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chngPos as text
%        str2double(get(hObject,'String')) returns contents of chngPos as a double
ChangeCellPos(handles);

% --- Executes during object creation, after setting all properties.
function chngPos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chngPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in snap2grid.
function snap2grid_Callback(hObject, eventdata, handles)
% hObject    handle to snap2grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SnapToGrid(handles);


% --- Executes on button press in autoSnap.
function autoSnap_Callback(hObject, eventdata, handles)
% hObject    handle to autoSnap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoSnap
AutoSnap(handles);


% --- Executes on button press in refresh.
function refresh_Callback(hObject, eventdata, handles)
% hObject    handle to refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myCircuit = getappdata(gcf,'myCircuit');

myCircuit = myCircuit.CircuitDraw(gca);

setappdata(gcf,'myCircuit',myCircuit);




% --- Executes on button press in circuitPanel.
function circuitPanel_Callback(hObject, eventdata, handles)
% hObject    handle to circuitPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of circuitPanel
% PanelSwitch(handles);
    handles.signalPanel.Value = 0;
    handles.signalButtonGroup.Visible = 'off';
    
    handles.circuitPanel.Value = 1;
    handles.circuitButtonGroup.Visible = 'on';

    
% --- Executes on button press in signalPanel.
function signalPanel_Callback(hObject, eventdata, handles)
% hObject    handle to signalPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of signalPanel
% PanelSwitch(handles);
    handles.signalPanel.Value = 1;
    handles.signalButtonGroup.Visible = 'on';
    
    handles.circuitPanel.Value = 0;
    handles.circuitButtonGroup.Visible = 'off';
    
    
    



function changeWave_Callback(hObject, eventdata, handles)
% hObject    handle to changeWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeWave as text
%        str2double(get(hObject,'String')) returns contents of changeWave as a double


% --- Executes during object creation, after setting all properties.
function changeWave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeWave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function changePhase_Callback(hObject, eventdata, handles)
% hObject    handle to changePhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changePhase as text
%        str2double(get(hObject,'String')) returns contents of changePhase as a double


% --- Executes during object creation, after setting all properties.
function changePhase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changePhase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function changeAmp_Callback(hObject, eventdata, handles)
% hObject    handle to changeAmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changeAmp as text
%        str2double(get(hObject,'String')) returns contents of changeAmp as a double


% --- Executes during object creation, after setting all properties.
function changeAmp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changeAmp (see GCBO)
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
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signalType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signalType



% --- Executes during object creation, after setting all properties.
function signalType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function changePeriod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to changePeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function changePeriod_Callback(hObject, eventdata, handles)
% hObject    handle to changePeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of changePeriod as text
%        str2double(get(hObject,'String')) returns contents of changePeriod as a double


% --- Executes on button press in createSignal.
function createSignal_Callback(hObject, eventdata, handles)
% hObject    handle to createSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.signalType,'String')); 
sigType = contents{get(handles.signalType,'Value')} ;


% sigType = handles.signalType.String;
mySignal = Signal();

switch sigType
    case 'Sinusoidal'
        mySignal.Amplitude = str2num(handles.changeAmp.String);
        mySignal.Wavelength = str2num(handles.changeWave.String);
        mySignal.Period = str2num(handles.changePeriod.String);
        mySignal.Phase = str2num(handles.changePhase.String);
        mySignal.Type = sigType;
    case 'Custom'
        
        mySignal.Type = sigType;
    
    otherwise
        
end



if ~isempty(handles.signalName.String)
    
    handles.signalList.String{end+1,1} = handles.signalName.String;

setappdata(gcf,handles.signalName.String,mySignal);
end




function signalName_Callback(hObject, eventdata, handles)
% hObject    handle to signalName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of signalName as text
%        str2double(get(hObject,'String')) returns contents of signalName as a double


% --- Executes during object creation, after setting all properties.
function signalName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in signalList.
function signalList_Callback(hObject, eventdata, handles)
% hObject    handle to signalList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns signalList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from signalList
contents = cellstr(get(handles.signalList,'String'));

if ~isempty(contents)
    sigName = contents{get(handles.signalList,'Value')};
    
    mySignal = getappdata(gcf,sigName);
    
    if ~isempty(mySignal)
        sigType = mySignal.Type;
        
        handles.signalEditor.String = sigName;
        
        switch sigType
            
            case 'Sinusoidal'
                
                handles.changeAmp.String = num2str(mySignal.Amplitude);
                handles.changeWave.String = num2str(mySignal.Wavelength);
                handles.changePeriod.String = num2str(mySignal.Period);
                handles.changePhase.String = num2str(mySignal.Phase);
                
                
            case 'Custom'
                
        end
        setappdata(gcf,sigName,mySignal);
    end
end





% --- Executes during object creation, after setting all properties.
function signalList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signalList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in deleteSignal.
function deleteSignal_Callback(hObject, eventdata, handles)
% hObject    handle to deleteSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(handles.signalList,'String'));

if ~isempty(contents)
   
    sigName = contents{get(handles.signalList,'Value')};
   
    deleteSig = getappdata(gcf,sigName);
    
    contents{get(handles.signalList,'Value')} = '';
   
    newList={};
    for i=1:length(contents)
        
        if ~isempty(contents{i})
            newList{end+1} = contents{i};
        end
        
    end
   
    
    handles.signalList.String = newList;
  handles.signalList.Value = 1;
    
   
    deleteSig = {};
    
    setappdata(gcf,sigName,deleteSig);
    
end





% --- Executes on button press in saveSignal.
function saveSignal_Callback(hObject, eventdata, handles)
% hObject    handle to saveSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.signalList,'String'));

if ~isempty(contents)
    sigName = contents{get(handles.signalList,'Value')};
    
    mySignal = getappdata(gcf,sigName);
    
    if ~isempty(mySignal)
        sigType = mySignal.Type;
        
        handles.signalEditor.String = '';
        
        switch sigType
            
            case 'Sinusoidal'
                
                mySignal.Amplitude = str2num(handles.changeAmp.String);
                mySignal.Wavelength = str2num(handles.changeWave.String);
                mySignal.Period = str2num(handles.changePeriod.String);
                mySignal.Phase = str2num(handles.changePhase.String);
                
                
                
                
            case 'Custom'
                
        end
        setappdata(gcf,sigName,mySignal);
    end
end


% --- Executes on button press in plotSignal.
function plotSignal_Callback(hObject, eventdata, handles)
% hObject    handle to plotSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.signalList,'String'));

if ~isempty(contents)
    sigName = contents{get(handles.signalList,'Value')};
    
    mySignal = getappdata(gcf,sigName);
    
    if ~isempty(mySignal)
        sigType = mySignal.Type;
        
        handles.signalEditor.String = sigName;
        
        switch sigType
            
            case 'Sinusoidal'
                
                A = handles.changeAmp.String
                L = handles.changeWave.String
                T = handles.changePeriod.String
                b = handles.changePhase.String
                
                
            case 'Custom'
                
        end
        setappdata(gcf,sigName,mySignal);
    end
    t=-5:.01:5;
    
    y = A*cos( - b)
    
end

