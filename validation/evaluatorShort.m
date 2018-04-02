clear all;
close all;

fprintf("Running Algorithm ");

numSamples = 500000;
record = 'infant1_ecg';

result = hrvDetect(record, 'n_sample_start', 1 , ...
    'n_sample_end', numSamples, ...
    'ensemble_filter_threshold', 0.1, ...
    'mad_filter_threshold', 20, ...
    'missed_beats_tolerance_percent', 20, ...
    'median_filter_window', NaN, ...
    'interpolation_method','direct', ...
    'smoothing_spline_coef', 0.9);

R_locs = result.R_locs;
fs = result.fs;
maxDeviation = fs / 40;  % Quarter of a second is max deviation


fprintf("Getting Valid Data ");

% Get the official annotations:
[R_locs_valid, ecg_sig] = getOfficialResultsShort( record, numSamples );
%R_locs_valid = rdann(record,'qrsc',[],numSamples);
time = 0:(1/fs):((length(ecg_sig)-1)/fs);

index = 1;
n_missedBeats = 0;
n_extraBeats = 0;
n_acceptable = 0;
jitter = [];

fprintf("Starting Comparison ");

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



figure;
bx1 = subplot(2,2,1);
hold on;
plot (timeMinutes,ecg_sig);
plot (timeMinutes(R_locs),ecg_sig(R_locs),'rv','MarkerFaceColor','r');
legend('ECG','R - Detected', 'R - Valid');
title('ECG Signal with Computed R points');
xlabel('Time in Minutes');
ylabel('Amplitude');
ylim([-1 2]);

bx2 = subplot(2,2,3);
hold on;
plot (timeMinutes,ecg_sig);
plot (timeMinutes(R_locs_valid),ecg_sig(R_locs_valid),'bv','MarkerFaceColor','b');
legend('ECG', 'R - Valid');
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
plot (timeMinutes,result.heartRate);
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