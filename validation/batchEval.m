function loss = batchEval( x )
%BATCHEVAL Summary of this function goes here
%   Detailed explanation goes here

if(length(x) ~= 3)
    error("Invalid Input Size");
end

ensemble_filter_threshold = x(1);
mad_filter_threshold = x(2);
missed_beats_tolerance_percent = x(3);

numSamples = 3000000;
avgPrecision = 0;
avgRecall = 0;
avgF_score = 0;
avgJitter = 0;

evaluated = 1:8;
precisionArr = zeros(1, length(evaluated));
recallArr = zeros(1, length(evaluated));
f_scoreArr = zeros(1, length(evaluated));
jitterArr = zeros(1, length(evaluated));
parfor i = evaluated
    record = strcat('infant', int2str(i), '_ecg');
    result = hrvDetect(record, 'n_sample_start', 1 , ...
        'n_sample_end', numSamples, ...
        'ensemble_filter_threshold', ensemble_filter_threshold, ...
        'mad_filter_threshold', mad_filter_threshold, ...
        'missed_beats_tolerance_percent', missed_beats_tolerance_percent, ...
        'interpolation_method','linear', ...
        'smoothing_spline_coef', 0.9);
    if(isempty(result.R_locs))
        precisionArr(i) = 0;
        recallArr(i) = 0;
        f_scoreArr(i) = 0;
        jitterArr(i) = 0;
        continue;
    end
    [ precision, recall, f_score, jitter ] = compareWithPhysio( record, result, numSamples, 15, 0 );
    
    
    if(isnan(precision))
        precisionArr(i) = 0;
        recallArr(i) = 0;
        f_scoreArr(i) = 0;
        jitterArr(i) = 0;
        continue;
    end
    
    precisionArr(i) = precision;
    recallArr(i) = recall;
    f_scoreArr(i) = f_score;
    if(isempty(jitter))
        jitterArr(i) = 0;
    else
        jitterArr(i) = sum(jitter)/length(jitter);
    end
end

completeLoss = sum(precisionArr == 0);

avgPrecision = sum(precisionArr) / length(precisionArr);
avgRecall = sum(recallArr) / length(recallArr);
avgF_score = sum(f_scoreArr) / length(f_scoreArr);
avgJitter = sum(jitterArr) / length(jitterArr);

loss = (1 - avgF_score) + completeLoss; % Huge penalty for no detection
