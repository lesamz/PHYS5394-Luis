clear all
close all
clc
%% Objetivo
% Descripcion del codigo

addpath('../L11Lab');

%% Generation of signal and data

% Data generation parameters
nSamples = 512;
sampFreq = 512;
sampIntrvl = 1/sampFreq;
timeVec = (0:(nSamples-1))*sampIntrvl;

% Phase coefficients parameters of the true signal
% (Parameters of the signal to be normalized)  
a1_0=9.5;
a2_0=2.8;
a3_0=3.2;
A=1; % Amplitude does not matter as it will be changed in the normalization

% Generate the signal
sigVec = crcbgenqcsig(timeVec,A,[a1_0,a2_0,a3_0]);

% We will use the noise PSD used in colGaussNoiseDemo.m but add a constant
% to remove the parts that are zero. 
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;

% Generate the PSD vector to be used in the normalization. Should be
% generated for all positive DFT frequencies. 
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

% Calculation of the norm
% Target SNR for the Signal
snr = 10;
% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdPosFreq);
% Normalize signal to specified SNR
sigVecNorm = snr*sigVec/sqrt(normSigSqrd);  

% Generate noise
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
% Generate data
dataVec = noiseVec + sigVecNorm;

% Plot of the data and the signal
figure;
plot(timeVec,dataVec,':o','LineWidth',1,'MarkerSize',2,'Color',[0 0 0]);
hold on;
plot(timeVec,sigVecNorm,':o','LineWidth',1,'MarkerSize',2,'Color',[0.6350 0.0780 0.1840]);
ylabel('Values','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
legend({'Data (Signal + Noise)', 'Signal'},'Interpreter','latex','FontSize',14,'Location','best');
title(sprintf('Time series'),'Interpreter','latex','FontSize',20);
grid on;


%% Test of glrtqcsig4pso.m function

% Search range of phase coefficients
rmin = [1, 1, 1]; % a1 a2 a3
rmax = [10, 10, 10]; % a1 a2 a3
a1del = 0.1; % Step size a1
 
% Initialize grid of the varying a1 coefficient in real coordinates
A = rmin(1):a1del:rmax(1);
% Initialize matrix of standardized coordinates 
X = zeros(length(A),3); 
X(:,1) = (A-rmin(1))/(rmax(1)-rmin(1)); % First coordinate a1
X(:,2) = (a2_0-rmin(2))/(rmax(2)-rmin(2)); % Second coordinate a2 (fixed)
X(:,3) = (a3_0-rmin(3))/(rmax(3)-rmin(3)); % Thirds coordinate a3 (fixed)

% Input parameters for my_crcbqcpso or glrtqcsig4pso 
inParams = struct('dataX', timeVec,...
                  'dataY', dataVec,...
                  'dataXSq',timeVec.^2,...
                  'dataXCb',timeVec.^3,...
                  'psdX',posFreq,...
                  'psdY',psdPosFreq,...
                  'sampFreq',sampFreq,...
                  'rmin',rmin,...
                  'rmax',rmax);

fHandle = @(x) glrtqcsig4pso(x,inParams); % Function handle

fitnessValues = fHandle(X); % GLRT for each set of coordinates

figure;
plot(A,fitnessValues,':o','LineWidth',1.5,'MarkerSize',5,'Color',[0.4660 0.6740 0.1880]);
ylabel('Fitness value','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Coordinate $a_{1}$','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');  
legend(sprintf('Signal of real $a_{1}$=%g coefficient',a1_0),'Interpreter','latex','FontSize',14,'Location','best');
title("GLRT for a quadratic chirp signal in colored data",'Interpreter','latex','FontSize',20);
grid on;
