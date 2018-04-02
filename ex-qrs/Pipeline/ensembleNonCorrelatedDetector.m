function nonCorrelated = ensembleNonCorrelatedDetector( detrended_sig, R_locs, minCorrelation, windowSize )
%ensembleNonCorrelatedDetector - Analyses an ECG signal and estimated
% R-peak locations to determine which might be noisy.
%
% Process:
%   1. construct an average beat over all the beats
%   2. each beat is compared to the average beat
%   3. If the static correlation is < minCorrelation, the beat is marked as
%       noisy
%
% Inputs:
%    detrended_sig detrended ecg signal
%    R_locs the detected peaks
%    minCorrelation between 0 and 1
%    windowSize in samples
%
% Outputs:
%    nonCorrelated boolean array (1 for errors)


nonCorrelated = zeros(1,length(R_locs));

avg = zeros(1,(2*windowSize+1));

left = R_locs-windowSize;
right = R_locs+windowSize;

parfor i=1:length(R_locs)
    leftIndex = left(i);
    rightIndex = right(i);
    if(leftIndex < 0 || rightIndex > length(R_locs))
        continue;
    end
    complex = detrended_sig(leftIndex:rightIndex);
    avg = avg + complex;
end

avg = avg./length(R_locs);

parfor i=1:length(R_locs)
    leftIndex = left(i);
    rightIndex = right(i);
    if(leftIndex < 0 || rightIndex > length(detrended_sig))
        continue;
    end
    complex2 = detrended_sig(leftIndex:rightIndex);
    corrCoeff = corrcoef(complex2, avg);
    if(corrCoeff(1,2) > minCorrelation)
        continue
    else
        nonCorrelated(i) = 1;
    end
end




end

