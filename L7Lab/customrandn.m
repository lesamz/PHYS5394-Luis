function trialval = customrandn(nTrials,pdfparams)
% Customized randn() function
% Y = CUSTOMRANDN(N,PARAMS)
% Generates trial outcomes of normal pdf for a continuous random variable. 
% N is the number of trial outcomes to generate. PARAMS is the 
% vector [mu sigma] that parametrize the normal pdf N(x;mu,sigma), where mu 
% is the mean or most frequent outcome, and sigma is the standard deviation 
% or spread of outcomes. 
% A normal/gaussian probability density function is given by:
% px(x;mu,sigma) = ...
% N(x;mu,sigma) = 1/(sigma*(2pi)^1/2)*exp^(-(x-mu)^2/(2*sigma^2)) where x 
% is a random variable.

%Luis E. Salazar-Manzano, Mar 2022

trialval = pdfparams(2).*randn(1,nTrials) + pdfparams(1);
