function [best_fit_gaussian, fit_params, exitFlag] = BF_Gaussian_1D_Inverted(data, xVec)


	guess_params = [xVec(find(data == min(data))),-1*(mean(data) - min(data)), abs(xVec(end) - xVec(1))/2, mean(data)]
	lb = [xVec(1), -1, 0, -.3];
	ub = [xVec(end), 0, xVec(end) - xVec(1), 0];

	fit_fun = @(params)Gauss_fit(params, data, xVec);


	[fit_params, resNorm, residual, exitFlag] = lsqnonlin(fit_fun, guess_params, lb, ub);

	best_fit_gaussian = Gaussian_1D(fit_params, xVec);


	function [res] = Gauss_fit(params, im, xx)

		gauss = Gaussian_1D(params, xx);
		res = gauss - im;

	end

end
