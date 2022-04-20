clear all
close all
clc
%%

% Import H1 data realization  
data1H1 = load('data1.txt','-ascii')'; 
data2H1 = load('data2.txt','-ascii')'; 
data3H1 = load('data3.txt','-ascii')'; 

% Calculate GLRT for each H1 data realization

% Parameters of the data realization
nSamples = length(data1H1); % number of samples
sampFreq = 1024; % given sampling frequency 
timeVec = (0:(nSamples-1))/sampFreq;

% PSD of the noise
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
% PSD values and its DFT frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

% Known parameters of the signal
a1=10;
a2=3;
a3=3;

glrtVal1H1 = glrtqsig([timeVec; data1H1],[posFreq; psdPosFreq],[a1 a2 a3]);
glrtVal2H1 = glrtqsig([timeVec; data2H1],[posFreq; psdPosFreq],[a1 a2 a3]);
glrtVal3H1 = glrtqsig([timeVec; data3H1],[posFreq; psdPosFreq],[a1 a2 a3]);

% Obtain GLRT values for multiple H0 data realizations
M = 10000; % H0 data realizations 

glrtValsH0 = zeros(1,M);
for i = 1:M
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    glrtValsH0(i) = glrtqsig([timeVec; noiseVec],[posFreq; psdPosFreq],[a1 a2 a3]);
end

% Number of times H0 GLRTs >= H1 GLRTs 
glrtgreater1 = sum(glrtValsH0 >= glrtVal1H1); 
glrtgreater2 = sum(glrtValsH0 >= glrtVal2H1);
glrtgreater3 = sum(glrtValsH0 >= glrtVal3H1);

% Significance of each H1 data realization
alfa1H1 = glrtgreater1/M*100;
alfa2H1 = glrtgreater2/M*100;
alfa3H1 = glrtgreater3/M*100;

% Show results
disp(alfa1H1)
disp(alfa2H1)
disp(alfa3H1)

% profile viewer
