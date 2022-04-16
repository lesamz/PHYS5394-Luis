clear all
close all
clc
%% Calculations

% Estimation of the Power Spectral Density (PSD) through the Welch's method 
% and whitening of data through the Wiener-Khinchin theorem   

% Import data file
importFile = load('testData.txt'); 

% Extract the noise part and find the sampling frequency
sampInts = diff(importFile(:,1)); % sampling intervals
noiseVecLim = sum(importFile(:,1)<5); % Find the length of the noise vector 
% figure; 
% histogram(sampInts)
meanSamp = mean(sampInts); % mean sampling interval [s]
sampFreq = 1/meanSamp; % sampling frequency [Hz]
% Times and values of the noise part and data
noiseTimeVec = importFile(1:noiseVecLim,1);
noiseValVec = importFile(1:noiseVecLim,2);
dataTimeVec = importFile(:,1);
dataValVec = importFile(:,2);

% PSD estimation of the colored noise
windowPSD = 60;  % number of samples in the window 
[noisePSDValsclr, PSDfreqsclr] = pwelch(noiseValVec, windowPSD, [], [], sampFreq);

% Design of the whitening filter 
fltrOrdr = 500; % filter order
sqrtPSDVals = sqrt(1./noisePSDValsclr); % transfer function to obtain white gaussian noise
wnVec = PSDfreqsclr/(sampFreq/2); % normalized frequency vector
bCoeffs = fir2(fltrOrdr, wnVec, sqrtPSDVals); % filter coefficients

% Apply whitening filter to the noise and data
whtnoiseVec = sqrt(sampFreq)*fftfilt(bCoeffs, noiseValVec); 
whtdataVec = sqrt(sampFreq)*fftfilt(bCoeffs, dataValVec); 

% PSD estimation of the noise after whinening
[noisePSDValswht, PSDfreqswht] = pwelch(whtnoiseVec, windowPSD, [], [], sampFreq);

% Generate spectrograms of the data before and after the whitening
winSmpls = 200; % number of samples in the window 
ovrlptg = 0.5; % overlap as percentage of the windows
ovrlpSmpls = floor(winSmpls*ovrlptg); % number of samples in the overlap
[specFTclr,specFreqclr,specTimeclr] = spectrogram(dataValVec,winSmpls,ovrlpSmpls,[],sampFreq);
[specFTwht,specFreqwht,specTimewht] = spectrogram(whtdataVec,winSmpls,ovrlpSmpls,[],sampFreq);

%% Plots

% time series of the colored noise 
figure;
subplot(2,1,1);
plot(noiseTimeVec,noiseValVec,':.','Color',[0.4940 0.1840 0.5560]);
legend('colored noise','Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title('Time series of the noise','Interpreter','latex','FontSize',20);
grid on;
% time series of the noise after whitening
subplot(2,1,2);
plot(noiseTimeVec,whtnoiseVec,':.','Color',[0.4660 0.6740 0.1880]);
legend('noise after whitening','Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
grid on;

% PSD of the colored noise
figure;
subplot(2,1,1);
plot(PSDfreqsclr,noisePSDValsclr,'-o','Color',[0.4940 0.1840 0.5560]);
ylim([0 inf])
legend('colored noise','Interpreter','latex','FontSize',14,'Location','best')
ylabel('PSD','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title('Power spectral density of the noise','Interpreter','latex','FontSize',20);
grid on;
% PSD of the noise after whitening
subplot(2,1,2);
plot(PSDfreqswht,noisePSDValswht,'-o','Color',[0.4660 0.6740 0.1880]);
ylim([0 inf])
legend('noise after whitening','Interpreter','latex','FontSize',14,'Location','best')
ylabel('PSD','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
grid on;

% time series of the data before whitening 
figure;
subplot(2,1,1);
plot(dataTimeVec,dataValVec,':.','Color',[0.4940 0.1840 0.5560]);
legend('data before whitening','Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title('Time series of the data','Interpreter','latex','FontSize',20);
grid on;
% time series of the data after whitening
subplot(2,1,2);
plot(dataTimeVec,whtdataVec,':.','Color',[0.4660 0.6740 0.1880]);
legend('data after whitening','Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
grid on;

% spectrogram of the data before whitening
figure;
subplot(2,1,1);
imagesc(specTimeclr,specFreqclr,abs(specFTclr)); 
%surf(T,F,abs(S)); 
axis xy;
ylabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title('data spectrogram before whitening','Interpreter','latex','FontSize',20);
%colormap turbo;
colorbar;
% spectrogram of the data after whitening
subplot(2,1,2);
imagesc(specTimewht,specFreqwht,abs(specFTwht)); 
%surf(T,F,abs(S)); 
axis xy;
ylabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title('data spectrogram after whitening','Interpreter','latex','FontSize',20);
%colormap turbo;
colorbar;
