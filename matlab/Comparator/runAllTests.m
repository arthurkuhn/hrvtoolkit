function runAllTests( sig, fs, ecgFile)
%RUNALLTESTS Summary of this function goes here
%   Detailed explanation goes here

[~,locs_Rwave] = findpeaks(sig,'MinPeakHeight',-0.5,'MinPeakDistance',200);   

[~,qrs_i_raw,~] = pan_tompkin(sig,fs,0); % Set last param to 1 for plots

[peaks] = kotaFunction(sig, fs);

time = 0:(1/fs):((length(sig)-1)/fs);

figure;
subplot(4,1,1);
plot(time, sig);
title("Raw Signal " + ecgFile);
ylabel("Voltage");
xlabel("seconds");

interval = diff(locs_Rwave);
interval = interval.^-1;
interval = interval * fs;
interval = interval * 60;

subplot(4,1,2);
plot(1:length(interval),interval);
title("Heart Rate peak detection");
ylabel("BPM");

interval = diff(qrs_i_raw);
interval = interval.^-1;
interval = interval * fs;
interval = interval * 60;

subplot(4,1,3);
plot(1:length(interval),interval);
title("Heart Rate P&T");
ylabel("BPM");

interval = diff(peaks);
interval = interval.^-1;
interval = interval * fs;
interval = interval * 60;

subplot(4,1,4);
plot(1:length(interval),interval);
title("Heart Rate Kota (non-adaptive) threshold");
ylabel("BPM");


end

