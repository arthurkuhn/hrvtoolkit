function [ sig, fs ] = loadSig( sigNum )
%LOADSIG Loads a signal from our limited dataset
%   Detailed explanation goes here

fs = 1000;


if(sigNum==1)
    load("a5c3ecg.mat") % visible bradycardia
    sig = transpose(a5c3ecg);
    sig = sig.*100;
    sig = -sig;
elseif(sigNum==2)
    load("G002ecg.mat") % Heavy bias, brady -> 5 missed beats
    sig = transpose(G002ecg);
elseif(sigNum==3)
    load("A1ecg.mat") % Faint
    sig = transpose(A1ecg);
    sig = sig.*100;
    sig = -sig;
elseif(sigNum==4)
    load("a2f1ecg.mat") % Some Missed beats -> Tweak
    sig = transpose(a2f1ecg);
    sig = sig.*100;
elseif(sigNum==5)
    load("G011ecg.mat")
    sig = transpose(G011ecg);
    sig = sig.*100;
elseif(sigNum==6)
    load("G013ecg.mat")
    sig = transpose(G013ecg);
    sig = sig.*100;
    sig = -sig;
end

end

