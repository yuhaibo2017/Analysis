function distsi(si,type,dist,bin)
% distsi.m %
% 2011-04-09 by Zhang Li
% Draw Size Tuning Statistics

extent = si.info.extent;
delay = si.info.delay;
stiend = si.info.stiend;
batchpath = si.info.batchpath;
unit = si.info.unit;
stitype = si.info.stitype;
freqrange = si.info.freqrange;
ssttype = si.info.ssttype;

if nargin < 2
    type = 'sis';
end
if nargin < 3
    switch type
        case {'sis','sif','sisc'}
            dist = si.(type);
            bin = si.bin;
            xu = 'SI';
        case 'sc'
            dist = si.(type);
            bin = 0:0.1:1.4;
            xu = 'F1/F0';
        case {'fgs','fgf','fgsc'}
            dist = si.(type);
            bin = (0:0.1:1);
            xu = 'Fit Adj-R^2';
        case {'maxs','mins','maxf','minf','maxsc','minsc','res','ris','ref','rif','resc','risc'}
            dist = si.(type);
            bin = (0:0.1:1)*stiend;
            xu = 'Stimulus Diameter (degrees)';
        case 'site'
            dist = si.(type);
            bin = (0:0.1:1)*(max(dist)+100);
            xu = 'Recording Site Depth (\mum)';
    end
end
yu = 'Number of Cells';

n = length(dist);
d = histc(dist,bin);
y = d(1:end-1);
md = median(dist);
ylim = max(y);
bw = bin(2)-bin(1);
x = bin(1:end-1)+bw/2;


textsize = 14;
fig_name = ['SBST_',num2str(extent),'_',num2str(delay),'_',num2str(stiend),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'_',type,'_',ssttype];
scnsize = get(0,'ScreenSize');
output{1} = batchpath;
output{2} = fig_name;
output{3} = unit;
output{4} = stitype;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hWin = figure('Units','pixels',...
    'Position',[120 35 scnsize(3)*0.88 scnsize(4)*0.86], ...
    'Tag','Win', ...
    'Name',fig_name,...
    'CloseRequestFcn',@Win_CloseRequestFcn,...
    'NumberTitle','off',...
    'UserData',output);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mcolorb = [0.15 0.25 0.55];
mcolordb = [0.15 0.25 0.45];
mcolorg = [0.25 0.85 0.35];
mcolorr = [0.85 0.15 0.05];

switch type
    case 'site'
        hB = barh(x,y,1);
        set(hB,'edgecolor','none','facecolor',mcolorb);
        hold on;
        plot([0 ylim],[md md],'k','Linewidth',2);
        set(gca,'LineWidth',2,'FontSize',textsize,'tickdir','out',...
            'XLim',[0 ylim],'box','off','YDir','reverse');
        temp = xu;
        xu = yu;
        yu = temp;
    otherwise
        hB = bar(x,y,1);
        set(hB,'edgecolor','none','facecolor',mcolordb);
        hold on;
        plot([md md],[0 ylim],'k','Linewidth',2);
        set(gca,'LineWidth',2,'FontSize',textsize,'tickdir','out','YLim',[0 ylim],'box','off');
end


annotation('textbox',[0.18 0.8 0.1 0.1],'FontSize',textsize,'string',['n=',num2str(n)],'LineStyle','none');
ylabel(yu,'FontSize',textsize);
xlabel(xu,'FontSize',textsize);
title(fig_name,'Interpreter','none','FontWeight','bold','FontSize',textsize);
