function [ R_loc ] = kota( sig, detrended, fs )
%kota - QRS detection using Hilbert Transform
% Detects the location of R-peaks using the algorithm described by Kota &
% al.
%
% Process:
%   1. High-Pass filtering
%   2. Half-Wave rectifier
%   3. Moving average (150ms)
%   4. Moving window integration
%   5. Find the instantaneous phase using the Hilbert Transform
%   6. Find the R-Peak between each phase slip
%
%
% Inputs:
%    sig - The preprocessed signal
%    detrended - The detrended signal
%
% Outputs:
%    R_loc - Array with the R-Peak locations
%
%
% Reference:
% Kota, S., Swisher, C.B. & al (2017). "Identification of QRS complex in
% non-stationary electrocardiogram of sick infants."
% Computers in Biology and Medicine 87 (2017) 211–216


% Difference between successive samples of the signal – equivalent to a highpass filter – was calculated and the samples with negative values were set to zero

sig = diff(sig);
sig(length(sig)+1)=0;
idx = sig < 0;
sig(idx) = 0;

% A 150 ms running average was calculated for the rectified data.
timeWind = floor(fs * 150 / 1000); %150 ms window
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

minPeakSeparation = floor( fs / 4); % Minimum separation between beats is a quarter of a second

[pks,locs] = findpeaks(-angleRads,'MinPeakDistance', minPeakSeparation, 'MinPeakHeight',0);

% FIND R-PEAKS
%left = find(slips>0);
left = locs;
parfor i=1:length(left)-1
 [R_value(i), R_loc(i)] = max( detrended(left(i):left(i+1)) );
 R_loc(i) = R_loc(i)-1+left(i); % add offset
end

if(isempty(locs))
    R_loc = [];
end

end



