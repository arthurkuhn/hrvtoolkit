function [ R_loc, R_value ] = kota( sig, detrended )
%KOTA QRS detection using Hilbert Transform
%   Detailed explanation goes here


% Difference between successive samples of the signal – equivalent to a highpass filter – was calculated and the samples with negative values were set to zero

%added
fs =1000;
plot_graph =1;
time = 0:(1/fs):((length(sig)-1)/fs);
orig_sig = sig;

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

 if (plot_graph == 1)
figure;
bx1 = subplot(2,1,1);
hold on;
plot (time,orig_sig);
plot(time(R_loc),orig_sig(R_loc),'rv','MarkerFaceColor','r')
legend('ECG','R');
title('ECG Signal with R points');
xlabel('Time in seconds');
ylabel('Amplitude');


bx2 = subplot(2,1,2);
interval = diff(R_loc); % Period
periods = interval; % For histogram
interval(length(interval)+1) = interval(length(interval)); % Adding one last index
interval = interval./fs;
periodsSecs = interval;
%dlmwrite(file+".ibi",transpose(periodsSecs));
interval = interval.^-1;
interval = interval.*60; % To get BPM
interval(isinf(interval)) = -2;

f=fit(transpose(time(R_loc)),transpose(interval),'smoothingspline');
plot(f,time(R_loc),interval);

%plot(time,full);
% plot(1:length(interval),interval);
title("Tachogram - Kota - ");
ylabel("Beats per minute");
xlabel("Time (s)");
ylim([100 200]);

linkaxes([bx1,bx2],'x')


end
end



