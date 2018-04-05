
clear all;

ensembleFilter = struct('isOn', 1, 'threshold', 0.4);
madFilter = struct('isOn', 1, 'threshold', 5);
missedBeats = struct('isOn', 1, 'threshold', 20);
postProcessing = struct('ensembleFilter', ensembleFilter, 'madFilter', madFilter, 'missedBeats', missedBeats);

medianFilter = struct('isOn', 0, 'windowSize', 15);
tachoProcessing = struct('interpolationMethod', 'spline', 'medianFilter', medianFilter);

<<<<<<< HEAD:completeToolbox/functionCallExample.m
params = struct('ecgFile', 'a02b15a1254c', 'postProcessing', postProcessing, 'tachoProcessing', tachoProcessing);
%params = struct('ecgFile', 'a2f1ba57e8af', 'postProcessing', postProcessing, 'tachoProcessing', tachoProcessing);
=======
params = struct('filePath','C:\Users\Arthur\Documents\GitHub\hr2\hr-dp\data\APEX', 'fileName', 'a5c37ce1d999', 'postProcessing', postProcessing, 'tachoProcessing', tachoProcessing);
>>>>>>> d2769396e04e7d8d5e4a75516be07d874795e201:ex-qrs/functionCallExample.m


[ result ] = hrvDetect( params );