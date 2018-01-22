
function [ output_args ] = plotEnsemble( detrended_sig, R_locs, windowSize )
%PLOTENSEMBLE Summary of this function goes here
%   Detailed explanation goes here

avg = zeros(1,(2*windowSize+1));

parfor i=1:length(R_locs)
    if(R_locs(i) < windowSize + 1)
        continue;
    end
    left = R_locs(i) - windowSize;
    right = R_locs(i) + windowSize;
    complex = detrended_sig(left:right);
    avg = avg + complex;
end

avg = avg./length(R_locs);

figure;
title("Ensemble average");
plot(1:length(avg),avg);

    

end

