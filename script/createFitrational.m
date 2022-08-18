function [fitresult, gof] = createFitrational(timenbin, adjusthit)
%CREATEFIT(TIMENBIN,ADJUSTHIT)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : timenbin
%      Y Output: adjusthit
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 25-Jul-2022 11:35:04


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( timenbin, adjusthit );

% Set up fittype and options.
ft = fittype( 'rat11' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.Robust = 'Bisquare';
opts.StartPoint = [0.170147553586939 0.933727498118328 0.507039386817608];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

gof.xData=xData;
gof.yData=yData;

% % Plot fit with data.
% h = plot(fitresult, xData, yData );
% legend( h, 'adjusthit vs. timenbin', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'timenbin', 'Interpreter', 'none' );
% ylabel( 'adjusthit', 'Interpreter', 'none' );
% grid on


