function [bestFitParams, fit, exitFlag] = FitSineWave(xVec, data)

	guessParams = [-(max(data) - min(data))/2, 40, .001, mean(data)];

	 lb = [-(max(data)- min(data)), 12, -pi, 0];
	 ub = [max(data)- min(data), 2e3, pi, max(data) - min(data)];


	 fitFun = @(params)SineFit(params, data, xVec);

	 [bestFitParams, resnorm, residual, exitFlag] = lsqnonlin(fitFun, guessParams, lb, ub);

	 fit = SineWaveRabi(bestFitParams, xVec);


	 function [res] = SineFit(params, plt, x)

	 	fitWave = SineWaveRabi(params, x);
	 	res = plt - fitWave;

	 end
end


