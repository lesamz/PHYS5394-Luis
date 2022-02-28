function sigVec = gensingausig(dataT,sn,sigParams)
% Generate a Sine-Gaussian signal
% S = GENSINGAUSIG(T,SNR,PARAMS)
% Generates a Sine-Gaussian signal. 
% T is the vector of time stamps at which the samples of the signal 
% are to be computed. SNR is the signal-to-noise ratio of S. 
% PARAMS are the parameters [t0,stdv,f0,phi0] of the signal.
% Where t0 and stdv define the center and width of the Gaussian envelope, 
% while f0 and phi0 control the frequency and phase of the sinusoidal 
% oscillation. The frequency f0 is given in Hz and the center t0 in seconds.
% The functional form of the Sine-Gaussian signal is:
% S(T) = exp (-(T - t0)^2 / (2 stdv^2)) sin (2 pi f0 T + phi0) 

%Luis E. Salazar-Manzano, Feb 2022

sigVec = exp(-(dataT-sigParams(1)).^2/(2*sigParams(2)^2)).*sin(2*pi*sigParams(3)*dataT+sigParams(4));
sigVec = sn*sigVec/norm(sigVec);



