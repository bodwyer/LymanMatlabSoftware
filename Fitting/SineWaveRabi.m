function [plt] = SineWaveRabi(params, xVec)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Produces a sine wave of the form A*sin(w*x + delta) + C
% 
% Arguments: 
%
% * params: vector of length 4 supplying parameters for sine wave
% * xVec: vector of x values for sine wave
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	A = params(1); % Amplitude
	t = params(2); % angular frequency
	delta = params(3); % phase
	C = params(4); % Offset

	w = pi/(t);

	plt = A*cos(w*xVec + delta) + C;

end