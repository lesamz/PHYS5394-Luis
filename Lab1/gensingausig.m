function sigVec = gensingausig(dataT,sn,sigParams)
% Generate a Sine-Gaussian signal
% S = GENSINGAUSIG(T,SNR,PARAMS)
% Generates an Sine-Gaussian signal for the Statistical Methods Class. 
% T is the vector of time stamps at which the samples of the signal 
% are to be computed. SNR is the signal-to-noise ratio of S. 
% PARAMS are the parameters [A,t0,sig,f0,phi0] of the signal. 
% The frequency f0 is given in Hz.

%Luis E. Salazar-Manzano, Feb 2022

sigVec = sigParams(1)*exp(-(dataT-sigParams(2)).^2/(2*sigParams(3)^2)).*sin(2*pi*sigParams(4)*dataT+sigParams(5));
sigVec = sn*3.3*sigVec/norm(sigVec);



