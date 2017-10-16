%% Kotal & Al %%

close all;
clear all;
load("A1ecg.mat") % Heavy bias
fs = 1000;

sig = transpose(A1ecg);
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

sig = preprocessing(sig, fs);

figure;
plot(time,sig);

% Difference between successive samples of the signal � equivalent to a highpass filter � was calculated and the samples with negative values were set to zero

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

x3 = sig;

% HILBER TRANSFORM
s = x3; % Band-pass filtered ECG signal
d = 1/(pi*length(s));
s2 = conv(s, d);
xe = abs(s)+abs(s2); % Envelop xe(t)

% MOVING WINDOW INTEGRATION
% MAKE IMPULSE RESPONSE
h = ones (1 ,31)/31;
Delay = 15; % Delay in samples
% Apply filter
x6 = conv (xe ,h);
N = length(x6) - 15;
x6 = x6 (15+[1: N]);

x6 = x6/ max( abs(x6 ));

% FIND R-PEAKS
max_h = max(x6);
thresh = mean (x6 );
poss_reg =(x6>thresh*max_h);
left = find(diff([0 poss_reg])==1);
right = find(diff([poss_reg 0])==-1);
for i=1:length(left)
 [R_value(i), R_loc(i)] = max( sig(left(i):right(i)) );
 R_loc(i) = R_loc(i)-1+left(i); % add offset
end

R_loc=R_loc(find(R_value>0));
R_value=R_value(find(R_value>0));
beats = length(R_loc);
time = 0:1/fs:(length(sig)-1)*1/fs;
% CALCULATE THE HEARTRATE
beat_frequency = (length(sig)-1)*1/fs/beats
bpm = beat_frequency*60;
HR = 60./diff(R_loc).*fs;
% PLOTING RESULTS
figure
subplot(3,1,1)
plot (time,sig/max(sig));
title('Orignal ECG Signal');
xlabel('Time in seconds');
ylabel('Amplitude');
subplot(3,1,2)
plot (time,x3/max(x3) , time(R_loc) ,R_value , 'r^');
legend('ECG','R','S','Q');
title('ECG Signal with R points');
xlabel('Time in seconds');
ylabel('Amplitude');
%xlim([1 6])
subplot(3,1,3)
stairs(HR)
title('Heart Rate Signal of ECG ');
xlabel('Time in seconds');
ylabel('HR(min-1)');
xlim([0 10])


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
    
        
    



