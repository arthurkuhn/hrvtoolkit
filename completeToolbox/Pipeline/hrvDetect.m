function [ result ] = hrvDetect( params )
%hrvDetect - Analyses an ECG signal to extract heart-rate information
% This function orchestrates the entire program execution.
%
% Process:
%   1. Loading
%   2. Pre-Processing
%   3. Kota detection
%   4. Post-Processing
%   5. Smoothing
%
%
% Inputs:
%    params struct
%
% Outputs:
%    result struct
%
% Please see exact struct definition in sample function or documentation.

% Ensemble Filter Window Size:
ensembleFilterWindowSize = 200; % in ms
smoothingSplinesCoefficient = 0.5; % between 0 and 1

% Load Sig
[ sig, fs ] = loadFromFile( params.filePath, params.fileName );

% Pre-processing
[ sig, detrended ] = preprocessingNew(sig, fs);

% Kota
[ R_locs ] = kota(sig, detrended, fs);

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

intervalLocs = R_locs(1:end-1);
time = 0:(1/fs):((length(detrended)-1)/fs);
switch (params.tachoProcessing.interpolationMethod)
      case 'spline'
          [f,gof,~] = fit(transpose(time(intervalLocs(~noisyIntervals))),transpose(interval(~noisyIntervals)),'smoothingspline','SmoothingParam',smoothingSplinesCoefficient);
          smoothSignal = f(time(intervalLocs(~noisyIntervals)));
          r_squarred = gof.rsquare;
      case 'direct'
          smoothSignal = interval(~noisyIntervals);
          r_squarred = 0;
end
if(params.tachoProcessing.medianFilter.isOn == 1)
    smoothSignal = medfilt1(smoothSignal,params.tachoProcessing.medianFilter.windowSize);
end

tachogram = smoothSignal;
% Make in BPM
smoothSignal = 60*fs./(smoothSignal);
percentNoisy = sum(noisyIntervals) / ( length(R_locs)-1 ) * 100;
switch (params.tachoProcessing.interpolationMethod)
    case 'spline'
        [f,~,~] = fit(transpose(time(intervalLocs(~noisyIntervals))),smoothSignal,'smoothingspline','SmoothingParam',smoothingSplinesCoefficient);
        heartRate = f(time);
    case 'direct'
        heartRate = interp1(transpose(time(intervalLocs(~noisyIntervals))),smoothSignal,time,'direct');
        r_squarred = 0;
end

result = {};
result.fs = fs;
result.tachogram = tachogram;
result.R_locs = intervalLocs(~noisyIntervals);
result.heartRate = heartRate;
result.noisyIntervals = intervalLocs(noisyIntervals);
result.interpolatedFlag = [0];
result.evaluation = struct('totalNumBeats', length(R_locs),'percentInvalid', percentNoisy,'splineRSquare', r_squarred, 'numRemovedEnsemble', sum(noisy), 'numRemovedMAD', sum(outliers), 'missedBeatsNum', missedBeatErrors);

end
