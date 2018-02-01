function [ validLocs ] = ensembleMethods( detrended_sig, R_locs, validLocs, windowSize )
%GETENSEMBLEAVERAGE Gets the average of all QRS peaks
%   Detailed explanation goes here
avg = zeros(1,(2*windowSize+1)).';

left = R_locs-windowSize;
right = R_locs+windowSize;

parfor i=1:length(R_locs)
    if(R_locs(i) < windowSize + 1)
        continue;
    end
    complex = detrended_sig(left(i):right(i));
    avg = avg + complex;
end

avg = avg./length(R_locs);


parfor i=1:length(R_locs)
    if(R_locs(i) < windowSize + 1)
        continue;
    end
    complex2 = detrended_sig(left(i):right(i));
    crossCorr = xcorr(complex2, avg);
    corrCoeff = corrcoef(complex2, avg);
    if(corrCoeff(1,2) > 0.9)
        continue
    else
        validLocs(i) = 0;
    end
end

end

