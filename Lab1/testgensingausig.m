clear all
close all
clc
%% Plot a Sine-Gaussian signal
% Signal parameters 
%FIXME No need to specify both A and SNR because of normalization
A = 6;
t0 = 20;
sigma = 0.3;
f0 =15;
phi0 = 1;
% Signal SNR
sn = 35;

% Sampling
samplFreq = 8*f0;
samplIntrvl = 1/samplFreq;

% Time samples
%FIXME The start time need not be tied to t0; See the changed version
% timeVec = t0:samplIntrvl:t0+1;
%SDM modification
timeVec = 0:samplIntrvl:100;

% Generate the signal
sigVec = gensingausig(timeVec,sn,[A,t0,sigma,f0,phi0]);

%Plot the signal 
%SDM: Good job with turning on the latex interpreter
figure;
plot(timeVec,sigVec,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0.8500 0.3250 0.0980]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')  
legend(sprintf('A=%g, $t_{0}$=%g, sigma=%g, $f_{0}$=%g Hz, phi=%g, SNR=%g',A,t0,sigma,f0,phi0,sn),'Interpreter','latex','FontSize',14,'Location','best')
title('Sine-Gaussian signal','Interpreter','latex','FontSize',20)    
