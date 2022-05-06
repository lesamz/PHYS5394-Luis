function glrtVal = fitglrtqcsig(x,params)
% Fitness values for quadratic chirp regression
% G = FITGLRTQCSIG(X,P)
% Fitness values (log-likelihood ratio for colored noise 
% maximized over the amplitude parameter) for data containing the
% quadratic chirp signal at the parameter values in X. 
% The fitness values are returned in G. 
% X is standardized, that is 0<=X(i,j)<=1. 
% The fields P.dataY and P.dataX have the data and its
% time stamps. The fields P.dataXSq and P.dataXCb contain the timestamps
% squared and cubed respectively. The fields P.psdY and P.psdX have the 
% colored noise PSD and its frequencies.

% Luis E. Salazar-Manzano, May 2022

% Generate normalized quadratic chirp
phaseVec = x(1)*params.dataX + x(2)*params.dataXSq + x(3)*params.dataXCb;
qc = sin(2*pi*phaseVec);

% Generate the unit norm signal (i.e., template)
[templateVec,~] = normsig4psd(qc,params.sampFreq,params.psdY,1); 
% Calculate inner product of data with template
llr = innerprodpsd(params.dataY,templateVec,params.sampFreq,params.psdY);
% Compute fitness, GLRT is the square 
glrtVal = -llr^2; 

end
