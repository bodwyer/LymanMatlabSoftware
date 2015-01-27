clear y1mat y1 x xs yRR yav yfit yflag ynorm yref yrefwin ysig

%%% Set parameters
STDthresh = 5;
Npi = 124; % Number of pi pulses
Ispace = 1e-7*Npi; % Initial spacing between marker pulses (s)
linescrossed = 0; % Lines crossed = 0, not crossed = 0;

%% Data
StartT = BackupExp.MetaData.StartDateTime; % scan start time
StartTime = datestr(StartT,'yyyy-mm-dd HH:MM:SS'); % scan start time string
StartDay = datestr(StartT,'yyyy-mm-dd'); % scan start day
Samp =  BackupExp.MetaData.Samples; % samples per point
StartingKCounts = BackupExp.MetaData.InitialCounts/1e3; % starting counts
% MWfreq = gExperiment.Parameters.MWFreq; % MW freq
% MWpower = gExperiment.Parameters.MWPower; % MW freq
MWFreq = 0;
MWpower = 0;
[pathstr, name, ext] = fileparts(BackupExp.PulseSequence.file);
Seq = name; % pulse sequence name

x = (BackupExp.TempData.Sweep(1).X)';

MaxAv = BackupExp.MetaData.Average; % max number of avgs
for j=1:MaxAv
    if BackupExp.TempData.AVE(1,j).X(1,1).xmean(1) == 0
        break;
    end
end
NumAv = j-1; % actual number of averages

numReadWin = numel(BackupExp.TempData.X);
jumps = 0;
for j=1:numReadWin
% for j = 2:2

%     y{j} = Samp*(gExperiment.Data.X(j).xmean)';
    for i = 1:NumAv
        y1{j,i} = (BackupExp.TempData.AVE(i).X(j).xmean)';
        y1mat(:,i) = y1{j,i};
    end

    % Flag outliers and zero elements
    for i = 1:length(x)
        for k = 1:NumAv
%             if y1mat(i,k) > filterthresh*median(y1mat(:,k)) || y1mat(i,k) < median(y1mat(:,k))/filterthresh
                if y1mat(i,k) > STDthresh*std(y1mat(:,k))+median(y1mat(:,k)) || y1mat(i,k) < median(y1mat(:,k))-STDthresh*std(y1mat(:,k))
                y1mat(i,k) = 0;
                jumps = jumps+1;
            end
        end
        yflag(i) = length(find(y1mat(i,:)));
    end
    ytemp{j} = y1mat;
    yav{j} = sum(y1mat,2)./yflag';
    ystd{j}=std(y1mat');
end

%%% Output number of jumps
jumps

% yref = (yav{3}+yav{4})/2;
yref = yav{3};
yd = yav{4};
% yref = (yav{1}+yav{3}+yav{4})/3;
% hold on
% grid on


% x = 10^9*(x+2.418e-5)/372;
x = 10^6*(x+Ispace);
y = (yav{2}-yd)./(yref-yd);
% y = (17/39)*y17+(22/39)*y;

xs = min(x):(max(x)-min(x))/100:max(x);

%% Do fit
fttol = 1e-11; % fit tolerance
ft1_ = fittype('a - a.*exp(-(g*x)^c)',...
'dependent',{'y'},'independent',{'x'},...
'coefficients',{'a','g','c'});
fo1_ = fitoptions('method','NonlinearLeastSquares','MaxFunEvals',2000,'MaxIter',2000,...
'Startpoint',[0.5 1/50 2],'Lower',[0 0 1],'Upper',[1 Inf 3],'TolFun',fttol);
cf1 = fit(x,y,ft1_,fo1_);

yfit = feval(cf1,xs);

Berr = confint(cf1,0.682);

if linescrossed == 1
    Bext = 10^-4*(MWFreq + 2.87e9)/2.8e6;
else
    Bext = 10^-4*(2.87e9-MWFreq)/2.8e6;
end


%% Save file

today = datestr(now,'yyyy-mm-dd');
cwd = pwd; % current directory
FileName = 'Not Saved';

% change directory
ppp = mfilename('fullpath');
cd(fileparts(ppp));
cd('C:\Users\User\Documents\Lukin Lab\Fitting T2\NV1'); % saved data directory
% cd('/Users/igorlovchinsky/Desktop/NV Depths/');


% if exist(StartDay,'dir') == 0 % check if today's folder already exists
%     mkdir(StartDay);
% end
% cd(StartDay);

% find the last file in directory
FileList = dir; FileNum = zeros(length(FileList),1);
for j=1:length(FileList)
    [~, name, ext] = fileparts(FileList(j).name);
    if strcmp(ext,'.mat')
        [~,pos] = textscan(name,'%[^_]'); % scan until '_'
        FileNum(j) = str2double(name(pos+2:end)); % get number of file
    end
end
LastFileNum = max(FileNum);

% dialog box for file save
[FileName,PathName,FilterIndex] = uiputfile('*.mat','Diamond Data Save',strcat('XY_',num2str(LastFileNum+1,'%05.0f')));
if FilterIndex ~= 0
    save(FileName,'BackupExp'); % save data in file
else
    FileName = 'Not Saved';
end

cd(cwd); % change back to starting directory

%% Plot Data

scrsz = get(0,'ScreenSize');
figure('Color',[1 1 1],'Position',[20 0.05*scrsz(4) 0.7*scrsz(3) 0.8*scrsz(4)]);

subplot(2,1,1)
set(gca,'Fontweight','bold','FontSize',14);
plot(x,y,'go-','Linewidth',2)
hold on
plot(xs,yfit,'k','LineWidth',2)
grid on
xlabel('Free Sequence Time (us)','FontSize',16,'FontWeight','bold')
ylabel('Normalized Contrast','FontSize',16,'FontWeight','bold')
% title({'C13 signal on Sample 96'; sprintf(NV); sprintf(Npi); sprintf('NV contrast: %.4f',contrast)},'FontWeight','bold','FontSize',18);
legend('Data','Fit');
xlim([0,max(xs)])
ylim([0,0.7])
title({['Fit model: ',formula(cf1)];...
    ['External Magnetic Field: ',num2str(10^4*Bext,4),' G, Decoherence Rate: ', num2str(10^6*cf1.g,3),' +/- ', num2str(10^6*Berr(2,2)-10^6*cf1.g,3),' Hz'];...
    ['Number of pi-pulses: ',num2str(Npi-1),', Fit power: ',num2str(cf1.c,3),' +/- ',num2str(Berr(2,3)-cf1.c,2)]},...
    'FontWeight','bold','FontSize',16,'Interpreter','none')


subplot(2,1,2)
set(gca,'Fontweight','bold','FontSize',14);
plot(x,yav{2},'go-','Linewidth',2)
hold on
plot(x,yav{1},'ro-','Linewidth',2)
plot(x,yav{3},'bo-','Linewidth',2)
plot(x,yav{4},'ko-','Linewidth',2)
grid on
xlabel('Total Sequence Time (us)','FontSize',16,'FontWeight','bold')
ylabel('Fluorescence','FontSize',16,'FontWeight','bold')
xlim([0,max(x)])
title({['Scan start: ',StartTime,', ',FileName];...
        ['Sequence: ',Seq];...
        ['Avgs: ',num2str(NumAv),', Samp/pt: ',num2str(Samp),', Start NV cts: ',...
        num2str(StartingKCounts,'%.1f'),' kcts, MWpwr: ',num2str(MWpower),' dBm, MWfreq: ',num2str(MWfreq/1e9,'%.5f'),' GHz']},...
        'FontWeight','bold','FontSize',16,'Interpreter','none')

