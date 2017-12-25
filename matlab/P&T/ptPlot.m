close all;
clear all;
load("a5c3ecg.mat") % visible bradycardia
load("G002ecg.mat") % Heavy bias, brady -> 5 missed beats
load("A1ecg.mat") % Faint
load("a2f1ecg.mat") % Some Missed beats -> Tweak
fs = 1000;
file = "A1ecg";
sig = transpose(A1ecg);
orig_sig = sig;

[~,qrs_i_raw,~]=pan_tompkin(sig,fs,0);
time = 0:1/fs:(length(sig)-1)*1/fs;
figure;
ax1 = subplot(1,1,1);
hold on;
plot (time,orig_sig);
plot(time(qrs_i_raw),orig_sig(qrs_i_raw),'rv','MarkerFaceColor','r')
legend('ECG','R');
title('ECG Signal with R points');
xlabel('Time in seconds');
ylabel('Amplitude');
%xlim([1 6])
figure
ax3 = subplot(1,1,1);
interval = diff(qrs_i_raw); % Period
periods = interval; % For histogram
interval(length(interval)+1) = interval(length(interval)); % Adding one last index
interval = interval./fs;
interval = interval.^-1;
interval = interval.*60; % To get BPM
interval(isinf(interval)) = -2;

f=fit(transpose(time(qrs_i_raw)),transpose(interval),'smoothingspline');
plot(f,time(qrs_i_raw),interval);

%plot(time,full);
% plot(1:length(interval),interval);
title("Reconstructed HRV with P&T");
ylabel("Beats per minute");
xlabel("Time");
ylim([100 200]);

figure;
ax4 = subplot(1,1,1);
vel = diff(periods);
vel(length(vel)+1)=vel(length(vel));
vel(length(vel)+1)=vel(length(vel));
plot(time(qrs_i_raw),vel);
title("Changes in RR-Interval");
xlabel("Time (in s)");
ylabel("RR-Interval Change with previous beat (in ms)");

linkaxes([ax1, ax3, ax4],'x')


figure;
hold on
histogram(periods)
title("Distribution of RR-Intervals in recording: " + file);
xlabel("RR-Interval (in ms)");
ylabel("Frequency");
set(gca,'YScale','log')