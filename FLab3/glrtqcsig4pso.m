function [fitVal,varargout] = glrtqcsig4pso(xVec,params)
% Compute the fitness function for quadratic chirp regression
% F = GLRTQCSIG4PSO(X,P)
% Compute the fitness function (log-likelihood ratio for colored noise 
% maximized over the amplitude parameter) for data containing the
% quadratic chirp signal at the parameter values in X.  
% The fitness values are returned in F. 
% X is standardized, that is 0<=X(i,j)<=1. 
% The fields P.rmin and P.rmax  are used to convert X(i,j) internally 
% before computing the fitness X(:,j) -> X(:,j)*(rmax(j)-rmin(j))+rmin(j).
% The fields P.dataY and P.dataX are used to transport the data and its
% time stamps. The fields P.dataXSq and P.dataXCb contain the timestamps
% squared and cubed respectively. The fields P.psdY and P.psdX have the 
% colored noise PSD and its frequencies. The field P.sampFreq has the 
% sampling frequency of the data.
%
% [F,R] = GLRTQCSIG4PSO(X,P)
% returns the quadratic chirp coefficients corresponding to the rows of X in R. 
%
% [F,R,S] = GLRTQCSIG4PSO(X,P)
% Returns the quadratic chirp signals corresponding to the rows of X in S.

% Modified from Soumya D. Mohanty
% June, 2011
% April 2012: Modified to switch between standardized and real coordinates.

% Shihan Weerathunga
% April 2012: Modified to add the function rastrigin.

% Soumya D. Mohanty
% May 2018: Adapted from rastrigin function.

% Soumya D. Mohanty
% Adapted from QUADCHIRPFITFUNC

% Luis E. Salazar-Manzano, May 2022

%==========================================================================

% Rows: points
% Columns: coordinates of a point
[nVecs,~]=size(xVec);

% Storage for fitness values
fitVal = zeros(nVecs,1);

% Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
% Set fitness for invalid points to infty
fitVal(~validPts)=inf;
xVec(validPts,:) = s2rv(xVec(validPts,:),params);

for lpc = 1:nVecs
    if validPts(lpc)
    % Only the body of this block should be replaced for different fitness
    % functions
        x = xVec(lpc,:);
        fitVal(lpc) = fitglrtqcsig(x, params); 
    end
end

% Return real coordinates if requested
if nargout > 1
    varargout{1}=xVec;
end
