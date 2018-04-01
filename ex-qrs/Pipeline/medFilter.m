function outliers = medFilter( s, tau )
%medFilter - Finds the outliers in the signal using a MAD filter
% Uses a Median absolute deviation filter to detect outliers.
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

