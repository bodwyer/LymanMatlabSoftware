function [ signal ] = inverseT2_fitall(a, tau)
global signal
global as bs
% function [ invT2 ] = inverseT2( n, Bstd, gamma)
%Given the number of pulses, n, <B^2>, and gamma, this function will find
%the inverse of the coherence time, or 1/T2. It will also fit for k, the
%power that T2 is raised to.
% 
Bstd=a(1)*10^-11
gamma=a(2)*10^6
as=a(3:10);
% bs=a(11:18);
tau=tau*10^-6;

%define variables
g = 2;
uB = 9.274 * 10^-24;
hbar = 1.054 * 10^-34;

D=size(tau);
y=zeros(D(1),D(2));
n = [1,11,27,59,123, 187, 371, 507];

% taupoints = 10;
% 

% t2=zeros(1,length(n));
% k=zeros(1,length(n));

for j=1:D(1) %rows in tau  
chi=zeros(1,D(2));
    
% tau(j,:)
% length(tau(j,:))
for i=1:length(tau(j,:))
    
w = linspace(1,10*2*pi/(tau(j,i)/(n(j)+1)),100000);

Sbw= 2*Bstd*gamma./(w.^2+gamma^2);
F=2*(sin(w*tau(j,i)/2).*tan(w*tau(j,i)/(2*(n(j)+1)))).^2./w.^2;
% plot(w,F)
% hold on
integrand=Sbw.*F;

chi(i) = (g*uB/hbar)^2*1/(2*3.14159)*trapz(w,integrand);

% plot(w,Sbw,w,F)
% hold on

end

% chi
% y(j,:) = 1/2.*(1.-exp(-1.*chi));
% y(j,:) = as(j)-bs(j).*exp(-1.*chi);
y(j,:) = as(j)*(1-exp(-1.*chi));

% figure
% plot(n*tau,chi)



% plot(n(j)*tau,signal)
% hold on
% plot(cf1)
end

signal = y;



end

