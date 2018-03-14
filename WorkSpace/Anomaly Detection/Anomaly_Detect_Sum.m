%% Noise Anomaly Detection %%
close all;
clear all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")
load("G011ecg.mat")
G011ecg = data;
load("G013ecg.mat")
G013ecg = data;
fs = 1000;
allowedDeviation = 0.10; % 10%
index=0;
[ R_loc, interval, time ] = kotaFunction3(G002ecg, fs, 0 );

for i = 2:length(R_loc)-1
    % double of 2 adjacent hardbeats: missed peak
    sumPrevNext = interval(i-1) + interval(i+1);
    deviation = allowedDeviation * sumPrevNext;
%     if (interval(i)>(interval(i-1)+interval(i+1)-50)) && (interval(i)<(interval(i-1)+interval(i+1)+50));
%         index=index+1;
%         false(index) = i;
%     end
    if(interval(i) > (sumPrevNext - deviation) && interval(i) < (sumPrevNext + deviation))
        index=index+1;
        false(index) = i;
    end
end

% for i = 2:length(false)
%     false_loc(i) = R_loc(false(i-1));
%     noisy_sig(i) = interval(i);
% end

for i = 1:length(false)-1
    false_loc(i) = R_loc(false(i));
    noisy_sig(i) = interval(false(i));
end

false_loc = false_loc./fs;
BPM = 60*fs./(interval);

figure;
subplot(2,1,1);
plot(time(R_loc), interval);
%axis([0 R_loc(length(R_loc)) 0 700]);

subplot(2,1,2);
plot(time(R_loc), interval);
hold on
scatter(false_loc, noisy_sig,10,'r');

% plot (time(R_loc), mfilt_sig);
%axis([0 R_loc(length(R_loc)) 0 700]);

% for i = 1:length(R_loc)
%     d(i) = interval(i) - mfilt_sig(i);
% end
% subplot(3,1,3);
% plot (time(R_loc), d);


% diff_v = diff(interval);
% R_loc2 = R_loc;
% R_loc2(:,length(R_loc2)) = [];
% index = 0;
% plot(time(R_loc2), diff_v);
% for i = 1:length(diff_v)
%     if diff_v > 25
%         index = index + 1;
%         array(index)= i;
%     end
% end
% for i = 1:length(array)
%      noisy_sig(i) = Interval(array(i));
% end