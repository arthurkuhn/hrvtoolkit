function [ validLocs ] = medFilter( s, validLocs, tau )
%medFilter Finds the outliers in the signal using a median filter
% Skips beats already marked as invalid (and does not take them into
% account for the other points.
%
% Inputs:
%    signal - The RR-interval data
%    validLocs - Boolean Array, 1 for valid peaks
%    tau - Parameter
%
% Outputs:
%    validLocs - Boolean Array, 1 for valid peaks
%
% Reference:
% Thuraisingham, R. A. (2006). "Preprocessing RR interval time
% series for heart rate variability analysis and estimates of
% standard deviation of RR intervals."
% Comput. Methods Programs Biomed.

sM=median(s);
med=median(abs(s-sM));
D=abs(s-sM)./(1.483*med);
outliers=D>tau;


end

