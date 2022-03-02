clear all
close all
clc

%% Plot a Sine-Gaussian signal

% Signal parameters 
t0 = 30;
sigma = 0.5;
f0 =15;
phi0 = 1;
% Signal SNR
sn = 35;

% Sampling
% Instantaneous phase Phi(t) = f0 t
% Instantaneous frequency f(t) = f0
maxFreq = f0; 
nyqFreq = 2*maxFreq;
samplFreq = [5 0.5]*nyqFreq;
samplIntrvl = 1./samplFreq;

% Time samples
timeVec = 0:samplIntrvl(1):100;
unsatimeVec = 0:samplIntrvl(2):100; % undersampled vector of time
% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = gensingausig(timeVec,sn,[t0,sigma,f0,phi0]);
unsasigVec = gensingausig(unsatimeVec,sn,[t0,sigma,f0,phi0]);

% Plot the signal 

figure;
plot(timeVec,sigVec,':o','LineWidth',1,'MarkerSize',2,'Color',[0.8500 0.3250 0.0980]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');  
legend(sprintf('$t_{0}$=%g s, sigma=%g, $f_{0}$=%g Hz, phi=%g, SNR=%g',t0,sigma,f0,phi0,sn),'Interpreter','latex','FontSize',14,'Location','best');
title(sprintf('Sine-Gaussian signal, sampling frequency: %g Hz',samplFreq(1)),'Interpreter','latex','FontSize',20);
grid on;

figure;
plot(unsatimeVec,unsasigVec,':o','LineWidth',1,'MarkerSize',2,'Color',[0 0.4470 0.7410]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');  
legend(sprintf('$t_{0}$=%g s, sigma=%g, $f_{0}$=%g Hz, phi=%g, SNR=%g',t0,sigma,f0,phi0,sn),'Interpreter','latex','FontSize',14,'Location','best');
title(sprintf('Sine-Gaussian signal, sampling frequency: %g Hz',samplFreq(2)),'Interpreter','latex','FontSize',20);
grid on;

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
fftSig = fft(sigVec);
% Discard negative / Extract positive frequencies
fftSig = fftSig(1:kNyq);
% Magnitudes of positive frequencies / Periodogram
fftSig = abs(fftSig);

% Plot periodogram
figure;
plot(posFreq, fftSig,':o','LineWidth',1,'MarkerSize',2,'Color',[0.6350 0.0780 0.1840]);
ylabel('Magnitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
legend(sprintf('$t_{0}$=%g s, sigma=%g, $f_{0}$=%g Hz, phi=%g, SNR=%g',t0,sigma,f0,phi0,sn),'Interpreter','latex','FontSize',14,'Location','best');
title(sprintf('Sine-Gaussian signal Periodogram'),'Interpreter','latex','FontSize',20);
grid on;
