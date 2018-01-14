function [mfilt_sig,d]=median_fct(R_loc,interval, time, fs)

BPM = 60*fs./(interval);

figure;
subplot(3,1,1);
plot(time(R_loc), BPM);
%axis([0 R_loc(length(R_loc)/1000) 0 200]);
axis([0 4500 0 400]);
title('G011ecg BPM');
xlabel('Time (s)');

subplot(3,1,2);
mfilt_sig = medfilt1(BPM,5);
plot (time(R_loc), mfilt_sig);
axis([0 4500 0 400]);
title('Median filtered BPM');
xlabel('Time (s)');
for i = 1:length(R_loc)
    d(i) = BPM(i) - mfilt_sig(i);
%     if d(i) > 700
%         i
%         interval(i)
%         mfilt_sig(i)
%     end
end
subplot(3,1,3);
plot (time(R_loc), d);
title('Removed anomalies');
xlabel('Time (s)');
axis([0 4500 -200 400]);

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