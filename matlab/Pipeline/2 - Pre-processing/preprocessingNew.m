function [ sig, detrended ] = preprocessingNew(sig, fs)


% every second of the ECG signal was normalized by the standard deviation of the signal in that second. 
numSecs = floor(length(sig) / fs);
sigFullSecs = sig(1:numSecs*fs);
sigSplit = reshape(sigFullSecs, fs, numSecs);
newsig = sigSplit;

parfor i = 1:numSecs
    currSec = sigSplit(:,i);
    M = mean(currSec);
    S = std(currSec);
    normalizedSec = arrayfun(@(a) (a - M)/ S, currSec);
    newsig(:,i) = normalizedSec;
end
sigExtend = reshape(newsig,[],1);
sig(1:length(sigExtend)) = sigExtend;

% ECG was detrended using a 120-ms smoothing filter with a zero-phase distortion.
sig(isnan(sig)) = 0;

detrended = sig;

f1=16; %cuttoff low frequency to get rid of baseline wander
f2=26; %cuttoff frequency to discard high frequency noise
Wn=[f1 f2]*2/fs; % cutt off based on fs
N = 3; % order of 3 less processing
[a,b] = butter(N,Wn); %bandpass filtering
ecg_h = filtfilt(a,b,sig);
sig = ecg_h/ max( abs(ecg_h));


