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
samplFreq = 8*f0;
samplIntrvl = 1/samplFreq;

% Time samples
timeVec = 0:samplIntrvl:100;

% Generate the signal
sigVec = gensingausig(timeVec,sn,[t0,sigma,f0,phi0]);

%Plot the signal 
figure;
plot(timeVec,sigVec,':o','LineWidth',1,'MarkerSize',2,'Color',[0.8500 0.3250 0.0980]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times') 
legend(sprintf('$t_{0}$=%g s, sigma=%g, $f_{0}$=%g Hz, phi=%g, SNR=%g',t0,sigma,f0,phi0,sn),'Interpreter','latex','FontSize',14,'Location','best')
title('Sine-Gaussian signal','Interpreter','latex','FontSize',20)    
