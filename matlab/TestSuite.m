close all;

ecgFile = "a2f1ecg.mat";
load(ecgFile);
sig = a2f1ecg;
fs = 1000;
time = 1:(1/fs):((length(sig)-1)/fs);


figure;
plot(time,sig);
title("Raw ECG");

figure;
plot(

