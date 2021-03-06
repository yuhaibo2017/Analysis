% 2007 April 30 by Zhang Li
% Add this directory in the matlab path
% DataDir is the Directory in which you stored the Data Files

% Grating Orientation and Direction Selectivity Tuning Function

function Grating()
DataDir=input('Input The Full Data Directory Name : ','s');
cd (deblank(DataDir));
clear DataDir;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Experiment Block Name without suffix and file name extention which is '.csv'
BlockName=input('Input the Experiment Block Name : ','s');
% For Different Recording Conditions
RecordType=input('Input Recording Types -- Single(1) or Double(2) : ');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for rt=1:RecordType
    BlockName_Mark=['_',BlockName,'_mark'];
    if (RecordType==1)
        BlockName_Snip=['_',BlockName,'_snip_os'];
    else
        BlockName_Snip=['_',BlockName,'_sp',int2str(rt),'__os'];
    end


ReadData_Grating;
ProcessMarker_Grating;

for z=-1:Max_Sort
    if(z~=-1)
        evalc(['spike=Spike_',int2str(z),]);
        disp(['    For Spike_',int2str(z),'  !']);
    else
        disp('    For Spike_all  !');
    end
    ProcessSpike_Grating;       % For spikes with no sorting(z=-1) and each SortCode(z>-1)
    VisualizeResult_Grating_TuningCurve;
end
end


