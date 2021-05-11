function [ncs,ncf,scs,scf,AR,Q_s,Q_f,S_s,S_f,...
    pns,pnf,nsdasc,nsdafc,aparts,apartf,...
    nparts,npartf,AR_ag_af,AR_ag_as,AR_af_as] = multilayer_community_measures_batch(folder)

load([folder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat'])
initanalysisdata=analysis;
conditions = [1 2 4];

if isempty(analysis(1).aspikedata.F_cell)
    ncs(1:3,1) = NaN;
    ncf(1:3,1) = NaN;
    scs(1:3,1) = NaN;
    scf(1:3,1) = NaN;
    AR(1:3,1) = NaN;
    Q_s(1:3,1) = NaN;
    Q_f(1:3,1) = NaN;
    S_s(1:3,1) = NaN;
    S_f(1:3,1) = NaN;
    pns(1:3,1) = NaN;
    pnf(1:3,1) = NaN;
    nsdasc(1:3,1) = NaN;
    nsdafc(1:3,1) = NaN;
    aparts(1:3,1) = NaN;
    apartf(1:3,1) = NaN;
    nparts(1:3,1) = NaN;
    npartf(1:3,1) = NaN;
    AR_ag_af(1:3,1) = NaN;
    AR_ag_as(1:3,1) = NaN;
    AR_af_as(1:3,1)=NaN;
    disp(folder)
%     ncs(1,1) = NaN;
%     ncf(1,1) = NaN;
%     scs(1,1) = NaN;
%     scf(1,1) = NaN;
%     AR(1,1) = NaN;
%     Q_s(1,1) = NaN;
%     Q_f(1,1) = NaN;
%     S_s(1,1) = NaN;
%     S_f(1,1) = NaN;
%     pns(1,1) = NaN;
%     pnf(1,1) = NaN;
%     nsdasc(1,1) = NaN;
%     nsdafc(1,1) = NaN;
%     aparts(1,1) = NaN;
%     apartf(1,1) = NaN;
%     nparts(1,1) = NaN;
%     npartf(1,1) = NaN;
%     AR_ag_af(1,1) = NaN;
%     AR_ag_as(1,1) = NaN;
%     AR_af_as(1,1) = NaN;
    
elseif size(analysis(1).FC.astro_group,1) <= 1
    ncs(1:3,1) = NaN;
    ncf(1:3,1) = NaN;
    scs(1:3,1) = NaN;
    scf(1:3,1) = NaN;
    AR(1:3,1) = NaN;
    Q_s(1:3,1) = NaN;
    Q_f(1:3,1) = NaN;
    S_s(1:3,1) = NaN;
    S_f(1:3,1) = NaN;
    pns(1:3,1) = NaN;
    pnf(1:3,1) = NaN;
    nsdasc(1:3,1) = NaN;
    nsdafc(1:3,1) = NaN;
    aparts(1:3,1) = NaN;
    apartf(1:3,1) = NaN;
    nparts(1:3,1) = NaN;
    npartf(1:3,1) = NaN;
    AR_ag_af(1:3,1) = NaN;
    AR_ag_as(1:3,1) = NaN;
    AR_af_as(1:3,1)=NaN;
    disp(folder)
%     ncs(1,1) = NaN;
%     ncf(1,1) = NaN;
%     scs(1,1) = NaN;
%     scf(1,1) = NaN;
%     AR(1,1) = NaN;
%     Q_s(1,1) = NaN;
%     Q_f(1,1) = NaN;
%     S_s(1,1) = NaN;
%     S_f(1,1) = NaN;
%     pns(1,1) = NaN;
%     pnf(1,1) = NaN;
%     nsdasc(1,1) = NaN;
%     nsdafc(1,1) = NaN;
%     aparts(1,1) = NaN;
%     apartf(1,1) = NaN;
%     nparts(1,1) = NaN;
%     npartf(1,1) = NaN;
%     AR_ag_af(1,1) = NaN;
%     AR_ag_as(1,1) = NaN;
%     AR_af_as(1,1) = NaN;
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
        
        astro_groups=analysis(cindex).FC.astro_group(:,2);
        [~,~,Ic]=unique(astro_groups);
        astro_groups = Ic;
        
        nneuros = length(nndist);
        nastros = length(aadist);
        A_spat = [nndist nadist; nadist' aadist];
        %check that number of segments in groups vs. functional network is equal,
        %if not take the smaller of the two
        nnet=length(aadist);
        nact=length(astro_groups);        
        [ncs(ii,1),ncf(ii,1),scs(ii,1),scf(ii,1),AR(ii,1),Q_s(ii,1),Q_f(ii,1),S_s(:,ii),S_f(:,ii)] = ...
            community_detection_consensus(A_spat,A_fxn,gamma_s,gamma_f,its);
        
        AR_ag_af(ii,1) = RandIndex(S_f(nneuros+1:end,ii),astro_groups);
        AR_ag_as(ii,1) = RandIndex(S_s(nneuros+1:end,ii),astro_groups);
        AR_af_as(ii,1) = RandIndex(S_s(nneuros+1:end,ii),S_f(nneuros+1:end,ii));
        
        %module % neuron-astrocyte
        for jj = 1:ncs(ii,1) %loop through number of spatial modules
            %find index of all cells in that module
            module = find(S_s(:,ii)==jj);
            astrosinmodule = sum(module > nneuros);
            pns_temp(jj,1) = 1 - astrosinmodule/length(module); %percent neurons in the module
            clear module astrosinmodule
        end
        pns(ii,1) = mean(pns_temp);
        
        for kk = 1:ncf(ii,1)
            module = find(S_f(:,ii)==kk);
            astrosinmodule = sum(module > nneuros);
            pnf_temp(kk,1) = 1 - astrosinmodule/length(module);
            clear module astrosinmodule
        end
        pnf(ii,1) = mean(pnf_temp);
        %normalized SD of astro group assignment - to what extent are astrocyte
        %segments assigned to the same group?
        nsdasc(ii,1) = std(S_s(nneuros+1:end,ii))/ncs(ii,1);
        nsdafc(ii,1) = std(S_f(nneuros+1:end,ii))/ncf(ii,1);
        
        aparts(ii,1) = length(unique(S_s(nneuros+1:end,ii)))/ncs(ii,1);
        apartf(ii,1) = length(unique(S_f(nneuros+1:end,ii)))/ncf(ii,1); 
        nparts(ii,1) = length(unique(S_s(1:nneuros,ii)))/ncs(ii,1);
        npartf(ii,1) = length(unique(S_f(1:nneuros,ii)))/ncf(ii,1);
        
    end
end
    
  
end