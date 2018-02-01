function [  ] = plotResult( detrended, R_loc, validLocs, fs )
%PLOTRESULT Summary of this function goes here
%   Detailed explanation goes here

time = 0:(1/fs):((length(detrended)-1)/fs);


figure;
bx1 = subplot(2,1,1);
hold on;
plot (time,detrended);
plot(time(R_loc),detrended(R_loc),'rv','MarkerFaceColor','r')
legend('ECG','R');
title('ECG Signal with R points');
xlabel('Time in seconds');
ylabel('Amplitude');


bx2 = subplot(2,1,2);
interval = diff(R_loc); % Period
interval(length(interval)+1) = interval(length(interval)); % Adding one last index
interval = interval./fs;
%dlmwrite(file+".ibi",transpose(periodsSecs));
interval = interval.^-1;
interval = interval.*60; % To get BPM
interval(isinf(interval)) = -2;

f=fit(transpose(time(R_loc)),transpose(interval),'smoothingspline');
plot(f,time(R_loc),interval);

%plot(time,full);
% plot(1:length(interval),interval);
title("Tachogram - Kota - ");
ylabel("Beats per minute");
xlabel("Time (s)");
ylim([100 200]);

linkaxes([bx1,bx2],'x')


end

