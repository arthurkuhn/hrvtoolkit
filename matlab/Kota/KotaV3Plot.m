%% Kotal & Al %%

% V3 Instead of looking for peaks on the orig_sig, we look for them in the
% detrended signal. We keep a minimum peak height in the slips to be
% negative to keep FPs low.



load("a5c3ecg.mat") % visible bradycardia
load("G002ecg.mat") % Heavy bias, brady -> 5 missed beats
load("A1ecg.mat") % Faint
load("a2f1ecg.mat") % Some Missed beats -> Tweak
load("G011ecg.mat")
load("G013ecg.mat")

fs = 1000;
file = "G013ecg";
sig = transpose(G013ecg);
orig_sig = sig;
sig = sig.*100;
%sig = sig(1:100000);
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

% R_loc=R_loc(R_value>0);
% R_value=R_value(R_value>0);
beats = length(R_loc);
time = 0:1/fs:(length(sig)-1)*1/fs;
figure;
ax1 = subplot(1,1,1);
hold on;
plot (time,orig_sig);
plot(time(R_loc),orig_sig(R_loc),'rv','MarkerFaceColor','r')
legend('ECG','R');
title('ECG Signal with R points');
xlabel('Time in seconds');
ylabel('Amplitude');
%xlim([1 6])
figure;
ax2 = subplot(1,1,1);
hold on;
plot(time(locs),angleRads(locs),'rv','MarkerFaceColor','r')
plot(time,angleRads);
title("Angle with slips identified");

figure
ax3 = subplot(1,1,1);
interval = diff(R_loc); % Period
periods = interval; % For histogram
interval(length(interval)+1) = interval(length(interval)); % Adding one last index
interval = interval./fs;
periodsSecs = interval;
dlmwrite(file+".ibi",transpose(periodsSecs));
interval = interval.^-1;
interval = interval.*60; % To get BPM
interval(isinf(interval)) = -2;

f=fit(transpose(time(R_loc)),transpose(interval),'smoothingspline');
plot(f,time(R_loc),interval);

%plot(time,full);
% plot(1:length(interval),interval);
title("Reconstructed HRV POST Hilbert");
ylabel("Beats per minute");
xlabel("Time");
ylim([100 200]);

figure;
ax4 = subplot(1,1,1);
vel = diff(periods);
vel(length(vel)+1)=vel(length(vel));
vel(length(vel)+1)=vel(length(vel));
plot(time(R_loc),vel);
title("Changes in RR-Interval");
xlabel("Time (in s)");
ylabel("RR-Interval Change with previous beat (in ms)");

linkaxes([ax1,ax2, ax3, ax4],'x')


figure;
hold on
histogram(periods)
title("Distribution of RR-Intervals in recording: " + file);
xlabel("RR-Interval (in ms)");
ylabel("Frequency");
set(gca,'YScale','log');