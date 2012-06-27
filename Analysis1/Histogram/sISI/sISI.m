% sISI.m %
% 2007-06-09
% Zhang Li

% Successive InterSpike Interval Histogram(sISI) Function

function sISI()
DataDir=input('Input The Data Directory : ','s');
cd (deblank(DataDir));
clear DataDir;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BlockName=input('Input the Experiment Block Name : ','s');
% For Different Recording Conditions
RecordType=input('Input Recording Types -- Single(1) or Double(2) : ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for rt=1:RecordType
    BlockName_Mark=['_',BlockName,'_mark.csv'];
    if (RecordType==1)
        BlockName_Snip=['_',BlockName,'_snip'];
    else
        BlockName_Snip=['_',BlockName,'_sp',int2str(rt),'_'];
    end

ReadData_sISI;
ProcessMarker_sISI;

for z=-1:Max_Sort
    if(z~=-1)
        evalc(['spike=Spike_',int2str(z),]);
        disp(['    For Spike_',int2str(z),'  !']);
    else
        disp('    For Spike_all  !');
    end
    ProcessSpike_sISI;       % For spikes with no sorting(z=-1) and each SortCode(z>-1)
    VisualizeResult_sISI;
end
end
