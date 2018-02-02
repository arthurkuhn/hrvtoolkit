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
[ R_loc ] = kota(sig, detrended);

validLocs = ones(1,length(R_loc));

windowSize = 100;
[ validLocs ] = ensembleMethods(detrended, R_loc, validLocs, windowSize);

BPM = getBpm(R_loc, validLocs);

% Post-processing
%[ cleanTachogram, noisyBeats , std, diff] = post_proc(detrended, sig, BPM, R_loc, fs, 5);


% plotResult( detrended, R_loc, validLocs, fs );




