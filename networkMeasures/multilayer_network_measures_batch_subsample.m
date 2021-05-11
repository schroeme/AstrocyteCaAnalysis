function [CC_multi,K_multi,BC_multi,Eff_na,density_multi,...
          str_aa,str_nn,str_na,str_multi] = multilayer_network_measures_batch_subsample(folder,conds)

load([folder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat'])
initanalysisdata=analysis;
conditions = conds;
nconds = length(conditions);

CC_nmulti(1,1:nconds*2)=NaN;
CC_amulti(1,1:nconds*2)=NaN;
CC_aa(1,1:nconds*2)=NaN;
CC_nn(1,1:nconds*2)=NaN;
CC_multi(1,1:nconds*2)=NaN;
K_nmulti(1,1:nconds*2)=NaN;
K_amulti(1,1:nconds*2)=NaN;
K_aa(1,1:nconds*2)=NaN;
K_nn(1,1:nconds*2)=NaN;
K_multi(1,1:nconds*2)=NaN;
BC_nmulti(1,1:nconds*2)=NaN;
BC_amulti(1,1:nconds*2)=NaN;
BC_aa(1,1:nconds*2)=NaN;
BC_nn(1,1:nconds*2)=NaN;
BC_multi(1,1:nconds*2)=NaN;
Eff_aa(1,1:nconds*2)=NaN;
Eff_nn(1,1:nconds*2)=NaN;
Eff_na(1,1:nconds*2)=NaN;
Eff_na_ctrl(1,1:nconds*2)=NaN;
density_aa(1,1:nconds*2)=NaN;
density_nn(1,1:nconds*2)=NaN;
density_na(1,1:nconds*2)=NaN;
density_multi(1,1:nconds*2)=NaN;
str_aa(1,1:nconds*2)=NaN;
str_nn(1,1:nconds*2)=NaN;
str_na(1,1:nconds*2)=NaN;
str_multi(1,1:nconds*2)=NaN;

%% running section
if ~isempty(analysis(1).aspikedata.F_cell) && (size(analysis(1).aspikedata.F_cell,2) > 2)
    count = 0;
    for ii = 1:2:nconds*2
        count = count+1;
        cindex = conditions(count);

        for zz = 1:30
            W = initanalysisdata(cindex).FC.S_multi; %for weighted connection matrix
            nneuros = size(analysis(cindex).nspikedata.F_cell,2);
            nastros = size(analysis(cindex).aspikedata.F_cell,2);
            ntot = nneuros+nastros;
            
            if nneuros > nastros
                subsampneurons = randsample(nneuros,nastros); %take nastros from neuron population
                W = W([subsampneurons' nneuros+1:ntot],[subsampneurons' nneuros+1:ntot]); %grab new adjacency matrix
                nneuros = nastros; %set to be even
                ntot = nneuros+nastros;
            end
            
            if zz == 1
                disp(ntot)
            end
            W_n = W(1:nneuros,1:nneuros); %neurons alone
            W_a = W(nneuros+1:end,nneuros+1:end); %astros alone

            L_na = 1./W; %undirected connection-length matrix, inverse of weights
            
            %clustering coefficient
            C_temp1=clustering_coef_wu(W); %gives Ntotx1 column of clustering coefficients

            tCC_multi(zz,1) = nanmean(C_temp1);

            %degree distribution
            deg_temp1 = degrees_und(W);

            %strength distribution
            str_temp1 = strengths_und(W);
            str_temp2 = strengths_und(W_n);
            str_temp3 = strengths_und(W_a);

            tstr_multi(zz,1) = nanmean(str_temp1/(ntot-1));
            tstr_na(zz,1) = nanmean(str_multi_MS(W,nneuros,nastros)/(ntot/2 -1));
            tstr_nn(zz,1) = nanmean(str_temp2/(nneuros-1));
            tstr_aa(zz,1) = nanmean(str_temp3/(nastros-1));

            tK_multi(zz,1) = nanmean(deg_temp1)/ntot;

            %density
            tdensity_multi(zz,1) = density_und(W);

            %path length/global efficiency
            D_na = distance_wei(L_na);

            [lambda_temp1,efficiency_temp1] = charpath(D_na); %characteristic path length

            %global efficiency
            tEff_na(zz,1) = efficiency_temp1;

            %betweenness centrality
            BC_temp1 = betweenness_wei(L_na); %betweenness centrality vector

            tBC_multi(zz,1) = nanmean(BC_temp1./((ntot-1)*(ntot-2)));

            if ntot > 9
                Wc = randmio_und(W, 100);%randomize it!
            else
                Wc = W;
            end

            clear BC_temp1 BC_temp2 BC_temp3 W_n W_a C_temp1 C_temp2 C_temp3 deg_temp1 deg_temp2 ...
                deg_temp3 str_temp1 str_temp2 str_temp3 D_na D_nn D_aa

            %recalculate network measures for control
            Wc_n = Wc(1:nneuros,1:nneuros); %neurons alone
            Wc_a = Wc(nneuros+1:end,nneuros+1:end); %astros alone

            Lc_na = 1./Wc; %undirected connection-length matrix, inverse of weights

            %clustering coefficient
            C_temp1=clustering_coef_wu(Wc); %gives Ntotx1 column of clustering coefficients

            tCC_multi(zz,2)= nanmean(C_temp1);

            %degree distribution
            deg_temp1 = degrees_und(Wc);
            
            %strength distribution
            str_temp1 = strengths_und(Wc);
            str_temp2 = strengths_und(Wc_n);
            str_temp3 = strengths_und(Wc_a);

            tstr_multi(zz,2)= nanmean(str_temp1/(ntot-1));
            tstr_na(zz,2)= nanmean(str_multi_MS(Wc,nneuros,nastros)/(ntot/2 -1));
            tstr_nn(zz,2)= nanmean(str_temp2/(nneuros-1));
            tstr_aa(zz,2)= nanmean(str_temp3/(nastros-1));

            tK_multi(zz,2)= nanmean(deg_temp1)/ntot;

            %density
            tdensity_multi(zz,2)= density_und(Wc);

            %path length/global efficiency
            Dc_na = distance_wei(Lc_na);

            [lambda_temp1,efficiency_temp1] = charpath(Dc_na); %characteristic path length

            %global efficiency
            tEff_na(zz,2)= efficiency_temp1;

            %betweenness centrality
            BC_temp1 = betweenness_wei(Lc_na); %betweenness centrality vector
            tBC_multi(zz,2) = nanmean(BC_temp1)./((ntot-1)*(ntot-2));
            
        end

        BC_multi(1,ii:ii+1) = nanmean(tBC_multi);
        CC_multi(1,ii:ii+1) = nanmean(tCC_multi);
        Eff_na(1,ii:ii+1) = nanmean(tEff_na);
        str_multi(1,ii:ii+1) = nanmean(tstr_multi);
        str_na(1,ii:ii+1) = nanmean(tstr_na);
        str_nn(1,ii:ii+1) = nanmean(tstr_nn);
        str_aa(1,ii:ii+1) = nanmean(tstr_aa);
        K_multi(1,ii:ii+1) = nanmean(tK_multi);
        density_multi(1,ii:ii+1) = nanmean(tdensity_multi);
    end
   
end
end