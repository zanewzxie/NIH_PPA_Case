function [X,Y,coefficients,yFitted,SMOOTHX,yFittedSmooth] = fitExponential(x, y)
% FITEXPONENTIAL fits a time series to a single exponential curve. 
% [k, yInf, y0] = fitExponential(x, y)
%
% The fitted curve reads: yFit = yInf + (y0-yInf) * exp(-k*(x-x0)).
% Here yInf is the fitted steady state value, y0 is the fitted initial
% value, and k is the fitted rate constant for the decay. Least mean square
% fit is used in the estimation of the parameters.
% 
% Outputs:
% * k: Relaxation rate
% * yInf: Final steady state
% * y0: Initial state
% * yFit: Fitted time series
% 
% Last modified on 06/26/2012
% by Jing Chen
% improve accuracy by subtracting large baseline
[X, Y] = prepareCurveData(x,y );
% Convert X and Y into a table, which is the form fitnlm() likes the input data to be in.
tbl = table(X, Y);
% Define the model as Y = a + exp(-b*x)
% Note how this "x" of modelfun is related to big X and big Y.
% x((:, 1) is actually X and x(:, 2) is actually Y - the first and second columns of the table.
modelfun = @(b,x) b(1) * exp(-b(2)*x(:, 1)) + b(3);  
beta0 = [11, .5, 6]; % Guess values to start with.  Just make your best guess.
% Now the next line is where the actual model computation is done.
mdl = fitnlm(tbl, modelfun, beta0);
% Now the model creation is done and the coefficients have been determined.
% YAY!!!!

SMOOTHX = [0 linspace(min(X),max(X),100)];
% Extract the coefficient values from the the model object.
% The actual coefficients are in the "Estimate" column of the "Coefficients" table that's part of the mode.
coefficients = mdl.Coefficients{:, 'Estimate'};
% Create smoothed/regressed data using the model:
yFitted = coefficients(1) * exp(-coefficients(2)*X) + coefficients(3);
yFittedSmooth= coefficients(1) * exp(-coefficients(2)*SMOOTHX) + coefficients(3);
% % Now we're done and we can plot the smooth model as a red line going through the noisy blue markers.
% hold on;
% plot(X, yFitted, 'r-', 'LineWidth', 2);
