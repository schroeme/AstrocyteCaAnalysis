function EliminateNonactiveNeurons_Alex_MS(folderpath)

%% Initialiaze 
% SourceFolder = [folderpath filesep 'registration'];
SourceFolder = folderpath;
TargetFolder = folderpath;
% TargetFolder = [folderpath filesep 'filterdata'];
% 
% if ~exist(TargetFolder, 'dir')
%  mkdir(TargetFolder);
% end

%get & load .mat processed_analysis file in the folder
afile = dir([SourceFolder filesep 'processed_analysis_inj_spikech.mat']);
load([SourceFolder filesep afile.name])
analysis_filt=analysis;
%% Eliminate neurons that don't have any data in any condition

eindex=zeros(size(analysis(1).nspikedata.amplitudes,1),length(analysis));
aindex=zeros(size(analysis(1).aspikedata.amplitudes,1),length(analysis));
% size(eindex)
%find idices of neurons that are not active across conditions
for cindex=1:1%length(analysis)-1
    if cindex ~= 3
        Acurrent=analysis(cindex).nspikedata.amplitudes;    %grab current amplitudes/spikes data
        Acurrent_astro=analysis(cindex).aspikedata.amplitudes; 
        eindex(:,cindex)=~cellfun('isempty',Acurrent);
        aindex(:,cindex)=~cellfun('isempty',Acurrent_astro);
    end
end
nonactiveneurons=find(~any(eindex,2)); %find neurons that are active in any condition
length(nonactiveneurons)
activeneurons=find(any(eindex,2));
newN=size(analysis(1).nspikedata.amplitudes,1)-length(nonactiveneurons);

nonactiveastros=find(~any(aindex,2));%find astros that are active in any condition
disp(length(nonactiveastros))
activeastros=find(any(aindex,2));
newA=size(analysis(1).aspikedata.amplitudes,1)-length(nonactiveastros);

for cindex=1:1%length(analysis)-1
    if cindex ~= 3
%remove those neurons from analysis data structure
        analysis_filt(cindex).F_cell([nonactiveastros; nonactiveneurons],:)=[];
        analysis_filt(cindex).F_cell_scaled([nonactiveastros; nonactiveneurons],:)=[];
        analysis_filt(cindex).F_cell_delta([nonactiveastros; nonactiveneurons],:)=[];
        analysis_filt(cindex).nspikedata.rstr(:,nonactiveneurons)=[];
        analysis_filt(cindex).nspikedata.F_cell(:,nonactiveneurons)=[];
        analysis_filt(cindex).nspikedata.amplitudes=analysis(cindex).nspikedata.amplitudes(activeneurons);
        analysis_filt(cindex).nspikedata.Spikes_cell=analysis(cindex).nspikedata.Spikes_cell(activeneurons);
        analysis_filt(cindex).nspikedata.baseline=analysis(cindex).nspikedata.baseline(activeneurons);
        analysis_filt(cindex).nspikedata.baseline_locs=analysis(cindex).nspikedata.baseline_locs(activeneurons);
        analysis_filt(cindex).nspikedata.peak_locs=analysis(cindex).nspikedata.peak_locs(activeneurons);    

        analysis_filt(cindex).aspikedata.rstr(:,nonactiveastros)=[];
        analysis_filt(cindex).aspikedata.F_cell(:,nonactiveastros)=[];
        analysis_filt(cindex).aspikedata.amplitudes=analysis(cindex).aspikedata.amplitudes(activeastros);
        analysis_filt(cindex).aspikedata.Spikes_cell=analysis(cindex).aspikedata.Spikes_cell(activeastros);
        analysis_filt(cindex).aspikedata.baseline=analysis(cindex).aspikedata.baseline(activeastros);
        analysis_filt(cindex).aspikedata.baseline_locs=analysis(cindex).aspikedata.baseline_locs(activeastros);
        analysis_filt(cindex).aspikedata.peak_locs=analysis(cindex).aspikedata.peak_locs(activeastros);  

        analysis_filt(cindex).activityfilterdata.nonactiveneurons=nonactiveneurons;
        analysis_filt(cindex).activityfilterdata.activeneurons=activeneurons;

        analysis_filt(cindex).activityfilterdata.nonactiveastros=nonactiveastros;
        analysis_filt(cindex).activityfilterdata.activeastros=activeastros;
    end
end

% Save new analysis file with filtered data
analysis=analysis_filt;
save([TargetFolder filesep afile.name(1:end-4) '_actfilt.mat'],'analysis');

clear all