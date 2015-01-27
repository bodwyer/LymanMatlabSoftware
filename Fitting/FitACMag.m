function [bestFitParams] = FitACMag(tVec, data)
		% Constants
	mu_b = 9.27401e-21; % Bohr maneton, CGS. Erg/Gauss
	g = 2.002319; % Electron g factor
    hbar = 1.054572e-27; % Planks constant, erg*second
    preFactor = mu_b*g/hbar;
    freq = 5.05e6; % 5.05 MHz

    BVec = linspace(.0001, 3, 10000);
    resVec = zeros(size(BVec));
    
    for ib = 1:length(BVec)
        B = BVec(ib);
        res = MagFit(B, data, tVec);
        resVec(ib) = res;
    end
    
    figure
    plot(BVec, resVec);
    


	 function [res] = MagFit(params, plt, tau)
	 	tau = tau*1e-9;
	 	B = params(1);
	 	dPhi = (2*preFactor*B/(pi*freq))*(sin(pi*freq*tau/2).^2).*cos(pi*freq*tau);
	 	P = (1 + cos(dPhi))./2;
	 	res = sum((plt - P).^2);

	 end
end


