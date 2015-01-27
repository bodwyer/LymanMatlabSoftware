function [bestFitParams, fit] = FitThreePeaks(xVec, data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
guessParams = [max(data) - min(data), range(data)/3, ...
    min(data), xVec(round(length(xVec)/4)), xVec(round(length(xVec)/2)), ...
    xVec(round(3*length(xVec)/4))];
lb = [0.01, range(data)/10, min(data), xVec(1), xVec(1), xVec(1)];
ub = [max(data), range(data), max(data), xVec(end), xVec(end), xVec(end)];

fitFun = @(params)FitFun(params, data, xVec);
[bestFitParams, res, exifFlag] = lsqnonlin(fitFun, guessParams, lb, ub);

A = bestFitParams(1);
sigma = bestFitParams(2);
C = bestFitParams(3);
x1 = bestFitParams(4);
x2 = bestFitParams(5);
x3 = bestFitParams(6);
fit = A*(exp(-1/(2*sigma^2)*(xVec - x1).^2) + ...
            exp(-1/(2*sigma^2)*(xVec - x2).^2) + exp(-1/(2*sigma^2)*(xVec - x3).^2)) + C;

    function res = FitFun(params, plt, x)
        A = params(1);
        sigma = params(2);
        C = params(3);
        x1 = params(4);
        x2 = params(5);
        x3 = params(6);
        
        threeGauss = A*(exp(-1/(2*sigma^2)*(x - x1).^2) + ...
            exp(-1/(2*sigma^2)*(x - x2).^2) + exp(-1/(2*sigma^2)*(x - x3).^2)) + C;
        res = threeGauss - plt;
    end
        

end

