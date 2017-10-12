function printHRV(ecg, peaks,fs,titleString)

interval = diff(peaks);
interval = interval.^-1;
interval = interval * fs;
interval = interval * 60;

time = 0:(1/fs):((length(ecg)-1)/fs);

figure;
subplot(2,1,1);
plot(time, ecg);
title("Raw Signal " + titleString);
ylabel("Voltage");

subplot(2,1,2);
plot(1:length(interval),interval);
title("Heart Rate " + titleString);
ylabel("BPM");

end