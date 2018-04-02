function [ sig, fs ] = loadSig( sigNum )
%loadSig Loads a signal from our limited dataset
% Accepts an input in the range 1-6 correponding to the signals detailled
% below. Returns a signal ready for processing.
% 
% Signals:
%   1: a5c3
%   2: G002
%   3: A1
%   4: a2f1
%   5: G011
%   6: G013
%
% Process:
%   1. The signal is first formatted in a row vector.
%   2. The first minute of the signal is processed using our full 
%      pipeline. If necessary, the signal is reversed (see invertIfNeeded).
%
% Inputs:
%    sigNum - Index of the signal of interest
%
% Outputs:
%    sig - The raw ECG signal
%    fs - The sampling frequency

fs = 1000;
windowInSeconds = 60;

if(sigNum==1)
    load("a5c3ecg.mat") % visible bradycardia
    sig = transpose(a5c3ecg);
elseif(sigNum==2)
    load("G002ecg.mat") % Heavy bias, brady -> 5 missed beats
    sig = transpose(G002ecg);
elseif(sigNum==3)
    load("A1ecg.mat") % Faint
    sig = transpose(A1ecg);
elseif(sigNum==4)
    load("a2f1ecg.mat") % Some Missed beats -> Tweak
    sig = transpose(a2f1ecg);
elseif(sigNum==5)
    load("G011ecg.mat")
    sig = transpose(G011ecg);
elseif(sigNum==6)
    load("G013ecg.mat")
    sig = transpose(G013ecg);
end

sig = invertIfNecessary( sig, fs, windowInSeconds);

if(~isrow(sig))
    sig = sig.';
end

end

