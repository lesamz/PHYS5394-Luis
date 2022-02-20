function sigVec = gensingausig(dataT,sn,sigParams)
% Generate a Sine-Gaussian signal
% S = GENSINGAUSIG(T,SNR,PARAMS)
% Generates a Sine-Gaussian signal. 
% T is the vector of time stamps at which the samples of the signal 
% are to be computed. SNR is the signal-to-noise ratio of S. 
% PARAMS are the parameters [A,t0,sig,f0,phi0] of the signal.
%FIXME Add definitions of the parameters (t0, ...) and what roles they play
%in the signal formula.
%FIXME parameter name 'sig' is ambiguous: normally one would assume it to
%mean 'signal'. 
%FIXME parameter A is not needed since it is normalized away
% The frequency f0 is given in Hz.

%Luis E. Salazar-Manzano, Feb 2022

sigVec = sigParams(1)*exp(-(dataT-sigParams(2)).^2/(2*sigParams(3)^2)).*sin(2*pi*sigParams(4)*dataT+sigParams(5));
sigVec = sn*3.3*sigVec/norm(sigVec);



