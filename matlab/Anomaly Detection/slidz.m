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
sig = A1ecg;
[ R_loc, interval, time ] = kotaFunction3(sig, fs, 0);

ecgtime = 0:(1/fs):((length(sig)-1)/fs);
BPM = 60*fs./(interval);
%396
% figure;
% subplot(3,1,1);
% plot(ecgtime(170013:300000), sig(170013:300000));
% axis([170 300 -20*10^-4 5*10^-4]);
% %title('ECG Signal');
% xlabel('Time (s)');
% 
% subplot(3,1,2);
% plot(time(R_loc(396:683)), interval(396:683));
% axis([170 300 200 700]);
% %title('RR Interval');
% xlabel('Time (s)');
% %ylabel('Interval (ms)');
% 
% subplot(3,1,3);
% plot(time(R_loc(396:683)), BPM(396:683));
% axis([170 300 0 250]);
% %title('Beats per minute');
% xlabel('Time (s)');
% %ylabel('BPM');

%title('G011ecg BPM');
%xlabel('Time (s)');

figure;
subplot(2,1,1);
plot(time, sig);
xlabel('Time (s)');
%axis([0 4500 -5*10^-3 -0.4*10^-3]);
