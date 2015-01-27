function NoiseBathFith(varargin)

	if length(varargin) == 0
		% Load these as NV list
		NV = struct();
		NV.nPulses = [32, 64];
		NV.T2 = [35e3, 81e3];
		NV.T2Err = [2.39e3, 4.45e3];
		NVList = {NV};
	end

	for in = 1:length(NVList)
		NV = NVList{in};
		figErr = figure();
		errorbar(NV.nPulses, NV.T2, NV.T2Err);

		guess = [3.2, 2];
		alpha = 0.318;

		nPulses = NV.nPulses;
		T2 = NV.T2;
		T2Err = NV.T2Err;
		[NVfit, R, J, Covb] = nlinfit(nPulses', T2', @InverseT2Fit, guess, 'Weights', T2Err');

		ci1 = nlparci(NVfit,R,'Jacobian',J,'alpha',alpha);

		NVfit

		invT2 = InverseT2Fit(nPulses, T2);


		set(gca,'xscale','log','Fontweight','bold','FontSize',14)
		set(gca,'yscale','log','Fontweight','bold','FontSize',14)

		hold on;
% 		plot(nPulses, k, 'r');
		plot(nPulses, invT2, 'm');
	end

end



