clear all
close all
clc
%%  Uniform pdf

% Definition of pdf parameters
aparam = -2;
bparam = 1;

% Number of trials
nTrials = 10000;

% Generate outcomes 
outcomun = customrand(nTrials,[aparam bparam]);

% Ideal pdf
xidealun = [aparam-1 aparam aparam bparam bparam bparam+1];
yidealun = [0 0 1/(bparam-aparam) 1/(bparam-aparam) 0 0];

% Plot pdf
figure;
hold on
histogram(outcomun,'Normalization','pdf','FaceColor',[0.9290 0.6940 0.1250]);
line(xidealun, yidealun, 'LineWidth', 2, 'Color', 'b');
legend({sprintf('generated $N$=%g', nTrials),'ideal'},'Interpreter','latex','FontSize',14,'Location','best')
ylabel('Normalized frequency','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
xlabel('Random variable x','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times') 
title(sprintf('Uniform pdf: $a$=%g, $b$=%g', aparam, bparam),'Interpreter','latex','FontSize',20)    
grid on

%%  Normal pdf

% Definition of pdf parameters
muparam = 1.5;
sigmaparam = 2.0;

% Generate outcomes 
outcomnor = customrandn(nTrials,[muparam sigmaparam]);

% Ideal pdf
xidealnor = (muparam-4*sigmaparam):.1:(muparam+4*sigmaparam);
yidealnor = (1/(sqrt(2*pi)*sigmaparam))*exp(-(xidealnor-muparam).^2/(2*sigmaparam^2));

% Plot pdf
figure;
hold on
histogram(outcomnor,'Normalization','pdf','FaceColor',[0.9290 0.6940 0.1250]);
plot(xidealnor,yidealnor, 'LineWidth', 2, 'Color', 'b')
ylabel('Normalized frequency','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
xlabel('Random variable x','FontUnits','points','Interpreter','latex','FontSize',18,'FontName','Times')
legend({sprintf('generated $N$=%g', nTrials),'ideal'},'Interpreter','latex','FontSize',14,'Location','best')
title(['Normal pdf: $\mu$=', num2str(muparam),', $\sigma$=', num2str(sigmaparam)],'Interpreter','latex','FontSize',20)    
grid on
