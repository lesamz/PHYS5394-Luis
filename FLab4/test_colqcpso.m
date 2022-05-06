clear all
close all
clc
%%

addpath('../L11Lab');
addpath('../FLab3/');

%% Generation of signal and data

% Data generation parameters
nSamples = 512;
sampFreq = 512;
sampIntrvl = 1/sampFreq;
timeVec = (0:(nSamples-1))*sampIntrvl;

% Phase coefficients parameters of the true signal
% (Parameters of the signal to be normalized)  
a1_0=10;
a2_0=3;
a3_0=3;
A=1; % Amplitude does not matter as it will be changed in the normalization

% Generate the signal
sigVec = crcbgenqcsig(timeVec,A,[a1_0,a2_0,a3_0]);

% We will use the noise PSD used in colGaussNoiseDemo.m but add a constant
% to remove the parts that are zero. 
noisePSD = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625 + 1;

% Generate the PSD vector to be used in the normalization. Should be
% generated for all positive DFT frequencies. 
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

% Calculation of the norm
snr = 10; % Target SNR for the Signal
[sigVecNorm,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,snr);

% Generate noise
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
% Generate data
dataVec = noiseVec + sigVecNorm;

%% Test of colqcpso.m function

% Search range of phase coefficients
rmin = [1, 1, 1]; % a1 a2 a3
rmax = [180, 10, 10]; % a1 a2 a3
 
% Input parameters for colqcpso 
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

% Number of independent PSO runs
nRuns = 8;
outStruct = colqcpso(inParams,struct('maxSteps',1000),nRuns); % PSO implementation

%% Plot

figure;
hold on;
plot(timeVec,dataVec,':o','LineWidth',1,'MarkerSize',2,'Color',[0 0 0]);
plot(timeVec,sigVecNorm,'-','LineWidth',2,'Color',[0.6350 0.0780 0.1840]);
for lpruns = 1:nRuns
    plot(timeVec,outStruct.allRunsOutput(lpruns).estSig,'Color',[0.4660 0.6740 0.1880],'LineWidth',2.0);
end
plot(timeVec,outStruct.bestSig,'Color',[0 0 0],'LineWidth',1.0);
legend('Data (Signal + Noise)','Signal',...
       ['Estimated signal: ',num2str(nRuns),' runs'],...
       'Estimated signal: Best run','Interpreter','latex','FontSize',14,'Location','best');
disp(['Estimated parameters: a1=',num2str(outStruct.bestQcCoefs(1)),...
                             '; a2=',num2str(outStruct.bestQcCoefs(2)),...
                             '; a3=',num2str(outStruct.bestQcCoefs(3))]);
xlim([timeVec(100) timeVec(end)]);
ylabel('Values','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
grid on;