function nonCorrelated = ensembleNonCorrelatedDetector( detrended_sig, R_locs, minCorrelation, windowSize )
%ENSEMBLEOUTLIERDETECTOR Summary of this function goes here
%   Detailed explanation goes here

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

correlationCoefArray = zeros(1,length(R_locs));
maxCorrelationArray = zeros(1,length(R_locs));
print

parfor i=1:length(R_locs)
    leftIndex = left(i);
    rightIndex = right(i);
    if(leftIndex < 0 || rightIndex > length(detrended_sig))
        continue;
    end
    complex2 = detrended_sig(leftIndex:rightIndex);
    crossCorr = xcorr(complex2, avg);
    corrCoeff = corrcoef(complex2, avg);
    correlationCoefArray(i) = corrCoeff(1,2);
    maxCorrelationArray(i) = max(crossCorr);
    if(corrCoeff(1,2) > minCorrelation)
        continue
    else
        nonCorrelated(i) = 1;
    end
end




end

