function [ invT2 ] = InverseT2Fit(a, n)

Bstd=a(1)*10^-11
gamma = a(2)*10^6;

%define variables
g = 2;
uB = 9.274 * 10^-24;
hbar = 1.054 * 10^-34;
taupoints = 10;

chi=zeros(1,length(taupoints));
t2=zeros(1,length(n));
k=zeros(1,length(n));

for j=1:length(n)  
    
	%set spacing for tau
	tau_min = 1e-7;  %minimum free precession time
	% tau_max = 8e-6; %maximum free precession time
	tau_max = 2e-5*n(j)^(1/2)/n(j); %maximum free precession time
	tau = linspace(tau_min,tau_max,taupoints);

	    
	for i=1:length(tau)
	    
		w = linspace(1,10*2*pi/tau(i),100000);

		Sbw= 2*Bstd*gamma./(w.^2+gamma^2);
		F=2*(sin((n(j)+1)*w*tau(i)/2).*tan(w*tau(i)/2)).^2./w.^2;
		integrand=Sbw.*F;

		chi(i) = (g*uB/hbar)^2*1/(2*3.14159)*trapz(w,integrand);


	end




	signal = 1/2.*(1.+exp(-1.*chi));
	fttol = 1e-11; % fit tolerance
	ft1_ = fittype('a + a.*exp(-(x/t)^k)',...
	'dependent',{'y'},'independent',{'x'},...
	'coefficients',{'a','t','k'});
	fo1_ = fitoptions('method','NonlinearLeastSquares','MaxFunEvals',2000,'MaxIter',2000,...
	'Startpoint',[0.5 1e-5 1],'Lower',[0 0 1],'Upper',[1 Inf 3],'TolFun',fttol);
	cf1 = fit(n(j)*tau',signal',ft1_,fo1_);



	fita(j) = cf1.a;
	% fitb(j) = cf1.b;
	k(j) = cf1.k;
	t2(j)=cf1.t;


	end

invT2 = 1./t2';



end

