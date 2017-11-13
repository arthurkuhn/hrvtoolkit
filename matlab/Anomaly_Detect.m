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
[ R_loc, interval, time ] = kotaFunction3(G002ecg, fs, 0 );
BPM = 60*fs./(interval);

figure;
subplot(3,1,1);
plot(time(R_loc), BPM);
%axis([0 R_loc(length(R_loc)) 0 700]);

subplot(3,1,2);
mfilt_sig = medfilt1(BPM,3);
plot (time(R_loc), mfilt_sig);
%axis([0 R_loc(length(R_loc)) 0 700]);

for i = 1:length(R_loc)
    d(i) = interval(i) - mfilt_sig(i);
end
subplot(3,1,3);
plot (time(R_loc), d);


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