function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 22-Mar-2018 12:21:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Create a cluster
% if isempty(gcp)
%     parpool;
% end

% Update handles structure
guidata(hObject, handles);

init(hObject);
makePlots(hObject, false);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using main.
if strcmp(get(hObject,'Visible'),'off')
    %plot(rand(5));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%                   Initialization Functions                            %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parsing Parameters
% Parses the GUI parameters into the handles.p object
function parseParameters(hObject)
handles = guidata(hObject);

% Parse Checkboxes
hCheckboxes = [handles.mediaCheckBox ; handles.ensembleCheckBox; handles.missedBeatsCheckBox; handles.medianFilterPostCheckBox];
checkboxValues = cell2mat(get(hCheckboxes, 'Value'));

% Parse TextBoxes
hEditTextboxes = [handles.windowSizeEdit ; handles.minimumCorrelationEdit; handles.windowSizePostEdit; handles.missedBeatsTolerancePercentEdit; handles.smoothingSplinesCoefEdit];
editValues = get(hEditTextboxes, 'String');

switch get(get(handles.tachoGeneration,'SelectedObject'),'Tag')
      case 'smoothingSplinesRadio'
          interpolationMethod = 'spline';
      case 'directRadio'
          interpolationMethod = 'linear';
end
p = {};

% File select
p.fileName = handles.fileName;
p.pathName = handles.pathName;

% Preprocessing
p.mediaCheckBox = checkboxValues(1);
p.windowSizeEdit = str2double(editValues(1));
p.ensembleCheckBox = checkboxValues(2);
p.minimumCorrelationEdit = str2double(editValues(2));
p.missedBeatsCheckBox = checkboxValues(3);
p.missedBeatsTolerancePercentEdit = str2double(editValues(4));
p.smoothingSplinesCoefEdit = str2double(editValues(5));
p.medianFilterPostCheckBox = checkboxValues(4);
p.windowSizePostEdit = str2double(editValues(3));

% Save handles
handles.p = p;
guidata(hObject,handles);

%% Initializes the Sig handles object
function init(hObject)

%Processing Data
handles = guidata(hObject);
handles.sig.t = [];
handles.sig.detrended = [];
handles.sig.R_locs = [];
handles.sig.f = {};
handles.sig.fs = 0;
handles.sig.interval = [];

%Post-Processing Data
handles.ensemble = {};
handles.ensemble.ecgErrors = [];
handles.ensemble.intervalNoise = [];
handles.noisyIntervals = [];
handles.missedBeats = {};
handles.missedBeats.intervalNoise = [];
handles.madFilter = {};
handles.madFilter.intervalNoise = [];

