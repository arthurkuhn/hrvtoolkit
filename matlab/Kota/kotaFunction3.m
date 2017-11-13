function [ R_loc, interval, time ] = kotaFunction3( sig, fs, invert )
%KOTAFUNCTION3 Summary of this function goes here
%   Invert = 1 will invert the signal, we will look for S Waves
if(invert == 1)
    sig = -sig;
end
orig_sig = sig;
sig = sig.*100;
time = 0:(1/fs):((length(sig)-1)/fs);

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

sig = preprocessing(sig, fs);
ecg_h = sig;

% Difference between successive samples of the signal – equivalent to a highpass filter – was calculated and the samples with negative values were set to zero

sig = diff(sig);
sig(length(sig)+1)=0;
idx = sig < 0;
sig(idx) = 0;

% A 150 ms running average was calculated for the rectified data.
timeWind = 150; %In ms
sig = movmean(sig, timeWind);

movingAverage = sig;

% MOVING WINDOW INTEGRATION
% MAKE IMPULSE RESPONSE
h = ones (1 ,31)/31;
Delay = 30; % Delay in samples
% Apply filter
x6 = conv (sig ,h);
N = length(x6) - Delay;
x6 = x6 (Delay+[1: N]);

sig = x6;

% Hilbert Transform
transformH = hilbert(sig);

% Find the angle:
angleRads = angle(transformH + sig);

[pks,locs] = findpeaks(-angleRads,'MinPeakDistance',250, 'MinPeakHeight',0);

% FIND R-PEAKS
%left = find(slips>0);
left = locs;
parfor i=1:length(left)-1
 [R_value(i), R_loc(i)] = max( detrended(left(i):left(i+1)) );
 R_loc(i) = R_loc(i)-1+left(i); % add offset
end
interval = diff(R_loc);
interval(length(interval)+1) = interval(length(interval));
end

