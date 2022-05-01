clear all
close all
clc

%% Plot an AM-FM sinusoid signal

% Signal parameters as a structure
sigParams = struct('f0',50,'f1',2.2,'f2',2,'b',5);
% Signals SNR
sn = [10 12 15];

% Sampling
% Instantaneous phase Phi(t) = f0 t + b cos (2 pi f1 t) / (2 pi)
% Instantaneous frequency f(t) = f0 - f1 b sin (2 pi f1 t) 
maxFreq = sigParams.f0-sigParams.f1*sigParams.b*(-1);
nyqFreq = 2*maxFreq;
samplFreq = [5 0.5]*nyqFreq;
samplIntrvl = 1./samplFreq;

% Time samples
timeVec = 0:samplIntrvl(1):1.0;
%unsatimeVec = 0:samplIntrvl(2):1.0; % undersampled vector of time
% Number of samples
nSamples = length(timeVec);

%Function Handle of the SNR
%FIXME Doc: The function handle is for the function, not the SNR
gensinVecHandle = @(snr) genamfmsinmod(timeVec, snr, sigParams);

% Generate the signals
sinVec1 = gensinVecHandle(sn(1));
sinVec2 = gensinVecHandle(sn(2));
sinVec3 = gensinVecHandle(sn(3));

% Plot the signals
figure;
plot(timeVec,sinVec1,'-','LineWidth',1.2,'Color',[0.8500 0.3250 0.0980]);
hold on;
plot(timeVec,sinVec2,'-','LineWidth',1.1,'Color',[0.4660 0.6740 0.1880]);
hold on;
plot(timeVec,sinVec3,'-','LineWidth',1,'Color',[0 0.4470 0.7410]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');  
legend({sprintf('SNR (norm) = %g',norm(sinVec1)),sprintf('SNR (norm) = %g',norm(sinVec2)),sprintf('SNR (norm) = %g',norm(sinVec3))},'Interpreter','latex','FontSize',14,'Location','best');
title('AM-FM sinusoid','Interpreter','latex','FontSize',20);
grid on;