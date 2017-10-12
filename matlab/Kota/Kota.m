%% Kotal & Al %%

close all;
clear all;
load("G002ecg.mat") % Heavy bias
fs = 1000;

sig = G002ecg;
time = 0:(1/fs):((length(sig)-1)/fs);

figure;
plot(time,sig);

% every second of the ECG signal was normalized by the standard deviation of the signal in that second. 
numSecs = floor(length(sig) / fs);

for i = 0:numSecs-1
    currSec = sig(1+i*fs:(i+1)*fs-1);
    M = mean(currSec);
    S = std(currSec);
    normalizedSec = arrayfun(@(a) (a - M)/ S, currSec);
    sig(1+i*fs:(i+1)*fs-1) = normalizedSec;
end

figure;
plot(time,sig);


% ECG was detrended using a 120-ms smoothing filter with a zero-phase distortion.

filt = lowpassFilter();
sig = filter(filt, sig);

figure;
plot(time,sig);

% Difference between successive samples of the signal – equivalent to a highpass filter – was calculated and the samples with negative values were set to zero

sig = diff(sig);
sig(length(sig)+1)=0;
idx = sig < 0;
sig(idx) = 0;

figure;
plot(time,sig);


% A 150 ms running average was calculated for the rectified data.
timeWind = 150; %In ms
sig = movmean(sig, timeWind);

movingAverage = sig;

figure;
hold on;
plot(1:length(sig), sig);

% Try to find peaks
[~,locs_Rwave] = findpeaks(sig,'MinPeakHeight',0.005,...
                                    'MinPeakDistance',200);
plot(locs_Rwave,sig(locs_Rwave),'rv','MarkerFaceColor','r')

% Plot HRV
interval = diff(locs_Rwave);
figure;
plot(1:length(interval),interval);

% Hilbert Transform
transform = hilbert(sig);
% Find the angle:
angleRads = angle(transform + sig);
% Find the phase slips
slips = diff(sign(angleRads));
slips(length(slips)+1) = 0;


% Plot the transform
figure;
hold on;
plot(time,angleRads);
%plot(time,G002ecg);

currMax = movingAverage(i);
maxIndex = 0;
peaks = [];
peakIndex = 1;

% Iterate:
for i = 1:length(sig)-1
    if(slips(i) ~= 0)
        peaks(peakIndex) = maxIndex;
        peakIndex = peakIndex + 1;
        currMax = movingAverage(i);
        continue
    end
    if(movingAverage(i) > currMax)
        currMax = movingAverage(i);
        maxIndex = i;
    end
end

% Plot HRV
interval = diff(peaks);
sig(length(sig)+1)=0;
figure;
plot(1:length(interval),interval);
    
        
    



