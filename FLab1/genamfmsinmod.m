function sinVec = genamfmsinmod(dataT,snr,sigParams)
% Generate an AM-FM sinusoid
% S = GENAMFMSIN(T,SNR,SP)
% Generates an AM-FM sinusoid for the Statistical Methods Class. 
% T is the vector of time stamps at which the samples of the signal 
% are to be computed. SNR is the signal-to-noise ratio of S. 
% SP is a structure with the parameters SP.f0, SP.f1, SP.f2, SP.b of the signal, 
% where the frequency of the carrier signal SP.f0, the modulation frequency 
% SP.f1, the frequency of the amplitude modulation SP.f3, are given in Hz. The
% parameter SP.b is the frequency modulation index, which controls the amount 
% of frequency deviation. 
% The functional form of the AM-FM sinusoid is:
% S(T) = cos(2 pi SP.f2 T) × sin (2 pi SP.f0 T + SP.b cos(2 pi SP.f1 T) )
% If the conditions SP.f0>10*SP.f1 and SP.f1>SP.f2 are not met, the function 
% will output zeros. This constraint guarantees that the dominant 
% frequency of the signal is the carrier signal frequency and not 
% the frequencies of the modulations.

%Luis E. Salazar-Manzano, Apr 2022

if sigParams.f0 >= 10*sigParams.f1 && sigParams.f1 > sigParams.f2
    sinVec = cos(2*pi*sigParams.f2*dataT).*sin(2*pi*sigParams.f0*dataT+sigParams.b*cos(2*pi*sigParams.f1*dataT));
    sinVec = snr*sinVec/norm(sinVec);
else
    sinVec = zeros(length(dataT));
end




