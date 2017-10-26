%% Kotal & Al %%

close all;
load("A1ecg.mat") % Heavy bias
fs = 1000;

sig = transpose(A1ecg);
sig = sig(1:100000);
time = 0:(1/fs):((length(sig)-1)/fs);

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
Delay = 15; % Delay in samples
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

% HILBER TRANSFORM
s = x3; % Band-pass filtered ECG signal
d = 1/(pi*length(s));
s2 = conv(s, d);
xe = abs(s)+abs(s2); % Envelop xe(t)

% Hilbert Transform
transformH = hilbert(sig);

% Find the angle:
angleRads = angle(transformH);
% Find the phase slips
slips = diff(sign(angleRads));
slips(length(slips)+1) = 0;


% Plot the transform
figure;
hold on;
plot(time,angleRads);
%plot(time,G002ecg);

prevSlip = 0;
for i = 1:length(slips)
    if slips(i)>0 && prevSlip < 150
        slips(i) = 0;
    elseif slips(i)>0
         prevSlip = 0;
    else
         prevSlip = prevSlip + 1;
    end
end

[~,locs] = findpeaks(-abs(transformH),'MinPeakDistance',200);

% FIND R-PEAKS
left = find(slips>0);
%left = locs;
for i=1:length(left)-1
 [R_value(i), R_loc(i)] = max( sig(left(i):left(i+1)) );
 R_loc(i) = R_loc(i)-1+left(i); % add offset
end

R_loc=R_loc(find(R_value>0));
R_value=R_value(find(R_value>0));
beats = length(R_loc);
time = 0:1/fs:(length(sig)-1)*1/fs;
figure;
ax1 = subplot(2,1,1);
hold on;
plot (time,x3);
plot(time(R_loc),x3(R_loc),'rv','MarkerFaceColor','r')
legend('ECG','R','S','Q');
title('ECG Signal with R points');
xlabel('Time in seconds');
ylabel('Amplitude');
%xlim([1 6])
ax2 = subplot(2,1,2);
hold on;
plot(time(R_loc),sig(R_loc),'rv','MarkerFaceColor','r')
plot(time,angleRads);

linkaxes([ax1,ax2],'x')


figure;
% Plot HRV
interval = diff(R_loc);
plot(1:length(interval),interval);
title("HRV POST Hilbert");
xlim([200 600]);
