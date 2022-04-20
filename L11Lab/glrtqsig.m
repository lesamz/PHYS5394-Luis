function glrtVal = glrtqsig(dataVec,psdVec,sigParams)
% Compute GLRT when only the signal amplitude is unknown. 
% GLRT = GLRTQSIG(Y,PSD,PARAMS)
% Compute the Generalized Likelihood Ratio Test (GLRT) for a quadratic 
% chirp signal with unknown amplitude. 
% Y is an M-by-2 matrix containing the time samples and the corresponding
% data (signal + noise) values in the first and second columns respectively.
% PSD is an N-by-2 matrix containing the DFT frequencies and the 
% corresponding PSD values in the first and second columns respectively. 
% PARAMS is the vector [a1 a2 a3] that parametrize the quadratic chirp signal. 

% Luis E. Salazar-Manzano, Apr 2022

dataTime = dataVec(1,:);
dataVals = dataVec(2,:);
psdFreq = psdVec(1,:);
psdVals = psdVec(2,:);

nSamples = length(dataTime);
sampFreq = (nSamples-1)/dataTime(end);

A = 1; % the amplitude used does not matter due to the normalization

% Generate a quadratic chirp signal
sigVec = crcbgenqcsig(dataTime,A,[sigParams(1),sigParams(2),sigParams(3)]);

% Generate the unit norm signal (i.e., template)
[templateVec,~] = normsig4psd(sigVec,sampFreq,psdVals,1); 

% Calculate inner product of data with template
llr = innerprodpsd(dataVals,templateVec,sampFreq,psdVals);

% GLRT is the square 
glrtVal = llr^2;

end
