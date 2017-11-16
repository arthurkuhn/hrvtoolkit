close all;
clear all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")
load("G011ecg.mat")
G011ecg = data;
load("G013ecg.mat")
G013ecg = data;
fs = 1000;
allowedDeviation = 0.10; % 10%
index=0;
[ R_loc, interval, time ] = kotaFunction3(a5c3ecg, fs, 0 );

hr = interval;
orig_interval = interval;
%[ cleanInterval, removedIndexes ] = sigClean( interval, fs )
%%%%%%%%%%%%%%
allowedDeviation = 0.10; % 10%
index = 0;
for i = 2:(length(hr)-2)
    % double of 2 adjacent hardbeats: missed peak
    length(hr)
    sumPrevNext = hr(i-1) + hr(i+1);
    deviation = allowedDeviation * sumPrevNext;
    if(hr(i) > (sumPrevNext - deviation) && hr(i) < (sumPrevNext + deviation))
        hr(i) = sumPrevNext;
        index = index + 1;
        false(index) = i;
    end
end

tooLow = hr > fs*2;
for i = 1:length(tooLow)
    if(tooLow(i) == 1)
        index = index + 1;
        false(index) = i;
    end
end

tooHigh = hr < 1/4*fs;
for i = 1:length(tooHigh)
    if(tooHigh(i) == 1)
        index = index + 1;
        false(index) = i;
    end
end

% Remove extreme values:
% hr = hr(hr < fs*2); %BPM < 30
% hr = hr(hr > 1/4*fs); %BPM > 240

hr(false) = [];
%%%%%%%%%%%%%%

figure;
subplot(2,1,1);
plot(1:length(hr), hr);
%axis([0 R_loc(length(R_loc)) 0 700]);

subplot(2,1,2);
plot(1:length(orig_interval), orig_interval);
%plot(1:length(hr), hr);
hold on
scatter(false, orig_interval(false),10,'r');
