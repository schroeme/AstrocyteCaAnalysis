function Network_Synchronization_Alex_MS(folderpath,parindex)

%% Initialiaze 
SourceFolder = [folderpath];
TargetFolder = [folderpath];%[folderpath filesep 'synchrodata_AlexMethod'];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

% %get & load .mat processed_analysis file in the folder
% files = dir([SourceFolder filesep 'processed_analysis*.mat']);
% load([SourceFolder filesep files.name])
% %load([SourceFolder filesep 'processed_analysis_reg_netw.mat']);
% 
% clear phase
% for cindex=1:numel(analysis)             %for all conditions
%  phase{cindex}=analysis(cindex).FC.phase;
% end

%get & load .mat processed_analysis file in the folder
load([SourceFolder filesep 'processed_analysis_inj_spikech_actfilt.mat'])

%load([SourceFolder filesep 'processed_analysis_reg.mat']);
initanalysisdata=analysis;

%% Calculate synchronization index

signiflevel=0.05;

for cindex=1:1%length(analysis)%for all conditions
    %if cindex ~= 3
        %extract phase
        phi = NaN(size(analysis(cindex).nspikedata.F_cell'));
        
        neurons = [analysis(cindex).neuroastro.other_neurons'; analysis(cindex).neuroastro.neighbor_neurons];
        %phi = zeros(50,size(analysis(cindex).spikedata.F_cell',2));

        if(parindex==1)
           parfor i=1:length(neurons) %size(analysis(cindex).nspikedata.F_cell,2)   %for all cells
           %parfor i=1:50
            try
               phi(i,:) = GetPhaseSpikes(analysis(cindex).nspikedata.baseline_locs{neurons(i)},size(analysis(cindex).nspikedata.F_cell,1));
            catch
               phi(i,:) = NaN;
            end
           end 
        else
           for i=1:length(neurons) %size(analysis(cindex).nspikedata.F_cell,2)      %for all cells
               try 
                phi(i,:) = GetPhaseSpikes(analysis(cindex).nspikedata.baseline_locs{neurons(i)},size(analysis(cindex).nspikedata.F_cell,1));
               catch
                   phi(i,:) = NaN;
               end
           end
        end
        analysis(cindex).Synchro.phase=phi;
        phase{cindex}=phi;
        clear phi

        clear phasecorr p_phasecorr phasercorr_bin SI SI_bin

        %calculate phase correlation and significance value
        [phasecorr p_phasecorr]=corr(phase{cindex}');

        %compute average correlation
        SI=nanmean(nanmean(phasecorr));

        %binarize correlation matrix
        phasecorr_bin=phasecorr;
        phasecorr_bin(p_phasecorr<signiflevel)=1;
        phasecorr_bin(p_phasecorr==signiflevel)=0;
        phasecorr_bin(p_phasecorr>signiflevel)=0;

        %compute average binary correlation
        SI_bin=mean(mean(phasecorr_bin));

        %update analysis file
        analysis(cindex).Synchro.phasecorrelation=phasecorr;
        analysis(cindex).Synchro.SI=SI;
        analysis(cindex).Synchro.SI_bin=SI_bin;
    %end
end

save([TargetFolder filesep 'processed_analysis_inj_spikech_actfilt_S'],'analysis');


