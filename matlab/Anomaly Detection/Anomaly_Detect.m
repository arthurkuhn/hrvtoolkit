%% Noise Anomaly Detection %%

figure;
fs = 1000;
%plot(time(R_loc), interval);
diff_v = diff(interval);
R_loc2 = R_loc;
R_loc2(:,length(R_loc2)) = [];
index = 0;
plot(time(R_loc2), diff_v);
for i = 1:length(diff_v)
    if diff_v > 25
        index = index + 1;
        array(index)= i;
   end
end


for i = 1:length(array)
     noisy_sig(i) = Interval(array(i));
end