function Network_Synchronization_ForMattsCode_MS(folderpath)

%% Initialiaze 

SourceFolder = [folderpath];
TargetFolder = [folderpath filesep 'synchrodata'];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%get & load .mat processed_analysis file in the folder
afile = dir([SourceFolder filesep 'processed_analysis_spikech*.mat']);
load([SourceFolder filesep afile.name])

%load([SourceFolder filesep 'processed_analysis_reg.mat']);
initanalysisdata=analysis;

%% Compute functional connectivity based on Matt's code (phase difference)

for cindex=1:numel(analysis)             %for all conditions
    clear SI PI
    SI=NaN;
    PI=NaN;
    
    %Compute phase and synchronization
    [A,P,S,phi]=FC_phase_Mod(analysis(cindex).spikedata.rstr',[0 1],[],[],0);
    SI=mean(nanmean(S));
    PI_avg=nanmean(S,1);
    PI_std=nanstd(S,1);

    %update fields in analysis file   
    analysis(cindex).synchrodata.phase=phi;
    analysis(cindex).synchrodata.S=S;
    analysis(cindex).synchrodata.SI=SI;
    analysis(cindex).synchrodata.PI_avg=PI_avg;
    analysis(cindex).synchrodata.PI_std=PI_std;
    
    close all
    
    % Save new analysis file with network data
    save([TargetFolder filesep afile.name(1:end-4) '_synchro.mat'],'analysis');
end

%Save new analysis file with connectivity data
save([TargetFolder filesep afile.name(1:end-4) '_synchro.mat'],'analysis');

