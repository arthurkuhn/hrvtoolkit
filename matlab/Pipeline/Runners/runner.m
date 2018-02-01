close all;
clear all;
% 1: a5c3
% 2: G002
% 3: A1
% 4: a2f1
% 5: G011
% 6: G013

% Loading 
[ sig, fs ] = loadSig(1); % Choose a signal number between 1 & 6 (see loadSig function)

% Pre-processing
[ sig, detrended ] = preprocessingNew(sig, fs);

% Kota
[ R_loc, R_value ] = kota(sig, detrended);

% Post-processing
[ cleanTachogram, noisyBeats ] = post_proc(sig, R_loc, fs, 5);

%[ cleanTachogram, noisyBeats ] = postprocessingFunc(R_loc, fs);

% plotEnsemble( detrended, R_loc, 200)

% windowSize = 100;
% %[ avg ] = getEnsembleAverage(detrended, R_loc, windowSize);
% [ avg ] = plotEnsemble(detrended, R_loc, windowSize);
% 
% filterWithEnsemble(detrended, R_loc, avg, windowSize);