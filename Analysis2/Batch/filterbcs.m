function filterbcs(BCS,unit,stitype,freqrange)
% filterbcs.m %
% 2012-04-09 by Zhang Li
% Filter subset of batched centersurround result

exid = BCS{end,1}.exid;
extent = BCS{end,1}.extent;
delay = BCS{end,1}.delay;
issps = BCS{end,1}.issps;
pret = BCS{end,1}.pret;
post = BCS{end,1}.post;
rootpath = BCS{end,1}.rootpath;
batchpath = BCS{end,1}.batchpath;

sn = size(BCS,1)-1;
vs = ValidSessions(sn,rootpath,exid,'cs'); % exclude user defined invalid sessions

if strcmp(unit,'mu')
    un = 2;
else
    un = 3;
end
lfpn = 4;

if strcmp(stitype(1),'d')
    stype = 'drifting';
else
    stype = 'static';
end
if strcmp(stitype(2),'a')
    stitype = [stype,'_annular'];
else
    stitype = [stype,'_surround'];
end

% get valid non-empty sessions
vu = BCS(vs,un);
vf = BCS(vs,lfpn);
vui = cellfun(@(x)~isempty(x),vu);
vfi = cellfun(@(x)~isempty(x),vf);
vs = vs(vui & vfi);
% filter result from within valid sessions
vsn=1;
for i=vs
    furesult=[];
    ffresult=[];
    bffresult=[];
    sessioninfo = BCS{i,1};
    unitresult = BCS{i,un};
    lfpresult = BCS{i,lfpn};
    
    disp(['Filtering CenterSurround Batch Result --> Session ',num2str(i)]);
    
    chn = size(unitresult,1);
    sortn = size(unitresult,2);
    
    for ch = 1:chn
        
        % filter unit result
        for sort = 1:sortn
            cur = unitresult{ch,sort};
            if ~isempty(cur)
                fbn=1;
                for bn = 1:length(cur.block)
                    if ~isempty(cur.block{bn}) && strcmp(cur.block{bn}.blocktype,stitype)
                        furesult{ch,sort}.block{fbn} = cur.block{bn};
                        if isfield(cur.block{bn},'scps')
                            for fn = 1:length(cur.block{bn}.sctc)
                                if cur.block{bn}.sctc{fn}.freqrange==freqrange
                                    furesult{ch,sort}.block{fbn}.sctc = cur.block{bn}.sctc{fn};
                                end
                            end
                        end
                        fbn = fbn + 1;
                    end
                end
            end
            
        end
        
        % filter lfp result
        cfr = lfpresult{ch,1};
        if ~isempty(cfr)
            fbn=1;
            for bn = 1:length(cfr.block)
                if ~isempty(cfr.block{bn}) && strcmp(cfr.block{bn}.blocktype,stitype)
                    ffresult{ch,1}.block{fbn} = cfr.block{bn};
                    for fn = 1:length(cfr.block{bn}.wtc)
                        if cfr.block{bn}.wtc{fn}.freqrange==freqrange
                            ffresult{ch,1}.block{fbn}.wtc = cfr.block{bn}.wtc{fn};
                        end
                    end
                    fbn = fbn + 1;
                end
            end
        end
        
    end
    
    
    % have valid filtered result
    if ~isempty(furesult) && ~isempty(ffresult)
        chn = size(furesult,1);
        sortn = size(furesult,2);
        
        % choose only one best block data for each session according to response se
        for ch = 1:chn
            cfr = ffresult{ch,1};
            
            for sort = 1:sortn
                cur = furesult{ch,sort};
                if ~isempty(cur) && ~isempty(cfr)
                    vfbn = length(cur.block); % valid filter block number
                    fg = zeros(1,vfbn);
                    % get each filter block sum of se, sumed of both unit and lfp
                    for bn = 1:vfbn
                        cbid = cur.block{bn}.blockid;
                        fbi = cellfun(@(x)x.blockid == cbid,cfr.block);
                        fg(bn) = sum(sum(cur.block{bn}.setc)) + sum(sum(cfr.block{fbi}.wtc.setc));
                    end
                    bbi = find(fg==min(fg)); % best fit block index
                    bbid = cur.block{bbi}.blockid; % best block id
                    disp(['Channal ',num2str(ch),' - Sort ',num2str(sort),' --> Choose Best Block ID: ',num2str(bbid),', Drop ',num2str(vfbn-1),' Other Blocks']);
                    furesult{ch,sort}.block = cur.block{bbi};
                    
                    
                    % choose corresponding lfpresult block
                    for bn = 1:length(cfr.block)
                        if cfr.block{bn}.blockid == bbid
                            bffresult{ch,sort}.block = cfr.block{bn};
                        end
                    end
                    
                end
            end
            
        end
    end
    
    
    % save valid filter result
    if ~isempty(furesult) && ~isempty(bffresult)
        FBCS{vsn,1} = sessioninfo;
        FBCS{vsn,2} = furesult;
        FBCS{vsn,3} = bffresult;
        vsn = vsn + 1;
    end
    
end

FBCS{vsn,1} = BCS{end,1};
FBCS{vsn,1}.unit = unit;
FBCS{vsn,1}.stitype = stitype;
FBCS{vsn,1}.freqrange = freqrange;

save(fullfile(batchpath,...
    ['FBCS_',num2str(extent),'_',num2str(delay),...
    '_',num2str(issps),'_',num2str(round(pret*10)),'_',num2str(round(post*10)),...
    '_',unit,'_',stitype,'_',num2str(freqrange),'.mat']),...
    'FBCS');
