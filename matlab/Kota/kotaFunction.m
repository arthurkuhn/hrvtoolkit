function [ peaks ] = kotaFunction(sig,fs)
%KOTAFUNCTION Summary of this function goes here
%   Detailed explanation goes here

% every second of the ECG signal was normalized by the standard deviation of the signal in that second. 
numSecs = floor(length(sig) / fs);

for i = 0:numSecs-1
    currSec = sig(1+i*fs:(i+1)*fs-1);
    M = mean(currSec);
    S = std(currSec);
    normalizedSec = arrayfun(@(a) (a - M)/ S, currSec);
    sig(1+i*fs:(i+1)*fs-1) = normalizedSec;
end


% ECG was detrended using a 120-ms smoothing filter with a zero-phase distortion.

filt = lowpassFilter();
sig = filter(filt, sig);

% Difference between successive samples of the signal – equivalent to a highpass filter – was calculated and the samples with negative values were set to zero

sig = diff(sig);
sig(length(sig)+1)=0;
idx = sig < 0;
sig(idx) = 0;

% A 150 ms running average was calculated for the rectified data.
timeWind = 150; %In ms
sig = movmean(sig, timeWind);


% Try to find peaks
[~,locs_Rwave] = findpeaks(sig,'MinPeakHeight',0.005,...
                                    'MinPeakDistance',200);
                                
peaks = locs_Rwave;


end

