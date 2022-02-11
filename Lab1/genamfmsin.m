function sinVec = genamfmsin(dataT,sn,ampParams,frqParams)
% Generate an AM-FM sinusoid
% S = GENAMFMSIN(T,SNR,AMPS,FREQS)
% Generates an AM-FM sinusoid for the Statistical Methods Class. 
% T is the vector of time stamps at which the samples of the signal 
% are to be computed. SNR is the signal-to-noise ratio of S. 
% AMPS and FREQS parametrize the signal, AMPS is the vector 
% of amplitudes [A, b] and FREQS is the vector of frequencies in HZ 
% [f0, f1, f2]. If the conditions f0>10*f1 and f1>f2 are 
% not met, the function will output zeros.

%Luis E. Salazar-Manzano, Feb 2022

if frqParams(1) >= 10*frqParams(2) && frqParams(2) > frqParams(3)
    sinVec = ampParams(1)*cos(2*pi*frqParams(3)*dataT).*sin(2*pi*frqParams(1)*dataT+ampParams(2)*cos(2*pi*frqParams(2)*dataT));
    sinVec = sn*10*sinVec/norm(sinVec);
else
    sinVec = zeros(length(dataT));
end




