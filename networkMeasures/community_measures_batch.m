function [ncs,ncf,scs,scf,AR,Q_s,Q_f,AR_ag_af,AR_ag_as,nca,sca] = community_measures_batch(folder,celltype,bin)

load([folder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat'])
initanalysisdata=analysis;
conditions = [1 2 4];

if celltype == 'n' && bin == 0 %neural graphs, weighted
    for ii = 1:3 %loop throughit
        cindex = conditions(ii);
        %comunity detection
        its=50;
        gamma_s=1.05;
        gamma_f=1;
        A_fxn=analysis(cindex).FC.S_n2;
        A_spat=analysis(cindex).FC.n_dist;
        [ncs(ii,1),ncf(ii,1),scs(ii,1),scf(ii,1),AR(ii,1),Q_s(ii,1),Q_f(ii,1),~,~] = ...
            community_detection_consensus(A_spat,A_fxn,gamma_s,gamma_f,its);
    end
    
elseif celltype == 'n' && bin == 1%neuron w/ binary graph
     for ii = 1:3 %loop through conditions
        cindex = conditions(ii);
        its=50;
        gamma_s=1.17;
        gamma_f=1.25;
        A_fxn=analysis(cindex).FC.A;
        A_spat=analysis(cindex).FC.n_dist;
        nspat=length(A_spat);
        nfxn=length(A_fxn);
            if nspat ~= nfxn
                if nspat > nfxn
                    A_spat=A_spat(1:nfxn,1:nfxn);
                else
                    A_fxn=A_fxn(1:nspat,1:nspat);
                end
            end
        [ncs(ii,1),ncf(ii,1),scs(ii,1),scf(ii,1),AR(ii,1),Q_s(ii,1),Q_f(ii,1),~,~] = ...
            community_detection_consensus(A_spat,A_fxn,gamma_s,gamma_f,its);
     end
        
else %celltype == 'a' && bin == 0 %astrocyte w/ weighted graph
    for ii = 1:3 %loop through conditions
        cindex = conditions(ii);
        if isempty(analysis(cindex).aspikedata.F_cell)
            ncs(ii,1)=NaN;
            ncf(ii,1)=NaN;
            scs(ii,1)=NaN;
            scf(ii,1)=NaN;
            AR(ii,1)=NaN;
            Q_s(ii,1)=NaN;
            Q_f(ii,1)=NaN;
            nca(ii,1)=NaN;
            sca(ii,1)=NaN;
            AR_ag_af(ii,1)=NaN;
            AR_ag_as(ii,1)=NaN;
        elseif size(analysis(cindex).FC.astro_group,1) <=1;
            ncs(ii,1)=NaN;
            ncf(ii,1)=NaN;
            scs(ii,1)=NaN;
            scf(ii,1)=NaN;
            AR(ii,1)=NaN;
            Q_s(ii,1)=NaN;
            Q_f(ii,1)=NaN;
            nca(ii,1)=NaN;
            sca(ii,1)=NaN;
            AR_ag_af(ii,1)=NaN;
            AR_ag_as(ii,1)=NaN;
        else
            its=50;
            gamma_s=1.15;
            gamma_f=1.51;
            nneuros=size(analysis(cindex).FC.S,1);
            nastros=size(analysis(cindex).aspikedata.F_cell,2);
            A_fxn=analysis(cindex).FC.S_multi(end-nastros+1:end,end-nastros+1:end);
            A_spat=analysis(cindex).FC.a_dist;
            astro_groups=initanalysisdata(cindex).FC.astro_group(:,2);
            [~,~,astro_groups]=unique(astro_groups);
            nca(ii,1)=max(astro_groups); %number of actual whole cells
            sca(ii,1)=length(astro_groups)./nca(ii,1);
            %check that number of segments in groups vs. functional network is equal,
            %if not take the smaller of the two
            nnet=length(A_spat);
            nfxn=length(astro_groups);
            if nnet ~= nfxn
                if nnet > nfxn
                    A_spat=A_spat(1:nfxn,1:nfxn);
                    A_fxn=A_fxn(1:nfxn,1:nfxn);
                else
                    astro_groups=astro_groups(1:nnet);
                end
            end
            [ncs(ii,1),ncf(ii,1),scs(ii,1),scf(ii,1),AR(ii,1),Q_s(ii,1),Q_f(ii,1),...
                ~,~,AR_ag_af(ii,1),AR_ag_as(ii,1)] = ...
                community_detection_consensus(A_spat,A_fxn,gamma_s,gamma_f,its,astro_groups);
        end
    end
    

end