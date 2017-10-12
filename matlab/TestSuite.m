close all;

ecgFile = "G002ecg.mat";
load(ecgFile);
sig = transpose(a2f1ecg);
fs = 1000;


[~,locs_Rwave] = findpeaks(sig,'MinPeakHeight',0.0005,'MinPeakDistance',200);   
printHRV(sig, locs_Rwave, fs, "Unfiltered Signal - " + ecgFile);


[~,qrs_i_raw,~] = pan_tompkin(sig,fs,0); % Set last param to 1 for plots
printHRV(sig, qrs_i_raw, fs, "Pan & Tompkins Algorithm - " + ecgFile);


[peaks] = kotaFunction(sig, fs);
printHRV(sig, peaks, fs, "Base Kota - " + ecgFile);