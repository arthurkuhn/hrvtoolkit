close all;
% 1: a5c3
% 2: G002
% 3: A1
% 4: a2f1
% 5: G011
% 6: G013

% Loading 
[ sig, fs ] = loadSig(2); % Choose a signal number between 1 & 6 (see loadSig function)

% Pre-processing
[ sig, detrended ] = preprocessingNew(sig, fs);

% Kota
[ R_loc, R_value ] = kota(sig, detrended);

validLocs = ones(length(R_loc));

windowSize = 100;
[ validLocs ] = ensembleMethods(detrended, R_loc, validLocs, windowSize);

% Post-processing
% [array_post, noisy_sig_post, std_post, diff_sig, validLocs] = post_proc(detrended, sig, R_loc, fs, 5, validLocs, 1);

plotResult( detrended, R_loc, validLocs, fs );




