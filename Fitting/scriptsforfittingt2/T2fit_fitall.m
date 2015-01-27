% clear all -except xdata ydata
% close all -except xdata ydata
global signal
global as bs

% npulse = [1,11,27,59,123, 187, 371, 507];
% 
% C1207001 = [2.3e5 7.31e4 4.24e4 2.38e4 1.67e4 1.15e4 9.25e3 7.14e3];
% C1207001err = [9.12e3 3.68e3 2.65e3 1.78e3 449 606 470 192];
% PC1207001 = [1.48 1.7 1.56 1.68 2.16 2.33 1.6 1.94];
% PC1207001err = [0.12 0.2 0.21 0.27 0.16 0.37 0.18 0.14];
% 
% %C1207001 fits redone using (a-b*exp((x/t)^k)) instead of (a-a*exp((x/t)^k))
% C1207001_ab = [2.22e5 7.7e4 4.63e4 2.55e4 1.64e4 1.17e4 9.19e3 7.47e3];
% C1207001err_ab = [1.2e4 6.47e3 5.64e3 3.53e3 635 977 1.27e3 591];
% PC1207001_ab = [1.58 1.48 1.36 1.44 2.31 2.17 1.62 1.77];
% PC1207001err_ab = [0.18 0.25 0.29 0.41 0.29 0.56 0.46 0.3];
% 
% C1207002 = [2.95e5 9.91e4 8.01e4 4.47e4 2.82e4 2.08e4 1.64e4 1.3e4];
% C1207002err = [2.96e4 4.83e3 3.31e3 1.68e3 1.21e3 625 773 254];
% PC1207002 = [1.17 1.35 1.9 1.8 1.69 1.9 1.71 2.42];
% PC1207002err = [0.2 0.12 0.2 0.17 0.17 0.15 0.24 0.19];
% 
% C1207004 = [2.23e5 6.72e4 3.84e4 2.78e4 1.86e4 1.58e4 1.12e4 9.71e3];
% C1207004err = [1.14e4 6e3 1.34e3 942 2.14e3 908 662 515];
% PC1207004 = [1.42 1.4 1.54 1.6 1.1 1.62 1.38 1.51];
% PC1207004err = [0.14 0.24 0.11 0.11 0.18 0.21 0.17 0.19];
% 
% hold on

% errorbar(npulse,C1207001,C1207001err,'ro','LineWidth',2,'MarkerFaceColor','r')
% errorbar(npulse,C1207001_ab,C1207001err_ab,'mo','LineWidth',2,'MarkerFaceColor','m')
% errorbar(npulse,C1207004,C1207004err,'go','LineWidth',2,'MarkerFaceColor','g')
% errorbar(npulse,C1207002,C1207002err,'bo','LineWidth',2,'MarkerFaceColor','b')
% grid on
% guess=[3.5,2,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5];
guess=[3.5,2,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5];

% NV4=nlinfit(npulse', C1207004', @inverseT2_edited, guess,'Weights',C1207004err')
% hold on
% plot(npulse,invT2,'g')
% k4=k;
% fita4=fita;
% fitb4=fitb;

[NV4,resnorm,residual,exitflag,output,lambda,jacobian]=lsqcurvefit(@inverseT2_fitall,guess, xdata, ydata);
NV4
alpha=0.318 %for 1 sigma confidence
ci=nlparci(NV4,residual,'Jacobian',jacobian,'alpha',alpha)

figure
plot(xdata',ydata')
hold on
plot(xdata',signal')

as
% bs

% hold on
% plot(npulse,invT2,'b')
% 
% set(gca,'xscale','log','Fontweight','bold','FontSize',14)
% set(gca,'yscale','log','Fontweight','bold','FontSize',14)

% figure
% errorbar(npulse,PC1207001,PC1207001err,'ro','LineWidth',2,'MarkerFaceColor','r')
% hold on
% errorbar(npulse,PC1207001_ab,PC1207001err_ab,'mo','LineWidth',2,'MarkerFaceColor','m')
% hold on
% errorbar(npulse,PC1207004,PC1207004err,'go','LineWidth',2,'MarkerFaceColor','g')
% hold on
% errorbar(npulse,PC1207002,PC1207002err,'bo','LineWidth',2,'MarkerFaceColor','b')
% hold on
% plot(npulse,k1,'r')
% hold on
% plot(npulse,k1_ab,'m')
% hold on
% plot(npulse,k2','b')
% hold on
% plot(npulse',k4','g')

% fita1
% % fitb1
% fita1_ab
% % fitb1_ab
% fita2
% % fitb2
% fita4
% % fitb4

% xdata=[x_xy1';x_xy11';x_xy27';x_xy59';x_xy123';x_xy187';x_xy371';x_xy507']
% ydata=[y_xy1';y_xy11';y_xy27';y_xy59';y_xy123';y_xy187';y_xy371';y_xy507'];

dy123=y.*sqrt(((sqrt(yav{2})/sqrt(Samp*NumAv)).^2+(sqrt(yav{4})/sqrt(Samp*NumAv)).^2)./(yav{2}-yav{4}).^2+((sqrt(yav{3})/sqrt(Samp*NumAv)).^2+(sqrt(yav{4})/sqrt(Samp*NumAv)).^2)./(yav{3}-yav{4}).^2) %for XY signal
% dy1=y.*sqrt(((sqrt(yav{1})/sqrt(Samp*NumAv)).^2+(sqrt(yav{2})/sqrt(Samp*NumAv)).^2)./(yav{1}-yav{2}).^2+((sqrt(yav{3})/sqrt(Samp*NumAv)).^2+(sqrt(yav{2})/sqrt(Samp*NumAv)).^2)./(yav{3}-yav{2}).^2) %for echo signal
%  dy=[dy1';dy11';dy27';dy59';dy123';dy187';dy371';dy507']

stdy123=abs(y.*sqrt(1/NumAv*(((ystd{2}').^2+(ystd{4}').^2)./(yav{2}-yav{4}).^2+((ystd{3}').^2+(ystd{4}').^2)./(yav{3}-yav{4}).^2))) %for XY signal
%  stdy1=abs(y.*sqrt(1/NumAv*(((ystd{1}').^2+(ystd{2}').^2)./(yav{1}-yav{2}).^2+((ystd{3}').^2+(ystd{2}').^2)./(yav{3}-yav{2}).^2))) %for echo signal
% stdy=[stdy1';stdy11';stdy27';stdy59';stdy123';stdy187';stdy371';stdy507']

% chi_square=(sum(residual(:).^2./stdy(:).^2))/DOF