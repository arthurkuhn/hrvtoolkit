%% Kotal & Al %%

close all;
clear all;
load("a5c3ecg.mat") % Heavy bias
load("G002ecg.mat")
fs = 1000;

sig = transpose(a5c3ecg);
sig = sig.*100;
%sig = sig(1:100000);
time = 0:(1/fs):((length(sig)-1)/fs);

% every second of the ECG signal was normalized by the standard deviation of the signal in that second. 
numSecs = floor(length(sig) / fs);

for i = 0:numSecs-1
    currSec = sig(1+i*fs:(i+1)*fs-1);
    M = mean(currSec);
    S = std(currSec);
    if(S == 0)
        error(YO);
    end
    normalizedSec = arrayfun(@(a) (a - M)/ S, currSec);
    sig(1+i*fs:(i+1)*fs-1) = normalizedSec;
end

% ECG was detrended using a 120-ms smoothing filter with a zero-phase distortion.
sig(isnan(sig)) = 0;

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
Delay = 0; % Delay in samples
% Apply filter
x6 = conv (sig ,h);
N = length(x6) - Delay;
x6 = x6 (Delay+[1: N]);

figure;
hold on;
plot(1:length(x6), x6);

% Try to find peaks
[~,locs_Rwave] = findpeaks(x6,'MinPeakHeight',0.005,...
                                    'MinPeakDistance',200);
plot(locs_Rwave,x6(locs_Rwave),'rv','MarkerFaceColor','r')

% Plot HRV
interval = diff(locs_Rwave);
figure;
plot(1:length(interval),interval);

x3 = sig;

% Hilbert Transform
transformH = hilbert(sig);

% Find the angle:
angleRads = angle(transformH + sig);

% Plot the transform
figure;
hold on;
plot(time,angleRads);
%plot(time,G002ecg);

[pks,locs] = findpeaks(angleRads,'MinPeakDistance',250, 'MinPeakHeight', 0);

% FIND R-PEAKS
%left = find(slips>0);
left = locs;
for i=1:length(left)-1
 [R_value(i), R_loc(i)] = max( sig(left(i):left(i+1)) );
 R_loc(i) = R_loc(i)-1+left(i); % add offset
end

R_loc=R_loc(R_value>0);
R_value=R_value(R_value>0);
beats = length(R_loc);
time = 0:1/fs:(length(sig)-1)*1/fs;
figure;
ax1 = subplot(3,1,1);
hold on;
plot (time,sig);
plot(time(R_loc),sig(R_loc),'rv','MarkerFaceColor','r')
legend('ECG','R','S','Q');
title('ECG Signal with R points');
xlabel('Time in seconds');
ylabel('Amplitude');
%xlim([1 6])
ax2 = subplot(3,1,2);
hold on;
plot(time(locs),angleRads(locs),'rv','MarkerFaceColor','r')
plot(time,angleRads);
title("Angle with slips identified");

ax3 = subplot(3,1,3);
interval = diff(R_loc); % Period
interval(length(interval)+1) = interval(length(interval)); % Adding one last index
interval = interval./fs;
interval = interval.^-1;
interval = interval.*60; % To get BPM

full = zeros(1,length(sig)); %  Initialize full signal
full(R_loc) = interval; % R Locations, add the inteval value to the full signal
for i = 2:length(full) % Iterate over the full array
    if full(i) == 0 % If 0
        full(i) = full(i-1); % Replace by prev value
    end
end
plot(time,full);
% plot(1:length(interval),interval);
title("Reconstructed HRV POST Hilbert");
ylabel("Beats per minute");
xlabel("Time");
ylim([100 200]);

linkaxes([ax1,ax2, ax3],'x')
