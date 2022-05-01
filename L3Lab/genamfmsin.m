function sinVec = genamfmsin(dataT,sn,sigParams)
% Generate an AM-FM sinusoid
% S = GENAMFMSIN(T,SNR,PARAMS)
% Generates an AM-FM sinusoid for the Statistical Methods Class. 
% T is the vector of time stamps at which the samples of the signal 
% are to be computed. SNR is the signal-to-noise ratio of S. 
% PARAMS is the vector [f0, f1, f2, b] that parametrize the signal, 
% where the frequency of the carrier signal f0, the modulation frequency 
% f1, the frequency of the amplitude modulation f3, are given in Hz. The
% parameter b is the frequency modulation index, which controls the amount 
% of frequency deviation. 
% The functional form of the AM-FM sinusoid is:
% S(T) = cos(2 pi f2 T) × sin (2 pi f0 T + b cos(2 pi f1 T) )
% If the conditions f0>10*f1 and f1>f2 are not met, the function 
% will output zeros. This constraint guarantees that the dominant 
% frequency of the signal is the carrier signal frequency and not 
% the frequencies of the modulations.

%Luis E. Salazar-Manzano, Feb 2022

if sigParams(1) >= 10*sigParams(2) && sigParams(2) > sigParams(3)
    sinVec = cos(2*pi*sigParams(3)*dataT).*sin(2*pi*sigParams(1)*dataT+sigParams(4)*cos(2*pi*sigParams(2)*dataT));
    sinVec = sn*sinVec/norm(sinVec);
else
    sinVec = zeros(length(dataT));
end




