function [nactivesegments,nactivecells]=EliminateNonactiveAstrosFC(folderpath)

%fixes matrices that had noisy astrocytes for BE 566 Project 3
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
afile = dir([SourceFolder filesep 'processed_analysis_astrocheck_spikech_actfilt_v2.mat']);
load([SourceFolder filesep afile.name])
analysis_filt=analysis;
%% Eliminate neurons that don't have any data in any condition

for cindex=1:length(analysis_filt)-1
    if cindex ~= 3
        S_old = analysis_filt(cindex).FC.S_multi;
        A_old = analysis_filt(cindex).FC.A_multi;
        S_new = S_old;
        A_new = A_old;
        nadist_old = analysis_filt(cindex).FC.na_dist;
        nadist_new = nadist_old;
        adist_old = analysis_filt(cindex).FC.a_dist;
        adist_new = adist_old;
        
        nneuros = length(analysis_filt(cindex).FC.S);
        toremove=analysis_filt(cindex).activityfilterdata.nonactiveastros;
        toremove=toremove+nneuros;
        
        %remove the nonactive astro indices
        S_new(toremove,:)=NaN;
        S_new(:,toremove)=NaN;
        S_new=S_new(~isnan(S_new));
        S_new=reshape(S_new,sqrt(length(S_new)),sqrt(length(S_new)));
        
        %do same for A
        A_new(toremove,:)=NaN;
        A_new(:,toremove)=NaN;
        A_new=A_new(~isnan(A_new));
        A_new=reshape(A_new,sqrt(length(A_new)),sqrt(length(A_new)));
        
        active_astros = analysis_filt(cindex).activityfilterdata.activeastros;
        %for na dist, dimensions are NxA, so remove astro columns
        nadist_new(:,analysis_filt(cindex).activityfilterdata.nonactiveastros)=NaN;
        nadist_new=nadist_new(~isnan(nadist_new));
        nadist_new=reshape(nadist_new,nneuros,length(active_astros));
        
        astro_group = analysis_filt(cindex).FC.astro_group;
        astro_group = astro_group(active_astros,:); %get rid of nonactive cells
        adist_new=adist_new(active_astros,active_astros);
        
        analysis_filt(cindex).FC.S_multi=S_new;
        analysis_filt(cindex).FC.A_multi=A_new;
        analysis_filt(cindex).FC.na_dist=nadist_new;
        analysis_filt(cindex).FC.a_dist=adist_new;
        analysis_filt(cindex).FC.astro_group=astro_group;
        
        if ~isempty(active_astros)
            analysis_filt(cindex).FC.S_as=S_new(nneuros+1:end);
            analysis_filt(cindex).FC.A_as=A_new(nneuros+1:end);
        else
            analysis_filt(cindex).FC.S_as=[];
            analysis_filt(cindex).FC.A_as=[];
        end
            
    end
end

% Save new analysis file with filtered data
analysis=analysis_filt;
save([TargetFolder filesep afile.name(1:end-7) '_v3.mat'],'analysis');
nactivesegments=length(active_astros);
nactivecells=length(unique(astro_group(:,2)));
