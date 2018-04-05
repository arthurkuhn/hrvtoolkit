function [ precision, recall, f_score, jitter ] = compareWithPhysio( record, result, numSamples, maxDeviationMs, shouldPlot )
%COMPAREWITHPHYSIO Summary of this function goes here
%   Detailed explanation goes here
%       compareWithPhysio('infant1_ecg', result, 500000, 15, 1)

R_locs = result.R_locs;
fs = result.fs;
maxDeviation = maxDeviationMs * 1000 / fs;

% No result from our algo
if(isempty(R_locs))
    precision = 0;
    recall = 0;
    f_score = 0;
    jitter = 0;
    return;
end

% Get the official annotations:
[R_locs_valid, ecg_sig] = getOfficialResultsShort( record, numSamples );
time = 0:(1/fs):((length(ecg_sig)-1)/fs);

index = 1;
n_missedBeats = 0;
n_extraBeats = 0;
n_acceptable = 0;
jitter = [];


for i=1:length(R_locs_valid)
    matched = false;
    validBeatPos = R_locs_valid(i);
    while(~matched)
        % Overflow, we continue
        if(index > length(R_locs))
            n_missedBeats = n_missedBeats + 1;
            matched = true;
            break;
        end
        calculatedBeatPos = R_locs(index);
        deviation = abs(validBeatPos - calculatedBeatPos);
        if(deviation < maxDeviation)
            n_acceptable = n_acceptable + 1;
            jitter(n_acceptable) = deviation;
            index = index + 1;
            matched = true;
        elseif(calculatedBeatPos < validBeatPos)
            n_extraBeats = n_extraBeats + 1;
            index = index + 1;
        else
            n_missedBeats = n_missedBeats + 1;
            matched = true;
        end
    end
end

timeMinutes = time./60;

% Make the interval array with the Official beats
interval_valid = diff(R_locs_valid);
BPM_valid = 60*fs./(interval_valid);
interval_locs_valid = R_locs_valid(1:end-1);
interpolated = interp1(R_locs,result.tachogram,1:length(ecg_sig),'spline');


if(shouldPlot == 1)
    figure;
    bx1 = subplot(2,2,1);
    hold on;
    plot(timeMinutes,ecg_sig);
    plot(timeMinutes(R_locs),ecg_sig(R_locs),'rv','MarkerFaceColor','r');
    legend('ECG','R - Detected', 'R - Valid');
    title('ECG Signal with Computed R points','FontSize',20);
    xlabel('Time in Minutes');
    ylabel('Amplitude');
    ylim([-1 2]);

    bx2 = subplot(2,2,3);
    hold on;
    plot (timeMinutes,ecg_sig);
    plot (timeMinutes(R_locs_valid),ecg_sig(R_locs_valid),'bv','MarkerFaceColor','b');
    legend('ECG', 'R - Valid');
    lgd.FontSize = 22;
    title('ECG Signal with Valid R points');
    xlabel('Time in Minutes');
    ylabel('Amplitude');
    ylim([-1 2]);


    %Make the same length (the last beat is discarded in our algo)
    if(length(result.tachogram) == length(R_locs) - 1)
        result.tachogram(length(result.tachogram) + 1) = result.tachogram(length(result.tachogram));
    end

    bx3 = subplot(2,2,2);
    hold on;
    plot(timeMinutes,result.heartRate);
    scatter (timeMinutes(result.noisyIntervals),interpolated(result.noisyIntervals), ...
            'MarkerEdgeColor','r',...
            'MarkerFaceColor','r',...
            'LineWidth',0.1);
    legend('Tachogram', 'Locations where collected data was deemed noisy');
    title('Tachogram');
    xlabel('Time in Minutes');
    ylabel('BPM');
    ylim([100 200]);


    bx4 = subplot(2,2,4);
    hold on;
    plot (timeMinutes(interval_locs_valid),BPM_valid);
    legend('Tachogram');
    title('Expected Tachogram');
    xlabel('Time in Minutes');
    ylabel('BPM');
    ylim([100 200]);
    linkaxes([bx1,bx2],'xy');
    linkaxes([bx3,bx4],'xy');
    linkaxes([bx1,bx2,bx3,bx4],'x');

    averageDeviation = sum(jitter)/length(jitter);
    figure;
    hist(jitter);
end
precision = n_acceptable / length(R_locs);
recall = n_acceptable / length(R_locs_valid);
f_score = 2 * (precision * recall) / (precision + recall) ;
avg_jitter = sum(jitter)/length(jitter);

if(isnan(f_score))
    f_score = 0;
end
if(isnan(avg_jitter))
    avg_jitter = 0;
end

end

