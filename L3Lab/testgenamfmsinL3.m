clear all
close all
clc

%% Plot an AM-FM sinusoid signal

% Signal parameters 
f0 = 50;
f1 = 2.2;
f2 = 2;
b = 5;
% Signal SNR
sn = 200;

% Sampling
samplFreq = 6*f0;
samplIntrvl = 1/samplFreq;

% Time samples
timeVec = 0:samplIntrvl:1.0;

% Generate the signal
sinVec = genamfmsin(timeVec,sn,[f0,f1,f2,b]);

% Plot the signal 
figure;
plot(timeVec,sinVec,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0.8500 0.3250 0.0980]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')  
legend(sprintf('$f_{0}$=%g Hz, $f_{1}$=%g Hz, $f_{2}$=%g Hz, b=%g, SNR=%g',f0,f1,f2,b,sn),'Interpreter','latex','FontSize',14,'Location','best')
title('AM-FM sinusoid','Interpreter','latex','FontSize',20)    
