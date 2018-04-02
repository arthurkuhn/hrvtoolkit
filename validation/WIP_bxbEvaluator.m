clear all;
close all;

fprintf("Running Algorithm ");

numSamples = 50000;
i=1;
record = strcat('picsdb/infant', int2str(i), '_ecg');
rec = strcat('infant', int2str(i), '_ecg.mat');
result = hrvDetect(rec, 'n_sample_start', 1 , ...
    'n_sample_end', numSamples, ...
    'ensemble_filter_threshold', 0.1, ...
    'mad_filter_threshold', 20, ...
    'missed_beats_tolerance_percent', 20, ...
    'median_filter_window', 3, ...
    'interpolation_method','spline', ...
    'smoothing_spline_coef', 0.5);

R_locs = result.R_locs.';
fs = result.fs;
maxDeviation = fs / 40;  % Quarter of a second is max deviation

wrann(record,'test',R_locs,'N',0,0,numSamples);
fprintf("Getting Valid Data ");
R_locs_valid = rdann(record,'qrsc',[],numSamples);
fprintf("BXB ");

startTime = 0;
endTime = floor(numSamples/fs);
output = strcat(record, "-report.txt");
% BxbCmd = ['C:\Users\Arthur\Documents\GitHub\hr2\hr-dp\tools\WFDBToolbox\mcode\nativelibs\windows\', 'bin', '\', 'bxb', ' -r ', record, ' -a ', 'qrsc', ' ', 'test', ' -S ', 'C:\Users\Arthur\Documents\GitHub\hr2\hr-dp\data\output\report2.txt', ' -v'];
%         [status,result] = system(BxbCmd);
%         
report=bxb(record,'atr','test','report.txt');
fprintf("Done");
