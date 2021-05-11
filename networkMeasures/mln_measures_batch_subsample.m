function [CC,K_multi,BC,E,density,...
          S_aa,S_nn,S_na,S_multi] = mln_measures_batch_subsample(folder,bin)

load([folder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat'])
initanalysisdata=analysis;
conditions = [1 2 4];
%% running section
if isempty(analysis(1).aspikedata.F_cell)
   CC(1:3,1)=NaN;
   K_multi(1:3,1)=NaN;
   BC(1:3,1)=NaN;
   E(1:3,1)=NaN;
   S_aa(1:3,1)=NaN;
   S_nn(1:3,1)=NaN;
   S_na(1:3,1)=NaN;
   S_multi(1:3,1)=NaN;
   density(1:3,1)=NaN;
   
else
    if bin %use binary weight matrix
    else %use weighted adjacency matrix
        for ii = 1:3 %loop through conditions
            cindex = conditions(ii);
            nneuros = size(analysis(cindex).nspikedata.F_cell,2);
            nastros = size(analysis(cindex).aspikedata.F_cell,2);
            ntot = nneuros+nastros;
            W = initanalysisdata(cindex).FC.S_multi; %for weighted connection matrix
            
            for zz = 1:30
                if nneuros > nastros
                    subsampneurons = randsample(nneuros,nastros); %take nastros from neuron population
                    W = W([subsampneurons' nneuros+1:ntot],[subsampneurons' nneuros+1:ntot]); %grab new adjacency matrix
                    nneuros = nastros; %set to be even
                    ntot = nneuros+nastros;
                end
                
                W_n = W(1:nneuros,1:nneuros); %neurons alone
                W_a = W(nneuros+1:ntot,nneuros+1:ntot); %astros alone
            
                L_na = 1./W; %undirected connection-length matrix, inverse of weights

                %clustering coefficient
                C_temp1=clustering_coef_wu(W); %gives Ntotx1 column of clustering coefficients
                CC_multi(zz,1) = nanmean(C_temp1);

            %degree distribution
                deg_temp1 = degrees_und(W);
            
            %strength distribution
                str_temp1 = strengths_und(W);
                str_temp2 = strengths_und(W_n);
                str_temp3 = strengths_und(W_a);
            
                str_multi(zz,1) = nanmean(str_temp1)/ntot;
                str_na(zz,1) = nanmean(str_multi_MS(W,nneuros,nastros))/(ntot/2);
                str_nn(zz,1) = nanmean(str_temp2)/nneuros;
                str_aa(zz,1) = nanmean(str_temp3)/nastros;
            
                deg_multi(zz,1) = nanmean(deg_temp1)/ntot;

                %density
                density_multi(zz,1) = density_und(W);
            
            %path length/global efficiency
                D_na = distance_wei(L_na);
            
                [lambda_temp1,efficiency_temp1] = charpath(D_na); %characteristic path length
            
                %global efficiency
                Eff_na(zz,1) = efficiency_temp1;
            
                %betweenness centrality
                BC_temp1 = betweenness_wei(L_na); %betweenness centrality vector
                BC_multi(zz,1) = nanmean(BC_temp1)/ntot;
            end
            BC(ii,1) = nanmean(BC_multi);
            CC(ii,1) = nanmean(CC_multi);
            E(ii,1) = nanmean(Eff_na);
            S_multi(ii,1) = nanmean(str_multi);
            S_na(ii,1) = nanmean(str_na);
            S_nn(ii,1) = nanmean(str_nn);
            S_aa(ii,1) = nanmean(str_aa);
            K_multi(ii,1) = nanmean(deg_multi);
            density(ii,1) = nanmean(density_multi);

        end
    end
end
end