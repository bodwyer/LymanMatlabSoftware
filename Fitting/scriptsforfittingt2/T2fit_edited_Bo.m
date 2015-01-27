clear all
close all

global invT2
global k fita fitb

npulse = [1, 32, 64];

C1207001 = [17.9e3, 82.6e3, 154e3];
C1207001err = [3.78e3, 4.97e3, 12e3];


%C1207001 fits redone using (a-b*exp((x/t)^k)) instead of (a-a*exp((x/t)^k))





hold on

errorbar(npulse,C1207001,C1207001err,'ro','LineWidth',2,'MarkerFaceColor','r')

grid on
guess=[3.5,2];
alpha=0.318;
% [NV4,R,J,CovB]=nlinfit(npulse', C1207004', @inverseT2_edited, guess,'Weights',C1207004err');
% NV4
% ci4 = nlparci(NV4,R,'Jacobian',J,'alpha',alpha)
% hold on
% plot(npulse,invT2,'g')
% k4=k;
% fita4=fita;
% % fitb4=fitb;
% 
% [NV2,R,J,CovB]=nlinfit(npulse', C1207002', @inverseT2_edited, guess,'Weights',C1207002err');
% NV2
% hold on
% ci2 = nlparci(NV2,R,'Jacobian',J,'alpha',alpha)
% plot(npulse,invT2,'b')
% k2=k;
% fita2=fita;
% fitb2=fitb;

[NV1,R,J,CovB]=nlinfit(npulse', C1207001', @inverseT2_edited, guess,'Weights',C1207001err')
NV1
ci1 = nlparci(NV1,R,'Jacobian',J,'alpha',alpha)
hold on
plot(npulse,invT2,'r')
k1=k;
fita1=fita;
% fitb1=fitb;



set(gca,'xscale','log','Fontweight','bold','FontSize',14)
set(gca,'yscale','log','Fontweight','bold','FontSize',14)


plot(npulse,k1,'r')
hold on

