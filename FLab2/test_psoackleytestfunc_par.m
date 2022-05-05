clear all
close all
%clc
%% Test harness for CRCBPSO using Ackley benchmark function
tic
%% PSO parameters  

ffparams = struct('rmin',-32,...
                    'rmax',32); % Fitness function parameters
fitFuncHandle = @(x) psoackleytestfunc(x,ffparams); % Fitness function handle

nDim = 2; % Dimensionality of the search space

% PSO optional parameters
popSize = 40; % Number of particles
maxSteps = 500; % Number of iterations
maxVelocity = 5; % Maximun velocity
optParam = struct('popSize',popSize,...
                    'maxSteps',maxSteps,...
                    'c1',[],'c2',[],...
                    'maxVelocity',maxVelocity);

% Call PSO and use best-of-M-runs estrategy
nRuns = 4; % Number of PSO runs
psoOut = struct('totalFuncEvals',[],...
                    'bestLocation',zeros(1,nDim),...
                    'bestFitness',[],...
                    'allBestFit',[],...
                    'allBestLoc',[]);
% We need to have one psoOut struct for each run: make a struct array with
% each element initialized to be the same as the first
for lpruns = 2:nRuns
    psoOut(lpruns) = psoOut(1);
end

parfor lpruns = 1:nRuns
        % Reset random number generator for each worker such that the
        % pseudo-random sequence is different for them but they repeat
        % everytime this code is run
        rng(lpruns);
        % PSO run 
        psoOut(lpruns) = crcbpso(fitFuncHandle,nDim,optParam,2);
end

% Find best run
bestRun = 1;
for lpruns = 2:nRuns
    if psoOut(lpruns).bestFitness < psoOut(bestRun).bestFitness
        bestRun = lpruns;
    end
end

%% Print estimated parameters
stdCoord = psoOut(bestRun).bestLocation; % Best standardized coordinates found
[~,realCoord] = fitFuncHandle(stdCoord); % Best real coordinates found

disp(['Best run:',num2str(bestRun)]);
disp(['Best location:',num2str(realCoord)]);
disp(['Best fitness:', num2str(psoOut(bestRun).bestFitness)]);
disp(' ');
disp('Info for all runs:');
for lpruns = 1:nRuns
    stdCoord = psoOut(lpruns).bestLocation;
    [~,realCoord] = fitFuncHandle(stdCoord);
    disp(['Best location for run ',num2str(lpruns),': ',num2str(realCoord)]);
    disp(['Best fitness for run ',num2str(lpruns),': ', num2str(psoOut(lpruns).bestFitness)]);
    disp('*****************');
end
disp(' ');
toc

%% Plots

for lpruns = 1:nRuns
    if lpruns == 1
        figure;
        hold on;
        plot(psoOut(lpruns).allBestLoc(:,1),psoOut(lpruns).allBestLoc(:,2),':o','LineWidth',1.5,'MarkerSize',2);
    else
        plot(psoOut(lpruns).allBestLoc(:,1),psoOut(lpruns).allBestLoc(:,2),':o','LineWidth',1.5,'MarkerSize',2);        
    end
end
% xlim([0 1]);
% ylim([0 1]);
ylabel('Coordinate 2','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Coordinate 1','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title(sprintf('Dimensions: %g, Runs: %g, Particles: %g, Iterations: %g, Max Velocity: %g',nDim,nRuns,popSize,maxSteps,maxVelocity),'Interpreter','latex','FontSize',12);
grid on;

for lpruns = 1:nRuns
    if lpruns == 1
        figure;
        hold on;
        plot(psoOut(lpruns).allBestFit,'-','LineWidth',2);
    else
        plot(psoOut(lpruns).allBestFit,'-','LineWidth',2);
    end
end
ylabel('Global best fitness','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
xlabel('Iteration','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title(sprintf('Dimensions: %g, Runs: %g, Particles: %g, Iterations: %g, Max Velocity: %g',nDim,nRuns,popSize,maxSteps,maxVelocity),'Interpreter','latex','FontSize',12);
grid on;


figure
[x1,x2] = meshgrid(-32:1:32,-32:1:32);
ackVal = -20*exp(-0.2*sqrt((x1.^2+x2.^2)/2))-exp((cos(2*pi*x1)+cos(2*pi*x2))/2)+20+exp(1);
surf(x1,x2,ackVal,'FaceAlpha',0.5)
xlabel('first coordinate','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
ylabel('second coordinate','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
zlabel('Fitness value','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times');
title('Ackley benchmark function of 2 dimensions','Interpreter','latex','FontSize',20);