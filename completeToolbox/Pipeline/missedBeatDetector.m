function errors = missedBeatDetector( interval, toleratedeviationPercent )
%missedBeatDetector Finds missed beats in the signal
% Analyses consecutive RR-intervals to detect signs of missed beats.
%
% For each interval, the sum of its neighbors is computed:
%           sum = interval(i-1) + interval(i+1)
% An interval is deemed noisy when:
%       interval(i) > sum - sum*toleratedeviationPercent
% and:  interval(i) < sum - sum*toleratedeviationPercent
%
% Inputs:
%    interval - The RR-interval data
%    toleratedeviationPercent - Tolerated variation in %
%
% Outputs:
%    errors - Boolean Array, 1 for errors
%

allowedDeviation = toleratedeviationPercent / 100;

errors = zeros(1,length(interval));

for i = 2:length(interval)-1
    % double of 2 adjacent hardbeats: missed peak
    sumPrevNext = interval(i-1) + interval(i+1);
    deviation = allowedDeviation * sumPrevNext;
    if(interval(i) > (sumPrevNext - deviation) && interval(i) < (sumPrevNext + deviation))
        errors(i) = 1;
    end
end
end

