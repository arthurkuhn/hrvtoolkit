function [ result ] = hrvDetect( params )
%RUNHRVANALYSIS Summary of this function goes here
%   Detailed explanation goes here

% Ensemble Filter Window Size:
ensembleFilterWindowSize = 200; % in ms
smoothingSplinesCoefficient = 0.5; % between 0 and 1

% Load Sig
[ sig, fs ] = loadFromFile( params.ecgFile );

% Pre-processing
[ sig, detrended ] = preprocessingNew(sig, fs);

% Kota
[ R_locs ] = kota(sig, detrended);

if(params.postProcessing.ensembleFilter.isOn == 1)
    errors = ensembleNonCorrelatedDetector( detrended, R_locs, params.postProcessing.ensembleFilter.threshold, ensembleFilterWindowSize );
else
    errors = zeros(1,length(R_locs));
end


% Make the interval array with the valid beats
interval = diff(R_locs);
noisy = zeros(1,length(interval));
for i = 1:length(R_locs)-1
    % Since here interval(i) = R_locs(i+1)-R_locs(i)
    if(errors(i) == 1)
        if(i > 1)
            noisy(i-1) = 1;
            noisy(i) = 1;
        else
            noisy(i) = 1;
        end
    end
end

% Check for missed beat signs

if(params.postProcessing.missedBeats.isOn == 1)
    missedBeatErrors = missedBeatDetector( interval, params.postProcessing.missedBeats.threshold );
else 
    missedBeatErrors = zeros(1, length(interval));
end

% Use the non-destructive median filter:
if(params.postProcessing.madFilter.isOn == 1)
    outliers = medFilter( interval, params.postProcessing.madFilter.threshold );
else 
    outliers = zeros(1, length(interval));
end

totalNoisyIntervals = noisy | missedBeatErrors | outliers;

noisyIntervals = logical(totalNoisyIntervals);

BPM = 60*fs./(interval);
intervalLocs = R_locs(1:end-1);
time = 0:(1/fs):((length(detrended)-1)/fs);
switch (params.tachoProcessing.interpolationMethod)
      case 'spline'
          f = fit(transpose(time(intervalLocs(~noisyIntervals))),transpose(BPM(~noisyIntervals)),'smoothingspline','SmoothingParam',smoothingSplinesCoefficient);
          smoothSignal = f(time(intervalLocs(~noisyIntervals)));
      case 'direct'
          smoothSignal = BPM(~noisyIntervals);
end
if(params.tachoProcessing.medianFilter.isOn == 1)
    smoothSignal = medfilt1(smoothSignal,params.tachoProcessing.medianFilter.windowSize);
end

percentNoisy = sum(noisyIntervals) / ( length(R_locs)-1 ) * 100;
switch (params.tachoProcessing.interpolationMethod)
    case 'spline'
        [~,gof,~] = fit(transpose(time(intervalLocs(~noisyIntervals))),transpose(BPM(~noisyIntervals)),'smoothingspline','SmoothingParam',smoothingSplinesCoefficient);
        r_squarred = gof.rsquare;
    case 'direct'
        r_squarred = 0;
end

result = {};
result.tachogram = interval;
result.R_locs = R_locs;
result.heartRate = smoothSignal;
result.interpolatedFlag = [0];
result.evaluation = struct('totalNumBeats', length(R_locs),'percentInvalid', percentNoisy,'splineRSquare', r_squarred);

end

