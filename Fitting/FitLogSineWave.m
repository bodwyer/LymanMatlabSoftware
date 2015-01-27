function [bestFitParams, fit, peakPower, exitFlag] = FitLogSineWave(xVec, data)

	guessParams = [max(data)/2, 0.5, -10, 0];

	 lb = [-0.5, 0, 0, 0];
	 ub = [0.5, 100, 20, max(data)];


	 fitFun = @(params)SineFit(params, data, xVec);

	 [bestFitParams, resnorm, residual, exitFlag] = lsqnonlin(fitFun, guessParams, lb, ub);
	 A = bestFitParams(1);
	 t = bestFitParams(2);
	 delta = bestFitParams(3);
	 C = bestFitParams(4);
	 fit = A*cos(t*sqrt(10.^(xVec/10)) + delta).^2+ C;

	 peakPower = xVec(fit == max(fit));
	 % peakPower = 10*log10((3*pi - delta)^2/(t^2));

	 figure();
	 plot(xVec, data, 'b', xVec, fit, 'r');
	 title(['Peak power at ', num2str(peakPower)])


	 function [res] = SineFit(params, plt, x)
	 	A = params(1);
	 	t = params(2);
	 	delta = params(3);
	 	C = params(4)
	 	fitWave = A*cos(t*sqrt(10.^(x/10)) + delta).^2+ C;
	 	res = plt - fitWave;

	 end
end


