clear all
close all
clc
%% Plot an AM-FM sinusoid signal
% Frequency parameters 
f0 =50;
f1 = 4;
f2 = 2;
% Amplitude parameters
%FIXME No need to specify both A and SNR because of normalization
A = 2;
b = 5;
% Signal SNR
sn = 100;

% Sampling
samplFreq = 6*f0;
samplIntrvl = 1/samplFreq;

% Time samples
timeVec = 0:samplIntrvl:1.0;

% Generate the signal
sinVec = genamfmsin(timeVec,sn,[A,b],[f0,f1,f2]);

%Plot the signal 
figure;
plot(timeVec,sinVec,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0.8500 0.3250 0.0980]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')  
legend(sprintf('A=%g, b=%g, $f_{0}$=%g Hz, $f_{1}$=%g Hz, $f_{2}$=%g Hz, SNR=%g',A,b,f0,f1,f2,sn),'Interpreter','latex','FontSize',14,'Location','best')
title('AM-FM sinusoid','Interpreter','latex','FontSize',20)    
