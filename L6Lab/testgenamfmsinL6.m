clear all
close all
clc

%% Plot an AM-FM sinusoid signal

% Function path
addpath('../L3Lab');

% Signal parameters 
f0 = 50;
f1 = 2.2;
f2 = 2;
b = 5;
% Signal SNR
sn = 200;

% Sampling
% Instantaneous phase Phi(t) = f0 t + b cos (2 pi f1 t) / (2 pi)
% Instantaneous frequency f(t) = f0 - f1 b sin (2 pi f1 t) 
maxFreq = f0-f1*b*(-1);
nyqFreq = 2*maxFreq;
samplFreq = [5 0.5]*nyqFreq;
samplIntrvl = 1./samplFreq;

% Time samples in seconds
timeVec = 0:samplIntrvl(1):1.0;
unsatimeVec = 0:samplIntrvl(2):1.0; % undersampled vector of time
% Number of samples
nSamples = length(timeVec);

% Generate the signal
sinVec = genamfmsin(timeVec,sn,[f0,f1,f2,b]);
unsasinVec = genamfmsin(unsatimeVec,sn,[f0,f1,f2,b]);

% Plot the signal 

figure;
plot(timeVec,sinVec,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0.8500 0.3250 0.0980]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');  
legend(sprintf('$f_{0}$=%g Hz, $f_{1}$=%g Hz, $f_{2}$=%g Hz, b=%g, SNR=%g',f0,f1,f2,b,sn),'Interpreter','latex','FontSize',14,'Location','best');
title(sprintf('AM-FM sinusoid, sampling frequency: %g Hz',samplFreq(1)),'Interpreter','latex','FontSize',20);
grid on;

% figure;
% plot(unsatimeVec,unsasinVec,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0 0.4470 0.7410]);
% ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
% xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');  
% legend(sprintf('$f_{0}$=%g Hz, $f_{1}$=%g Hz, $f_{2}$=%g Hz, b=%g, SNR=%g',f0,f1,f2,b,sn),'Interpreter','latex','FontSize',14,'Location','best');
% title(sprintf('AM-FM sinusoid, sampling frequency: %g Hz',samplFreq(2)),'Interpreter','latex','FontSize',20);
% grid on;

%% Plot the periodogram

% DFT frequency spacing 
freqSpac = 1/(timeVec(end)-timeVec(1));
% Limit index of the FFT positive half
kNyq = floor(nSamples/2)+1;
% Frequency index k
kIndx = 0:(kNyq-1);
% Positive Fourier frequencies
posFreq = kIndx*freqSpac;

% FFT of the signal
fftSig = fft(sinVec);
% Discard negative / Extract positive frequencies
fftSig = fftSig(1:kNyq);
% Magnitudes of positive frequencies / Periodogram
fftSig = abs(fftSig);

% Plot periodogram
figure;
plot(posFreq, fftSig,':o','LineWidth',1,'MarkerSize',2,'Color',[0.6350 0.0780 0.1840]);
ylabel('Magnitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
legend(sprintf('$f_{0}$=%g Hz, $f_{1}$=%g Hz, $f_{2}$=%g Hz, b=%g, SNR=%g',f0,f1,f2,b,sn),'Interpreter','latex','FontSize',14,'Location','best');
title(sprintf('AM-FM sinusoid Periodogram'),'Interpreter','latex','FontSize',20);
grid on;

%% Plot the spectrogram

% Window
numWins = 10; % Number of windows
winSecs = timeVec(end)/numWins; % Window in seconds
winSmpls = floor(winSecs*samplFreq(1)); % No. of samples in the window 
% Overlap
ovrlpPrcnt = 0.5; % Overlap as a percentage of the window
ovrlpSecs = winSecs*ovrlpPrcnt; % Overlap in seconds
ovrlpSmpls = floor(ovrlpSecs*samplFreq(1)); % No. of samples in the overlap

% Generate spectrogram
[specFT,specFreq,specTime] = spectrogram(sinVec,winSmpls,ovrlpSmpls,[],samplFreq(1));

% Plot spectrogram
figure;
imagesc(specTime,specFreq,abs(specFT)); 
%surf(T,F,abs(S)); 
axis xy;
ylabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title(sprintf('AM-FM sinusoid Spectrogram'),'Interpreter','latex','FontSize',20);
colormap turbo;
colorbar;
