function [scs,scf,AR,...
    aparts,apartf,nparts,npartf] = mln_community_subsample(folder)

load([folder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat'])
disp(['Working on ' folder])
initanalysisdata=analysis;
conditions = [1 2 4];

if isempty(analysis(1).aspikedata.F_cell)
    scs(1:3,1) = NaN;
    scf(1:3,1) = NaN;
    AR(1:3,1) = NaN;
    aparts(1:3,1) = NaN;
    apartf(1:3,1) = NaN;
    nparts(1:3,1) = NaN;
    npartf(1:3,1) = NaN;
    disp(folder)
    
elseif size(analysis(1).FC.astro_group,1) <= 1
    scs(1:3,1) = NaN;
    scf(1:3,1) = NaN;
    AR(1:3,1) = NaN;
    aparts(1:3,1) = NaN;
    apartf(1:3,1) = NaN;
    nparts(1:3,1) = NaN;
    npartf(1:3,1) = NaN;
    disp(folder)

else
    for ii = 1:3 %loop through
        cindex = conditions(ii);
        %comunity detection
        its=50;
        gamma_s=1.13;
        gamma_f=1.55;
        
        A_fxn=analysis(cindex).FC.S_multi;
        nadist = analysis(cindex).FC.na_dist;
        aadist = analysis(cindex).FC.a_dist;
        nndist = analysis(cindex).FC.n_dist;
        A_spat = [nndist nadist; nadist' aadist];
        astro_groups=analysis(cindex).FC.astro_group(:,2);
        [~,~,Ic]=unique(astro_groups);
        astro_groups = Ic;
        nneuros = size(analysis(cindex).nspikedata.F_cell,2);
        nastros = size(analysis(cindex).aspikedata.F_cell,2);
        ntot = nneuros+nastros;
        
        for zz = 1:30
            if nneuros > nastros
                subsampneurons = randsample(nneuros,nastros); %take nastros from neuron population
                A_fxn = A_fxn([subsampneurons' nneuros+1:ntot],[subsampneurons' nneuros+1:ntot]); %grab new adjacency matrix
                A_spat = A_spat([subsampneurons' nneuros+1:ntot],[subsampneurons' nneuros+1:ntot]);
                nneuros = nastros; %set to be even
                ntot = nneuros+nastros;
            end
               
            [ncs(zz,1),ncf(zz,1),scstemp(zz,1),scftemp(zz,1),ARtemp(zz,1),~,~,S_s(:,zz),S_f(:,zz)] = ...
                community_detection(A_spat,A_fxn,gamma_s,gamma_f,its);

            a_parts(zz,1) = length(unique(S_s(nneuros+1:end,ii)))/ncs(ii,1);
            a_partf(zz,1) = length(unique(S_f(nneuros+1:end,ii)))/ncf(ii,1); 
            n_parts(zz,1) = length(unique(S_s(1:nneuros,ii)))/ncs(ii,1);
            n_partf(zz,1) = length(unique(S_f(1:nneuros,ii)))/ncf(ii,1);
        end
        
        aparts(ii,1) = nanmean(a_parts);
        apartf(ii,1) = nanmean(a_partf);
        nparts(ii,1) = nanmean(n_parts);
        npartf(ii,1) = nanmean(n_partf);
        AR(ii,1) = nanmean(ARtemp);
        scs(ii,1) = nanmean(scstemp);
        scf(ii,1) = nanmean(scftemp);
        
        
    end
end
    
  
end