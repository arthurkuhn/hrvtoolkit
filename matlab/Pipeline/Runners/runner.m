close all;
clear all;


% Loading 
[ sig, fs ] = loadSig(2); % Choose a signal number between 1 & 6 (see loadSig function)

% Pre-processing
[ sig, detrended ] = preprocessingNew(sig, fs);

% Kota
[ R_loc, R_value ] = kota(sig, detrended);

% Post-processing
[ cleanTachogram, noisyBeats ] = postprocessingFunc(sig, fs);