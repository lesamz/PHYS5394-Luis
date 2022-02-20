clear all
close all
clc
%% Plot an AM-FM sinusoid signal
% signal parameters 
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
samplFreq = [5 0.5]*maxFreq;
samplIntrvl = 1./samplFreq;

% Time samples
timeVec = 0:samplIntrvl(1):1.0;
unsatimeVec = 0:samplIntrvl(2):1.0; % undersampled vector of time

% Generate the signal
sinVec = genamfmsin(timeVec,sn,[f0,f1,f2,b]);
unsasinVec = genamfmsin(unsatimeVec,sn,[f0,f1,f2,b]);

%Plot the signal 

figure;
plot(timeVec,sinVec,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0.8500 0.3250 0.0980]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')  
legend(sprintf('$f_{0}$=%g Hz, $f_{1}$=%g Hz, $f_{2}$=%g Hz, b=%g, SNR=%g',f0,f1,f2,b,sn),'Interpreter','latex','FontSize',14,'Location','best')
title(sprintf('AM-FM sinusoid, sampling frequency: %g Hz',samplFreq(1)),'Interpreter','latex','FontSize',20)

figure;
plot(unsatimeVec,unsasinVec,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0 0.4470 0.7410]);
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')  
legend(sprintf('$f_{0}$=%g Hz, $f_{1}$=%g Hz, $f_{2}$=%g Hz, b=%g, SNR=%g',f0,f1,f2,b,sn),'Interpreter','latex','FontSize',14,'Location','best')
title('AM-FM sinusoid','Interpreter','latex','FontSize',20)    
title(sprintf('AM-FM sinusoid, sampling frequency: %g Hz',samplFreq(2)),'Interpreter','latex','FontSize',20)

