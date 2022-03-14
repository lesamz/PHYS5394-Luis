function trialval = customrand(notrials,pdfparams)
% Customized rand() function
% Y = CUSTOMRAND(No,PARAMS)
% Generates trial outcomes of uniform pdf for a continuous random variable. 
% No is the number of trial outcomes to generate. PARAMS is the 
% vector [a b] that parametrize the uniform pdf U(x;a,b), where a is the 
% lower limit of the random variable and b is its upper limit.
% A uniform probability density function is given by:
% px(x;a,b) = U(x;a,b) = 1/(b-a) when a<=x<=b or U(x;a,b) = 0 otherwise,
% where x is a random variable.

%Luis E. Salazar-Manzano, Mar 2022

trialval = (pdfparams(2) - pdfparams(1)).*rand(1,notrials) + pdfparams(1);
