function errors = missedBeatDetector( interval, toleratedeviationPercent )
%MISSEDBEATDETECTOR Summary of this function goes here
%   Detailed explanation goes here

allowedDeviation = toleratedeviationPercent / 100;

errors = zeros(1,length(interval));

for i = 2:interval(R_loc)-1
    % double of 2 adjacent hardbeats: missed peak
    sumPrevNext = interval(i-1) + interval(i+1);
    deviation = allowedDeviation * sumPrevNext;
    if(interval(i) > (sumPrevNext - deviation) && interval(i) < (sumPrevNext + deviation))
        errors(i) = 1;
    end
end
end

