clear all
close all
clc
%%

addpath('../L11Lab');
addpath('../FLab3/');
addpath('../FLab4/');

trnFile = load('TrainingData.mat'); % Noise
datFile = load('AnalysisData.mat'); % Data

% Noise
nSamplestrn = length(trnFile.trainData);
samplIntrvtrn = 1/trnFile.sampFreq;
timeVectrn = (0:(nSamplestrn-1))*samplIntrvtrn;

% Data
nSamplesdat = length(datFile.dataVec);
samplIntrvdat = 1/datFile.sampFreq;
timeVecdat = (0:(nSamplesdat-1))*samplIntrvdat;

% Estimation of the Power Spectral Density (PSD) through the Welch's method 
windowPSD = 500;  % number of samples in the window 
[PSDVals, PSDfreqs] = pwelch(trnFile.trainData, windowPSD, [], [], trnFile.sampFreq);

% Interpolate PSD to DFT frequencies
dataLen = nSamplesdat/datFile.sampFreq;
kNyq = floor(nSamplesdat/2)+1;
PSDfreqsDFT = (0:(kNyq-1))*(1/dataLen);
PSDValsintrp = interp1(PSDfreqs,PSDVals,PSDfreqsDFT);

% Plots
figure; 
subplot(2,1,1) % Time series of the noise
plot(timeVectrn,trnFile.trainData,'-','LineWidth',1,'Color',[0 0 0])
xlim([timeVectrn(1) timeVectrn(end)])
ylabel('Amplitude','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');  
legend('Time series of the noise','Interpreter','latex','FontSize',14,'Location','best');
title('Trainning data','Interpreter','latex','FontSize',20);
grid on;
subplot(2,1,2) % PSD of the noise
plot(PSDfreqsDFT,PSDValsintrp,'-o','LineWidth',1,'MarkerSize',2,'Color',[0 0.4470 0.7410]);
xlim([PSDfreqsDFT(1) PSDfreqsDFT(end)])
legend('Noise','Interpreter','latex','FontSize',14,'Location','best')
ylabel('PSD','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Frequency [Hz]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times'); 
legend('Power spectral density of the noise','Interpreter','latex','FontSize',14,'Location','best');
grid on;

%% PSO with GLRT as fitness function

% Search range of phase coefficients
rmin = [40, 1, 1]; % a1 a2 a3
rmax = [100, 50, 15]; % a1 a2 a3
 
% Input parameters for colqcpso 
inParams = struct('dataX', timeVecdat,...
                  'dataY', datFile.dataVec,...
                  'dataXSq',timeVecdat.^2,...
                  'dataXCb',timeVecdat.^3,...
                  'psdX',PSDfreqsDFT,...
                  'psdY',PSDValsintrp,...
                  'sampFreq',datFile.sampFreq,...
                  'rmin',rmin,...
                  'rmax',rmax);

fHandle = @(x) glrtqcsig4pso(x,inParams); % Function handle

nRuns = 8; % Number of independent PSO runs
outStruct = colqcpso(inParams,struct('maxSteps',2000),nRuns); % PSO implementation

% Plot
figure;
hold on;
plot(timeVecdat,datFile.dataVec,':o','LineWidth',1,'MarkerSize',2,'Color',[0 0 0]);
for lpruns = 1:nRuns
    plot(timeVecdat,outStruct.allRunsOutput(lpruns).estSig,'Color',[0.4660 0.6740 0.1880],'LineWidth',2.0);
end
plot(timeVecdat,outStruct.bestSig,'Color',[0 0 0],'LineWidth',2.0);
legend('Data (Signal + Noise)',...
       ['Estimated signal: ',num2str(nRuns),' runs'],...
       'Estimated signal: Best run','Interpreter','latex','FontSize',14,'Location','best');
ylabel('Values','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Time [s]','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title('Estimation','Interpreter','latex','FontSize',20)    
grid on;


%% Significance 
 
% GLRT values for multiple H0 data realizations
nH0 = 10000; % H0 data realizations 
glrtValsH0 = zeros(1,nH0);
for i = 1:nH0
    noiseVec = statgaussnoisegen(nSamplesdat+100,[PSDfreqsDFT(:),PSDValsintrp(:)],100,datFile.sampFreq);
    noiseVec = noiseVec(101:end);
    glrtValsH0(i) = glrtqsig([timeVecdat; noiseVec],[PSDfreqsDFT; PSDValsintrp],[outStruct.bestQcCoefs(1) outStruct.bestQcCoefs(2) outStruct.bestQcCoefs(3)]);
end

% GLRT value for the H1 data realization
glrtValH1 = -1*outStruct.bestFitness; 
%glrtValH1 = glrtqsig([timeVecdat; datFile.dataVec],[PSDfreqsDFT; PSDValsintrp],[outStruct.bestQcCoefs(1) outStruct.bestQcCoefs(2) outStruct.bestQcCoefs(3)]);

% Number of times H0 GLRT >= H1 GLRT 
glrtgreater = sum(glrtValsH0 >= glrtValH1); 

% Significance of the H1 data realization
alfaH1 = glrtgreater/nH0*100;

% Show results
disp(['Significance of the detection: ',num2str(alfaH1)])

if alfaH1 < 0.01
    disp('A signal was detected!')
    disp(['Estimated parameters: a1 = ',num2str(outStruct.bestQcCoefs(1)),...
                             '; a2 = ',num2str(outStruct.bestQcCoefs(2)),...
                             '; a3 = ',num2str(outStruct.bestQcCoefs(3))]);
else
    disp('A signal was not detected')
end 

% Plot PDF
figure;
histogram(glrtValsH0,'Normalization','pdf','FaceColor',[0.9290 0.6940 0.1250]);
ylabel('Normalized frequency','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
xlabel('Detection statistics','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
if alfaH1 < 0.01
    xline(glrtValH1,'--r',{'H_{1} GLRT', 'from the data'});
else
    xline(glrtValH1,'--r',{'H_{0} GLRT', 'from the data'});
end 
legend('Distribution of $H_{0}$ GLRT','Interpreter','latex','FontSize',14,'Location','north')
title('GLRT detection statistics','Interpreter','latex','FontSize',20)    
grid on