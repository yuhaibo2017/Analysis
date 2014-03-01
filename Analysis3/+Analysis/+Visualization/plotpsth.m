function [ output_args ] = plotpsth( data,param,range,bw,trial,condition,cell,vp,istrialaverage )
%PLOTPSTH Summary of this function goes here
%   Detailed explanation goes here

import Analysis.* Analysis.Visualization.*

spike = data.spike;
subparam = param.SubjectParam;
maxpreicidur = str2double(subparam.MaxPreICIDur);
maxsuficidur = str2double(subparam.MaxSufICIDur);
maxconddur = str2double(subparam.MaxCondDur);
datafile = param.DataFile;
vp = visprofile(vp);
if ischar(range)
    range = [-maxpreicidur maxconddur + maxsuficidur];
end
if ischar(bw)
    bw = 5; % ms
end

trialn = length(trial);
if trialn == 1
    if trial == 0
        trialn = size(spike,1);
        trialstring = 'all';
        trial = 1:trialn;
    else
        trialstring = num2str(trial);
    end
else
    trialstring = num2str(trial);
end
if istrialaverage
    trialstring = ['A',trialstring];
end
condn = length(condition);
if condn == 1
    if condition == 0
        condn = size(spike,2);
        condstring = 'all';
        condition = 1:condn;
    else
        condstring = num2str(condition);
    end
else
    condstring = num2str(condition);
end
celln = length(cell);
if celln == 1
    if cell == 0
        celln = size(spike,3);
        cellstring = 'all';
        cell = 1:celln;
    else
        cellstring = num2str(cell);
    end
else
    cellstring = num2str(cell);
end

data = psth(data,param,range,bw);
pdata = data(trial,condition,cell);

plotname = [datafile,'_T',trialstring,'_C',condstring,'_U',cellstring,...
    '_B',num2str(bw),'_PSTH'];
hf = newfig(plotname);
if istrialaverage
    pdata = cell2mat(pdata);
    Y = mean(pdata);
    Yse = ste(pdata);
    ylim = 1.1*max(Y)+0.5;
    X = range(1):bw:range(2);
    X = X(1:end-1);
    
    hb = bar(X,Y,'histc');
    set(hb,'edgecolor','none','facecolor',vp.barcolor);
    set(gca,'tickdir','out','LineWidth',vp.axiswidth,'FontSize',vp.textsize,'box','off',...
        'XLim',range,'YLim',[0 ylim]);
    title(plotname,'Interpreter','none','FontWeight','bold','FontSize',vp.titlesize);
    ylabel('Firing Rate (spikes/sec)','FontSize',vp.textsize);
    xlabel('Time (ms)','FontSize',vp.textsize);
else
    for i = 1:trialn
        
    end
end

end

