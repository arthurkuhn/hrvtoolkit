%% Runs 2 algorithms and keeps only matching detections %%

close all;
clear all;
load("G002ecg.mat")
load("A1ecg.mat")
load("a2f1ecg.mat")
load("a5c3ecg.mat")

fs = 1000;
orig_sig = G002ecg;
orig_sig = orig_sig.*1000; %to see variations

filt = BP(); % Band pass from 16 to 26 Hz
filt_sig = filter(filt, orig_sig); % new signal

time = 0:(1/fs):((length(filt_sig)-1)/fs); %time in seconds
window = 1*fs; % # of secs
%threshold = 0.09;
% 0.09 for G002, 0.11 for a2f1, 0.145 for a5c3
%[array_ecg,noisy_sig_ecg, s] = std_dev(filt_sig, 0.09, window);

[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(orig_sig,1000,0);
[R_loc]=kotaFunction3(orig_sig,1000,0);
pt = 1;
k = 1;
m = 1; %matching index
while (pt < length(qrs_i_raw) | k < length(R_loc))
    % match: increment both
    if (qrs_i_raw(pt) <= (R_loc(k) + 5) & qrs_i_raw(pt) >= (R_loc(k) - 5))
        match(m) = R_loc(k);
        m = m+1;
        if (pt < length(qrs_i_raw))
        pt = pt+1;
        end
        if (k < length(R_loc))
        k = k+1;
        end
        
    %no match: increment smallest of the 2
    else
        if (pt < k)
            if (pt < length(qrs_i_raw))
            pt = pt+1;
            end
        else
            if (k < length(R_loc))
            k = k+1;
            end;
        end;
    end;
end;


        %increment le plus bas des 2 si ca match
        %les deux si ca match
    
    % for i = 2:length(full)
%     if full(i) == 0
%         full(i) = full(i-1);
%     end
% end


