function [nastros,nsegments,nneurons] = countcells(folder)

load([folder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat'])

if isempty(analysis(1).aspikedata.F_cell) %|| analysis(cindex).FC.S_as == 0
    nastros=0;
    nsegments=0;
else
    nsegments=size(analysis(1).aspikedata.F_cell,2);
    nastros=length(unique(analysis(1).FC.astro_group(:,2)));
end

nneurons = size(analysis(1).FC.A,1);
end