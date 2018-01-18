close all;
clear all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")

[mfilt_sig, array_post, noisy_sig_post, std_post] = Post_fct(a5c3ecg, 10, 4, 1);
%change median sample size as one of the inputs