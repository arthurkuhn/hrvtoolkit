
function [avg, complex2, r, cx ] = test_( detrended_sig, R_locs, windowSize )
%PLOTENSEMBLE Summary of this function goes here
%   Detailed explanation goes here
avg = zeros(1,(2*windowSize+1));

parfor i=1:length(R_locs)
    if(R_locs(i) < windowSize + 1)
        continue;
    end
    left = R_locs(i) - windowSize;
    right = R_locs(i) + windowSize;
    complex = detrended_sig(left:right);
    avg = avg + complex;
end

avg = avg./length(R_locs);

figure;
plot(1:length(avg),avg);
title("Ensemble average");

res = zeros(length(detrended_sig), 2*windowSize-1);

for i=1:length(R_locs-200)
    if(R_locs(i) < windowSize + 1)
        continue;
    end
    left = R_locs(i) - windowSize;
    right = R_locs(i) + windowSize;
    complex2 = detrended_sig(left:right);
    res(i) = xcorr(complex2, avg);
    cx = corrcoef(complex2, avg);
end

    figure;
    plot(1:length(r), r);

% t = 0:0.1:100;
% x = sin(t);
% y = 2*sin(t+pi);
% rxx = xcorr(x,x);
% rxy = xcorr(x,y);
% 
% cxx = corrcoef(x,x)
% cxy = corrcoef(x,y)
% 
% figure;
% subplot(3,1,1);
% plot(1:0.1:201, rxx);
% subplot(3,1,2);
% plot(1:0.1:201, rxy);
% %subplot(3,1,3);
% %plot(1:0.1:201,r);
% 
