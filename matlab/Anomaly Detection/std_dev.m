function [array,noisy_sig, s]=std_dev(sig,threshold, window)

index=0;
s = zeros(1,length(sig));
array = [];
noisy_sig = [];


for i = floor(1*window)/2+1:length(sig)-window/2 %0 to #samples; one i is 1/fs
   s(i) = std(sig(i-floor(window/2):i+(window/2)));
   
   % 0.09 for G002, 0.11 for a2f1, 0.145 for a5c3
    if (s(i)>threshold)
        index = index+1;
        array(index)= i; %take middle window value
    end
end

% array = find(s>threshold);
% noisy_sig = sig(array);

%same values as signal at noisy times 
 for i = 1:length(array)
     noisy_sig(i) = sig(array(i));
 end


