function [ R_loc, R_value ] = kota( sig, detrended )
%KOTA QRS detection using Hilbert Transform
%   Detailed explanation goes here


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

end



