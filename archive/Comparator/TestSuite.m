close all;
fs = 1000;

index = 1:60000;

ecgFile = "G002ecg.mat";
load(ecgFile);
sig = G002ecg;
runAllTests(sig, fs, ecgFile);

% ecgFile = "A1ecg.mat";
% load(ecgFile);
% sig = A1ecg;
% runAllTests(sig, fs, ecgFile);
% 
% ecgFile = "a5c3ecg.mat";
% load(ecgFile);
% sig = a5c3ecg;
% runAllTests(sig, fs, ecgFile);
% 
% ecgFile = "a2f1ecg.mat";
% load(ecgFile);
% sig = a2f1ecg;
% runAllTests(sig, fs, ecgFile);