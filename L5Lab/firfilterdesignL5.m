clear all
close all
clc

%% Generate sinusoidal signals

% Sinusoid parameters 
A = [10 5 2.5];
f0 = [100 200 300];
phi0 = [0 pi/6 pi/4];

% Sampling
samplFreq = 1024;
samplIntrvl = 1/samplFreq;
nSamples = 2048;

% Maximum frequency 
maxFreq = samplFreq/2; 
fprintf('For a critical sampling frequency of %g Hz, it is possible to represent sinuoids with a frequency below %g Hz\n', samplFreq, maxFreq)

% Time samples
timeVec = 0:samplIntrvl:samplIntrvl*(nSamples-1);

% Generate sinusoids
sinVec1 = gensinsig(timeVec,A(1),f0(1),phi0(1));
sinVec2 = gensinsig(timeVec,A(2),f0(2),phi0(2));
sinVec3 = gensinsig(timeVec,A(3),f0(3),phi0(3));
sinVecSum = sinVec1 + sinVec2 + sinVec3; 

% Generate periodogram
[fftSigSum,posFreqSum] = genprdgrm(timeVec,sinVecSum);

% Plot sinusoids 
figure;
subplot(2,1,1);
hold on;
plot(timeVec,sinVec1,':o','LineWidth',1.5,'MarkerSize',2,'Color',[0 0.4470 0.7410]);
plot(timeVec,sinVec2,':o','LineWidth',1.5,'MarkerSize',2,'Color',[0.8500 0.3250 0.0980]);
plot(timeVec,sinVec3,':o','LineWidth',1.5,'MarkerSize',2,'Color',[0.9290 0.6940 0.1250]	);
plot(timeVec,sinVecSum,'-o','LineWidth',1.5,'MarkerSize',5,'Color',[0.4940 0.1840 0.5560]);
xlim([0 timeVec(end)/30]);
legend({sprintf('Sinusoid $f_{0}$=%g Hz', f0(1)),sprintf('Sinusoid $f_{0}$=%g Hz', f0(2)),sprintf('Sinusoid $f_{0}$=%g Hz', f0(3)),'Sum'},'Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title('Sinusoidal Signals','Interpreter','latex','FontSize',20);
grid on;

% Plot periodogram
subplot(2,1,2);
plot(posFreqSum, fftSigSum,':o','LineWidth',1,'MarkerSize',2,'Color',[0.6350 0.0780 0.1840]);
xlim([posFreqSum(1) posFreqSum(end)]);
ylabel('Magnitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title(sprintf('Periodogram of the sinusoids sum'),'Interpreter','latex','FontSize',20);
grid on;

%% Design of a low pass filter

filtOrdrLP = 30; % Determines the number of filter coefficients through N+1
cutFreqLP = (f0(2)-f0(1))/2+f0(1); % Cut-off frequency 
wnLP = cutFreqLP/(samplFreq/2); % Normalized cut-off frequency 
bCoeffsLP = fir1(filtOrdrLP,wnLP,'low'); % Filter coefficients

% Apply filter
filtSigLP = fftfilt(bCoeffsLP,sinVecSum);

% Generate periodogram
[fftSigLP,posFreqLP] = genprdgrm(timeVec,filtSigLP);

% Plot filter
figure;
subplot(2,1,1);
hold on;
plot(timeVec,sinVecSum,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0.4940 0.1840 0.5560]);
plot(timeVec,filtSigLP,'-o','LineWidth',1.5,'MarkerSize',5,'Color',[0.4660 0.6740 0.1880]);
plot(timeVec,sinVec1,':o','LineWidth',1.5,'MarkerSize',2,'Color',[0 0.4470 0.7410]);
xlim([0 timeVec(end)/30]);
legend({'Input','Output',sprintf('Sinusoid $f_{0}$=%g Hz', f0(1))},'Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title(sprintf('Low pass filter - %g Hz cut-out frequency', cutFreqLP),'Interpreter','latex','FontSize',20);
grid on;

% Plot periodogram
subplot(2,1,2);
plot(posFreqLP, fftSigLP,':o','LineWidth',1,'MarkerSize',2,'Color',[0.6350 0.0780 0.1840]);
xlim([posFreqLP(1) posFreqLP(end)]);
ylabel('Magnitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title(sprintf('Periodogram of the filter ouput'),'Interpreter','latex','FontSize',20);
grid on;

%% Design of a high pass filter

filtOrdrHP = 30; % Determines the number of filter coefficients through N+1
cutFreqHP = (f0(3)-f0(2))/2+f0(2); % Cut-off frequency 
wnHP = cutFreqHP/(samplFreq/2); % Normalized cut-off frequency 
bCoeffsHP = fir1(filtOrdrHP,wnHP,'high'); % Filter coefficients

% Apply filter
filtSigHP = fftfilt(bCoeffsHP,sinVecSum);

% Generate periodogram
[fftSigHP,posFreqHP] = genprdgrm(timeVec,filtSigHP);

% Plot filter
figure;
subplot(2,1,1);
hold on;
plot(timeVec,sinVecSum,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0.4940 0.1840 0.5560]);
plot(timeVec,filtSigHP,'-o','LineWidth',1.5,'MarkerSize',5,'Color',[0.4660 0.6740 0.1880]);
plot(timeVec,sinVec3,':o','LineWidth',1.5,'MarkerSize',2,'Color',[0.9290 0.6940 0.1250]	);
xlim([0 timeVec(end)/30]);
legend({'Input','Output',sprintf('Sinusoid $f_{0}$=%g Hz', f0(3))},'Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title(sprintf('High pass filter - %g Hz cut-out frequency', cutFreqHP),'Interpreter','latex','FontSize',20);
grid on;

% Plot periodogram
subplot(2,1,2);
plot(posFreqHP, fftSigHP,':o','LineWidth',1,'MarkerSize',2,'Color',[0.6350 0.0780 0.1840]);
xlim([posFreqHP(1) posFreqHP(end)]);
ylabel('Magnitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title(sprintf('Periodogram of the filter ouput'),'Interpreter','latex','FontSize',20);
grid on;

%% Design of a band pass filter

filtOrdrBP = 30; % Determines the number of filter coefficients through N+1
cutFreqBP = [(f0(2)-f0(1))/2+f0(1) (f0(3)-f0(2))/2+f0(2)]; % Cut-off frequencies 
wnBP = cutFreqBP./(samplFreq/2); % Normalized cut-off frequencies 
bCoeffsBP = fir1(filtOrdrBP,wnBP,'bandpass'); % Filter coefficients

% Apply filter
filtSigBP = fftfilt(bCoeffsBP,sinVecSum);

% Generate periodogram
[fftSigBP,posFreqBP] = genprdgrm(timeVec,filtSigBP);

% Plot filter
figure;
subplot(2,1,1);
hold on;
plot(timeVec,sinVecSum,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0.4940 0.1840 0.5560]);
plot(timeVec,filtSigBP,'-o','LineWidth',1.5,'MarkerSize',5,'Color',[0.4660 0.6740 0.1880]);
plot(timeVec,sinVec2,':o','LineWidth',1.5,'MarkerSize',2,'Color',[0.8500 0.3250 0.0980]);
xlim([0 timeVec(end)/30]);
legend({'Input','Output',sprintf('Sinusoid $f_{0}$=%g Hz', f0(2))},'Interpreter','latex','FontSize',14,'Location','best')
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
title(sprintf('Band pass filter - [%g %g] Hz cut-out frequencies', cutFreqBP(1), cutFreqBP(2)),'Interpreter','latex','FontSize',20);
grid on;

% Plot periodogram
subplot(2,1,2);
plot(posFreqBP, fftSigBP,':o','LineWidth',1,'MarkerSize',2,'Color',[0.6350 0.0780 0.1840]);
xlim([posFreqBP(1) posFreqBP(end)]);
ylabel('Magnitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title(sprintf('Periodogram of the filter ouput'),'Interpreter','latex','FontSize',20);
grid on;

%% Functions 

% Generate sinusoids of the form s(t) = A sin(2 pi f0 t + phi0)
function sigVec = gensinsig(dataT,Amp,freq,phase)
sigVec = Amp*sin(2*pi*freq*dataT+phase);
end

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