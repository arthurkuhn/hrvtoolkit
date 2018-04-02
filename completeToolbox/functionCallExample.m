
clear all;

ensembleFilter = struct('isOn', 1, 'threshold', 0.4);
madFilter = struct('isOn', 1, 'threshold', 5);
missedBeats = struct('isOn', 1, 'threshold', 20);
postProcessing = struct('ensembleFilter', ensembleFilter, 'madFilter', madFilter, 'missedBeats', missedBeats);

medianFilter = struct('isOn', 0, 'windowSize', 15);
tachoProcessing = struct('interpolationMethod', 'spline', 'medianFilter', medianFilter);

params = struct('ecgFile', 'a02b15a1254c', 'postProcessing', postProcessing, 'tachoProcessing', tachoProcessing);
%params = struct('ecgFile', 'a2f1ba57e8af', 'postProcessing', postProcessing, 'tachoProcessing', tachoProcessing);


[ result ] = hrvDetect( params );