%Smoothing Data
handles.smoothSig = [];
guidata(hObject,handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%                      Computation Functions                            %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function evaluate(hObject)
handles = guidata(hObject);

% Parse Checkboxes
hCheckboxes = [handles.mediaCheckBox ; handles.ensembleCheckBox; handles.missedBeatsCheckBox; handles.medianFilterPostCheckBox];
checkboxValues = cell2mat(get(hCheckboxes, 'Value'));

% Parse TextBoxes
hEditTextboxes = [handles.windowSizeEdit ; handles.minimumCorrelationEdit; handles.windowSizePostEdit; handles.missedBeatsTolerancePercentEdit; handles.smoothingSplinesCoefEdit];
editValues = get(hEditTextboxes, 'String');

switch get(get(handles.tachoGeneration,'SelectedObject'),'Tag')
      case 'smoothingSplinesRadio'
          interpolationMethod = 'spline';
      case 'directRadio'
          interpolationMethod = 'linear';
end

options = {};

if(checkboxValues(2) == 1)
    options = [options, 'ensemble_filter_threshold', str2double(editValues(2))];
end
if(checkboxValues(1) == 1)
    options = [options, 'mad_filter_threshold', str2double(editValues(1))];
end
if(checkboxValues(3) == 1)
    options = [options, 'missed_beats_tolerance_percent', str2double(editValues(4))];
end
if(checkboxValues(4) == 1)
    options = [options, 'median_filter_window', str2double(editValues(3))];
end

options = [options, 'interpolation_method', interpolationMethod];
options = [options, 'smoothing_spline_coef', str2double(editValues(5))];
options = [options, 'directory', handles.pathName];

handles.result = hrvDetect(handles.fileName, options);

guidata(hObject, handles);

function exportDataIbi(hObject)
handles = guidata(hObject);
tacho = handles.tacho./1000; %To be in seconds
filter = strcat(handles.p.fileName(1:end-4),'.ibi');
[file,path] = uiputfile(filter);
if(~isempty(file))
    csvwrite(fullfile(path,file),tacho);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%                           Output Functions                            %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function makePlots(hObject, plotInSeparateFigure)
handles = guidata(hObject);
if(plotInSeparateFigure == true)
    figure;
    ax1 = subplot(3,1,1);
else
    axes(handles.axes1);
    cla();
end
hold on;
ecgErrors = logical(handles.ensemble.ecgErrors); % Logical to allow indexing
noisyIntervals = logical(handles.noisyIntervals);
noisyIntsEnsemble = logical(handles.ensemble.intervalNoise);
noisyIntsMissedBeats = logical(handles.missedBeats.intervalNoise);
noisyIntsMadFilter = logical(handles.madFilter.intervalNoise);

time = handles.sig.t;
R_locs = handles.sig.R_locs;
detrended = handles.sig.detrended;
fs = handles.sig.fs;
interval = diff(R_locs);

if(~isempty(time))
    plot(time,detrended);
    plot(time(R_locs(~ecgErrors)),detrended(R_locs(~ecgErrors)),'bv','MarkerFaceColor','b')
    if(sum(ecgErrors) ~= 0)
        plot(time(R_locs(ecgErrors)),detrended(R_locs(ecgErrors)),'rv','MarkerFaceColor','r')
        legend('ECG','R-Peaks', 'Uncorrelated Beats');
    else
        legend('ECG','R-Peaks');
    end
end
title('ECG Signal with R points');
xlabel('Time (s)');
ylabel('Amplitude');

if(plotInSeparateFigure == true)
    ax2 = subplot(3,1,2);
else
    axes(handles.axes2);
    cla();
end
hold on;
intervalLocs = R_locs(1:end-1);
BPM = 60*fs./(interval);
if(~isempty(time))
    f = fit(transpose(time(intervalLocs(~noisyIntervals))),transpose(BPM(~noisyIntervals)),'smoothingspline');
    h = plot(f,time(intervalLocs(~noisyIntervals)),BPM(~noisyIntervals));
    legend(h,{'Valid RR-Intervals', 'Default Fit'});
    scatter(time(intervalLocs(noisyIntsEnsemble)),BPM(noisyIntsEnsemble),'DisplayName','Ensemble Filtered');
    scatter(time(intervalLocs(noisyIntsMissedBeats)),BPM(noisyIntsMissedBeats),'DisplayName','Missed Beats');
    scatter(time(intervalLocs(noisyIntsMadFilter)),BPM(noisyIntsMadFilter),'DisplayName','MAD Filtered');
    legend('show');
end

title("Tachogram");
ylabel("BPM");
xlabel("Time (s)");
ylim([100 200]);


if(plotInSeparateFigure == true)
    ax3 = subplot(3,1,3);
else
    axes(handles.axes3);
    cla();
end
if(~isempty(time))
    hold on;
    switch get(get(handles.tachoGeneration,'SelectedObject'),'Tag')
        case 'smoothingSplinesRadio'
        smoothInterpolated = interp1(time(intervalLocs(~noisyIntervals)),handles.smoothSig,time,'spline');
        case 'directRadio'
        smoothInterpolated = interp1(time(intervalLocs(~noisyIntervals)),handles.smoothSig,time,'linear');
    end
    plot(time,smoothInterpolated, 'DisplayName', 'Final Tachogram');
    scatter(time(intervalLocs(noisyIntervals)),smoothInterpolated(intervalLocs(noisyIntervals)),'DisplayName','Interpolated Data', ...
        'MarkerEdgeColor','r',...
        'MarkerFaceColor','r',...
        'LineWidth',0.1);
    legend('show');
end
title("Tachogram Filtered");
ylabel("BPM");
xlabel("Time (s)");
ylim([100 200]);
if(plotInSeparateFigure)
    linkaxes([ax1,ax2, ax3],'x');
end
guidata(hObject, handles);

function showEvaluationResults(hObject)
handles = guidata(hObject);
eval = handles.eval;
set(handles.numRemovedBeatsEnsembleText, 'String', num2str(eval.nonCorrelatedBeats));
set(handles.numRemovedBeatsMadFilterText, 'String', num2str(eval.madFilterNoise));
set(handles.numMissedBeatsText, 'String', num2str(eval.missedBeats));
outputString = num2str(eval.noisyPerThousand / 10) + "%";
set(handles.rPeaksValidText, 'String', outputString);
set(handles.splinesRSquareText, 'String', num2str(eval.fitRSquare));
set(handles.detectedBeatsText, 'String', num2str(eval.numBeats));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%                           Used CallBacks                              %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Executes the main code
% --- Executes on button press in runButton.
function runButton_Callback(hObject, eventdata, handles)
% hObject    handle to runButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

parseParameters(hObject);

% compute(hObject);
h = waitbar(0.2,'Running hrvDetect');

waitbar(0.95, h, 'Evaluating');
evaluate(hObject);
showEvaluationResults(hObject);

waitbar(0.99, h, 'Plotting');
makePlots(hObject,false);


close(h);

%% Allows the user to select a signal
% --- Executes on selection change in fileSelectButton.
function fileSelectButton_Callback(hObject, eventdata, handles)
% hObject    handle to fileSelectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

init(hObject);
makePlots(hObject, false);
[fileName,pathName] = uigetfile('*.mat','Select the APEX file');
handles = guidata(hObject);
set(handles.filename,'String', fileName(1:end-4));
handles.fileName = fileName;
handles.pathName = pathName;
guidata(hObject, handles);

%% Open in a new figure window
% --- Executes on button press in openFigsWindow.
function openFigsWindow_Callback(hObject, eventdata, handles)
% hObject    handle to openFigsWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(~isempty(handles.sig.t))
    makePlots(hObject,true);
end

%% Export to HRVAS
% --- Executes on button press in hrvasExport.
function hrvasExport_Callback(hObject, eventdata, handles)
% hObject    handle to hrvasExport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
%                           Unused CallBacks                            %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% Hints: contents = get(hObject,'String') returns fileSelectButton contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileSelectButton


% --- Executes during object creation, after setting all properties.
function fileSelectButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileSelectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in mediaCheckBox.
function mediaCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to mediaCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mediaCheckBox


% --- Executes on button press in ensembleCheckBox.
function ensembleCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to ensembleCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ensembleCheckBox


% --- Executes on button press in medianFilterPostCheckBox.
function medianFilterPostCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to medianFilterPostCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of medianFilterPostCheckBox



function windowSizePostEdit_Callback(hObject, eventdata, handles)
% hObject    handle to windowSizePostEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowSizePostEdit as text
%        str2double(get(hObject,'String')) returns contents of windowSizePostEdit as a double


% --- Executes during object creation, after setting all properties.
function windowSizePostEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowSizePostEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function windowSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to windowSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of windowSizeEdit as a double


% --- Executes during object creation, after setting all properties.
function windowSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minimumCorrelationEdit_Callback(hObject, eventdata, handles)
% hObject    handle to minimumCorrelationEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minimumCorrelationEdit as text
%        str2double(get(hObject,'String')) returns contents of minimumCorrelationEdit as a double


% --- Executes during object creation, after setting all properties.
function minimumCorrelationEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minimumCorrelationEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in missedBeatsCheckBox.
function missedBeatsCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to missedBeatsCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of missedBeatsCheckBox


% --- Executes on button press in smoothingSplinesCheckBox.
function smoothingSplinesCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to smoothingSplinesCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of smoothingSplinesCheckBox



function smoothingSplinesCoefEdit_Callback(hObject, eventdata, handles)
% hObject    handle to smoothingSplinesCoefEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothingSplinesCoefEdit as text
%        str2double(get(hObject,'String')) returns contents of smoothingSplinesCoefEdit as a double


% --- Executes during object creation, after setting all properties.
function smoothingSplinesCoefEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothingSplinesCoefEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function missedBeatsTolerancePercentEdit_Callback(hObject, eventdata, handles)
% hObject    handle to missedBeatsTolerancePercentEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of missedBeatsTolerancePercentEdit as text
%        str2double(get(hObject,'String')) returns contents of missedBeatsTolerancePercentEdit as a double


% --- Executes during object creation, after setting all properties.
function missedBeatsTolerancePercentEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to missedBeatsTolerancePercentEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in medianFilterPostCheckBox.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to medianFilterPostCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of medianFilterPostCheckBox



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to windowSizePostEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowSizePostEdit as text
%        str2double(get(hObject,'String')) returns contents of windowSizePostEdit as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowSizePostEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exportFulResults.
function exportFulResults_Callback(hObject, eventdata, handles)
% hObject    handle to exportFulResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exportIBI.
function exportIBI_Callback(hObject, eventdata, handles)
% hObject    handle to exportIBI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exportDataIbi(hObject);