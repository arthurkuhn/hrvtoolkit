function loss = batchEval( ensemble_filter_threshold,  mad_filter_threshold, missed_beats_tolerance_percent)
%BATCHEVAL Summary of this function goes here
%   Detailed explanation goes here

numSamples = 500000;

avgPrecision = 0;
avgRecall = 0;
avgF_score = 0;
avgJitter = 0;

precisionArr = zeros(1,9);
recallArr = zeros(1,9);
f_scoreArr = zeros(1,9);
jitterArr = zeros(1,9);

for i = 1:9
    record = strcat('infant', int2str(i), '_ecg');

    result = hrvDetect(record, 'n_sample_start', 1 , ...
        'n_sample_end', numSamples, ...
        'ensemble_filter_threshold', ensemble_filter_threshold, ...
        'mad_filter_threshold', mad_filter_threshold, ...
        'missed_beats_tolerance_percent', missed_beats_tolerance_percent, ...
        'interpolation_method','direct', ...
        'smoothing_spline_coef', 0.9);
    
    [ precision, recall, f_score, jitter ] = compareWithPhysio( record, result, numSamples, 15, 0 );
    
    precisionArr(i) = precision;
    recallArr(i) = recall;
    f_scoreArr(i) = f_score;
    jitterArr(i) = jitter;

    
end

avgPrecision = sum(precisionArr) / length(precisionArr);
avgRecall = sum(recallArr) / length(recallArr);
avgF_score = sum(f_scoreArr) / length(f_scoreArr);
avgJitter = sum(jitterArr) / length(jitterArr);

loss = (1 - avgF_score);
