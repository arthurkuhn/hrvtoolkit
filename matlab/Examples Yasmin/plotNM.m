function [ output_args ] = plotNm( S, TITLE, YLABEL,NX,NY, NPLT )
% Plot a stucutre in subplot (NX,NY,NPLT) with title TITLE
%% TITLE
% NX
% NY
% NPLT 
if nargin<6,
    NPLT=1;
end
if nargin<4,
    NX=1
    NY=1
end

subplot (NX,NY,NPLT);
plot(S.time,S.signals.values);
ylabel(YLABEL);
title(TITLE);

end

