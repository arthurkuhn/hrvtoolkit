
clear all;

ensembleFilter = struct('isOn', 1, 'threshold', 0.2);
madFilter = struct('isOn', 1, 'threshold', 5);
missedBeats = struct('isOn', 1, 'threshold', 20);
postProcessing = struct('ensembleFilter', ensembleFilter, 'madFilter', madFilter, 'missedBeats', missedBeats);

medianFilter = struct('isOn', 1, 'windowSize', 15);
tachoProcessing = struct('interpolationMethod', 'spline', 'medianFilter', medianFilter);

params = struct('ecgFile', 'a5c37ce1d999', 'postProcessing', postProcessing, 'tachoProcessing', tachoProcessing);


[ result ] = hrvDetect( params );