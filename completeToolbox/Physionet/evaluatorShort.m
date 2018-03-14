clear all;

record = "infant2_ecg";
proportion = 0.01; % Proportion of record that we want to evaluate

% General algorithm parameters:
ensembleFilter = struct('isOn', 1, 'threshold', 0.55);
madFilter = struct('isOn', 1, 'threshold', 5);
n_missedBeats = struct('isOn', 1, 'threshold', 20);
postProcessing = struct('ensembleFilter', ensembleFilter, 'madFilter', madFilter, 'missedBeats', n_missedBeats);
medianFilter = struct('isOn', 1, 'windowSize', 15);
tachoProcessing = struct('interpolationMethod', 'spline', 'medianFilter', medianFilter);
params = struct('ecgFile', record, 'postProcessing', postProcessing, 'tachoProcessing', tachoProcessing);

fprintf("Running Algorithm ");

% Get the algorithm results:
result = hrvDetectShort( params, proportion );
R_locs = result.R_locs;
fs = result.fs;
maxDeviation = fs / 40;  % Quarter of a second is max deviation


fprintf("Getting Valid Data ");

% Get the official annotations:
[R_locs_valid, ecg_sig] = getOfficialResultsShort( record, proportion );
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

bx2 = subplot(2,2,2);
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

bx3 = subplot(2,2,3);
hold on;
plot (timeMinutes(result.cleanIntervals),result.heartRate);
scatter (timeMinutes(result.cleanIntervals),result.heartRate, 'b');
legend('Tachogram', 'Valid Detected Beats');
title('Tachogram');
xlabel('Time in Minutes');
ylabel('BPM');
ylim([100 200]);


bx4 = subplot(2,2,4);
hold on;
plot (timeMinutes(result.cleanIntervals),result.heartRate);
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