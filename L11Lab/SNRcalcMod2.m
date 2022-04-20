clear all
close all
clc
%% How to normalize a signal for a given SNR
% We will normalize a signal such that the Likelihood ratio (LR) test for it has
% a given signal-to-noise ratio (SNR) in noise with a given Power Spectral 
% Density (PSD). [We often shorten this statement to say: "Normalize the
% signal to have a given SNR." ]

%% Generation of signal and data

% Signal function path
addpath('../L3Lab');

% Target SNR for the LR
snr = 5;

% Data generation parameters
nSamples = 2048;
sampFreq = 1024;
sampIntrvl = 1/sampFreq;
timeVec = (0:(nSamples-1))*sampIntrvl;

% Parameters of the signal to be normalized 
f0 = 50;
f1 = 2.2;
f2 = 2;
b = 5;
A = 1; % Amplitude does not matter as it will be changed in the normalization

% Generate the signal
sigVec = genamfmsin(timeVec,A,[f0,f1,f2,b]);

% We will use the LIGO sensitivity as the noise PSD to be used in the normalization 
importFile = load('iLIGOSensitivity.txt','-ascii'); % power spectral density (PSD)
fileFreq = importFile(:,1); % vector of frequencies
fileSenst = importFile(:,2); % vector of sensitivity values

freqVecL = 0:50; % low frequency part 
freqVecR = fileFreq(fileFreq>50)'; % frequencies of interest
freqVec = [freqVecL freqVecR]; % modified vector of frequencies

idL = find(fileFreq == freqVecR(1)); % index of 50 Hz
senstVecL = ones(1,length(freqVecL))*fileSenst(idL); % low frequency part
senstVec = [senstVecL fileSenst(idL:end)']; % modified vector of sensitivity values

dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);

%Interpolate LIGO Sensitivity to DFT frequencies
psdPosFreq = interp1(freqVec,senstVec,posFreq);

% Calculation of the norm
% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdPosFreq);
% Normalize signal to specified SNR
sigVecNorm = snr*sigVec/sqrt(normSigSqrd);  

%% Test
%Obtain log-likelihood ratio (LLR) values for multiple noise realizations
nH0Data = 1000;
llrH0 = zeros(1,nH0Data);
for lp = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    llrH0(lp) = innerprodpsd(noiseVec,sigVecNorm,sampFreq,psdPosFreq);
end
%Obtain LLR for multiple data (=signal+noise) realizations
nH1Data = 1000;
llrH1 = zeros(1,nH1Data);
for lp = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    % Add normalized signal
    dataVec = noiseVec + sigVecNorm;
    llrH1(lp) = innerprodpsd(dataVec,sigVecNorm,sampFreq,psdPosFreq);
end
%%
% Signal to noise ratio estimate
estSNR = (mean(llrH1)-mean(llrH0))/std(llrH0);

figure;
histogram(llrH0,'FaceColor',[0.6350 0.0780 0.1840]);
hold on;
histogram(llrH1,'FaceColor',[0.4660 0.6740 0.1880]);
xlabel('Log-Likelihood Ratio','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
ylabel('Counts','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
legend({'Null hypothesis $H_{0}$ (no detection)','Alternative hypothesis $H_{1}$ (signal detection)'},'Interpreter','latex','FontSize',14,'Location','best');
title(['Estimated SNR = ',num2str(estSNR)],'Interpreter','latex','FontSize',20);