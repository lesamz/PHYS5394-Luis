clear all
close all
clc
%% Simulation of a LIGO noise realization

% LIGO design sensitivity
file = load('iLIGOSensitivity.txt','-ascii'); % power spectral density (PSD)
fileFreq = file(:,1); % vector of frequencies
fileSenst = file(:,2); % vector of sensitivity values

sampFreq = 4096;%2*fileFreq(end); % sampling frequency

% adjustements to the frequency vector of the target PSD 
freqInts = [fileFreq(2)-fileFreq(1), fileFreq(end)-fileFreq(end-1)]; % frequency intervals at the ends
freqVecL = 0:freqInts(1):50; % low frequency part 
freqVecR = 700:freqInts(2):sampFreq/2; % high frequency part 
freqVecC = fileFreq(fileFreq>50 & fileFreq<700)'; % frequencies of interest
freqVec = [freqVecL freqVecC freqVecR]; % modified vector of frequencies
freqVec(end) = sampFreq/2;

% adjustements to the sensitivity vector of the target PSD 
idL = find(fileFreq == freqVecC(1)); % index of 50 Hz
idR = find(fileFreq == freqVecC(end)); % index of 700 Hz
senstVecL = ones(1,length(freqVecL))*fileSenst(idL); % low frequency part
senstVecR = ones(1,length(freqVecR))*fileSenst(idR); % high frequency part
senstVec = [senstVecL fileSenst(idL:idR)' senstVecR]; % modified vector of sensitivity values

% Design of the filter 
fltrOrdr = 500; % filter order
%FIXME The supplied values in iLIGOSensitivity.txt are already sqrt(PSD); Review lab slides
sqrtPSDVals = senstVec;%sqrt(senstVec); % filter transfer function
wnVec = freqVec/(sampFreq/2); % normalized frequency vector
bCoeffs = fir2(fltrOrdr, wnVec, sqrtPSDVals); % filter coefficients

% Noise realization
nSamples = 100000;
inNoise = randn(1,nSamples); % input white gaussian noise
outNoise = sqrt(sampFreq)*fftfilt(bCoeffs, inNoise); % output LIGO noise
timeVec = (0:(nSamples-1))/sampFreq; % time samples

% PSD estimation of the noise
windowPSD = 256;%400  % number of samples in the window 
[PSDValsin, PSDfreqin] = pwelch(inNoise, windowPSD, [], [], sampFreq); % input noise
[PSDValsout, PSDfreqout] = pwelch(outNoise, windowPSD, [], [], sampFreq); % output noise

%% Plots

% Target PSD
figure;
subplot(2,1,1)
loglog(fileFreq,fileSenst,':.','Color',[0 0 0])
hold on
loglog(freqVec,senstVec,'--.','Color',[0.6350 0.0780 0.1840])
legend({'LIGO design sensitivity', 'adjusted LIGO design sensitivity'},'Interpreter','latex','FontSize',14,'Location','best')
ylabel('Sensitivity','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title('Target power spectral density','Interpreter','latex','FontSize',20);
grid on;
subplot(2,1,2)
loglog(fileFreq,fileSenst,':o','Color',[0 0 0])
hold on
loglog(freqVec,senstVec,'--.','Color',[0.6350 0.0780 0.1840])
xlim([fileFreq(idL) fileFreq(idR)])
legend({'LIGO design sensitivity', 'adjusted LIGO design sensitivity'},'Interpreter','latex','FontSize',14,'Location','best')
ylabel('Sensitivity','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title('Region of interest (50 Hz $< f <$ 700 Hz)','Interpreter','latex','FontSize',20);
grid on;

% Noise realization
figure;
subplot(2,1,1);
plot(timeVec,inNoise,':.','Color',[0.5 0.5 0.5]);
legend('input white gaussian noise','Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title('Noise realization','Interpreter','latex','FontSize',20);
grid on;
subplot(2,1,2);
plot(timeVec,outNoise,':.','Color',[0 0 0]);
legend('simulated LIGO noise','Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
grid on;

% PSD of noise
figure;
subplot(2,1,1);
loglog(PSDfreqin,PSDValsin,'-o','Color',[0.5 0.5 0.5]);
legend('input white gaussian noise','Interpreter','latex','FontSize',14,'Location','best')
ylabel('PSD','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title('Power spectral density of the noise','Interpreter','latex','FontSize',20);
% xlim([fileFreq(idL) fileFreq(idR)])
grid on;
subplot(2,1,2);
loglog(PSDfreqout,PSDValsout,'-o','Color',[0 0 0]);
%FIXME SDM: Added the design sensitivity for reference
hold on;
loglog(freqVec,senstVec.^2);
legend({'simulated LIGO noise','Reference PSD'},'Interpreter','latex','FontSize',14,'Location','best')
ylabel('PSD','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
% xlim([fileFreq(idL) fileFreq(idR)])
grid on;

