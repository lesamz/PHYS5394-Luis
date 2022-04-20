clear all
close all
clc
%% Generation of signal and data

% Signal function path
addpath('../L3Lab')

% Target SNR for the Signal
snr = 10;

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

% We will use the noise PSD used in colGaussNoiseDemo.m but add a constant
% to remove the parts that are zero. 
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;

% Generate the PSD vector to be used in the normalization. Should be
% generated for all positive DFT frequencies. 
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

% Calculation of the norm
% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdPosFreq);
% Normalize signal to specified SNR
sigVecNorm = snr*sigVec/sqrt(normSigSqrd);  

% Generate noise
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
% Generate data
dataVec = noiseVec + sigVecNorm;

figure;
plot(timeVec,dataVec,':o','LineWidth',1,'MarkerSize',2,'Color',[0 0 0]);
hold on;
plot(timeVec,sigVecNorm,':o','LineWidth',1,'MarkerSize',2,'Color',[0.6350 0.0780 0.1840]);
ylabel('Values','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
legend({'Data (Signal + Noise)', 'Signal'},'Interpreter','latex','FontSize',14,'Location','best');
title(sprintf('Time series'),'Interpreter','latex','FontSize',20);
grid on;

%%
% Generate periodogram of the signal and the data
[fftSig,posFreqSig] = genprdgrm(timeVec,sigVecNorm); % Signal
[fftData,posFreqData] = genprdgrm(timeVec,dataVec); % Data

% Plot periodogram
figure;
plot(posFreqData, fftData,':o','LineWidth',1,'MarkerSize',2,'Color',[0 0 0]);
hold on;
plot(posFreqSig, fftSig,':o','LineWidth',1,'MarkerSize',2,'Color',[0.6350 0.0780 0.1840]);
xlim([posFreqSig(1) posFreqSig(end)]);
ylabel('Magnitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
legend({'Data (Signal + Noise)','Signal'},'Interpreter','latex','FontSize',14,'Location','best');
title(sprintf('Periodogram'),'Interpreter','latex','FontSize',20);
grid on;

%%
% Generate spectrograms of the signal and data 
winSmpls = 100; % number of samples in the window 
ovrlptg = 0.5; % overlap as percentage of the windows
ovrlpSmpls = floor(winSmpls*ovrlptg); % number of samples in the overlap
[specFTSig,specFreqSig,specTimeSig] = spectrogram(sigVecNorm,winSmpls,ovrlpSmpls,[],sampFreq); % Signal
[specFTData,specFreqData,specTimeData] = spectrogram(dataVec,winSmpls,ovrlpSmpls,[],sampFreq); % Data

% spectrogram of the signal
figure;
subplot(2,1,1);
imagesc(specTimeSig,specFreqSig,abs(specFTSig)); 
%surf(T,F,abs(S)); 
axis xy;
ylabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title('Spectrogram of the signal','Interpreter','latex','FontSize',20);
colormap turbo;
colorbar;
% spectrogram of the data 
subplot(2,1,2);
imagesc(specTimeData,specFreqData,abs(specFTData)); 
%surf(T,F,abs(S)); 
axis xy;
ylabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title('Spectrogram of the data','Interpreter','latex','FontSize',20);
colormap turbo;
colorbar;

%% Functions 

% Generate a periodogram
function [fftSig,posFreq] = genprdgrm(dataT,dataI)
    % DFT frequency spacing 
    freqSpac = 1/(dataT(end)-dataT(1));
    % Limit index of the FFT positive half
    kNyq = floor(length(dataT)/2)+1;
    % Frequency index k
    kIndx = 0:(kNyq-1);
    % Positive Fourier frequencies
    posFreq = kIndx*freqSpac;
    % FFT of the signal
    fftSig = fft(dataI);
    % Discard negative / Extract positive frequencies
    fftSig = fftSig(1:kNyq);
    % Magnitudes of positive frequencies / Periodogram
    fftSig = abs(fftSig);
end