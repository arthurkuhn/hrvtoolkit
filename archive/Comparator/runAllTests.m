function runAllTests( sig, fs, ecgFile)
%RUNALLTESTS Summary of this function goes here
%   Detailed explanation goes here

[~,qrs_i_raw_pt,~] = pan_tompkin(sig,fs,0); % Set last param to 1 for plots
[~,qrs_i_raw_kota] = kotaFunction2(sig,fs,0); % Set last param to 1 for plots

time = 0:(1/fs):((length(sig)-1)/fs);

figure;
ax1 = subplot(3,1,1);
plot(time, sig);
title("Raw Signal " + ecgFile);
ylabel("Voltage");
xlabel("seconds");

interval = diff(qrs_i_raw_pt);
interval = interval.^-1;
interval = interval * fs;
interval = interval * 60;

ax2 = subplot(3,1,2);
plot(1:length(interval),interval);
title("Heart Rate P&T");
ylabel("BPM");
ylim([50 250]);

interval = diff(qrs_i_raw_kota);
interval = interval.^-1;
interval = interval * fs;
interval = interval * 60;

ax3 = subplot(3,1,3);
plot(1:length(interval),interval);
title("Heart Rate Kota (non-adaptive) threshold");
ylabel("BPM");
ylim([50 250]);

linkaxes([ax1,ax2, ax3],'x')


end


% [~,locs_Rwave] = findpeaks(sig,'MinPeakHeight',-0.5,'MinPeakDistance',200);   
% interval = diff(locs_Rwave);
% interval = interval.^-1;
% interval = interval * fs;
% interval = interval * 60;
% plot(1:length(interval),interval);
% title("Heart Rate peak detection");
% ylabel("BPM");
