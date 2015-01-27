function [fit, fit_params, exitFlag, resnorm] = ACMagFit(field, tauVec)

	% Constants
	mu_b = 9.27401e-21; % Bohr maneton, CGS. Erg/Gauss
	g = 2.002319; % Electron g factor
    hbar = 1.054572e-27; % Planks constant, erg*second
    preFactor = mu_b*g/hbar;
    freq = 5.05e6; % 5.05 MHz
	

	optimoptions(@lsqnonlin, 'MaxFunEvals', 5000, 'MaxIter', 5000, 'TolFun', 1e-8)
    tauVec = tauVec*1e-9;

    pltfig = figure();
	lb = [0, 0];
	ub = [5, 10e-6];

	guess_params = [1, 6e-6];

	fit_fun = @(parameters)PFit(parameters, field, tauVec);

	[fit_params] = lsqnonlin(fit_fun, guess_params, lb, ub);

	disp(['fit params are ']);
	fit_params

	B_fit = fit_params(1);
    T2_fit = fit_params(2);
   
    
    env = exp(-(tauVec/T2_fit).^3);
    dPhi_fit = 4*preFactor^2*B_fit^2/(freq)^2*sin(2*pi*freq*tauVec./4).^4;
        % sin(pi*freq*tauVec*1e-9/2).^2.*cos(pi*freq*tauVec*1e-9 + phi);
	P0_fit = (exp(-dPhi_fit));
    
    P0_fit = 1/2*(1 + P0_fit.*env);


	figure
	plot(tauVec, field, 'bo', tauVec, P0_fit, 'r');
	xlabel('\tau (ns)'); ylabel('P_0');
	title(['AC Magnetometry, B_{AC} = ', num2str(B_fit)]);
	legend('Magnetometry Signal', 'Magnetometry Fit');




	function [resid] = PFit(params, data, tVec)
		B = params(1);
        T2 = params(2);
		dPhi = (4*preFactor^2*B^2/freq^2)*sin(2*pi*freq*tVec/4).^4;
        % sin(pi*freq*tauVec*1e-9/2).^2.*cos(pi*freq*tauVec*1e-9 + phi);
		P0 = (exp(-dPhi));
        env = exp(-(tVec/T2).^3);
        
        P0 =1/2*(1 +  P0.*env);
        figure(pltfig);
        plot(tVec, P0, 'r', tVec, data, 'b');
        drawnow();
        pause(.1);
		resid = data - P0;
	end

end