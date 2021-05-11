function [CC_nmulti,CC_amulti,CC_aa,CC_nn,CC_multi,...
          K_nmulti,K_amulti,K_aa,K_nn,K_multi,...
          BC_nmulti,BC_amulti,BC_aa,BC_nn,BC_multi,...
          Eff_aa,Eff_nn,Eff_na,Eff_na_ctrl,...
          density_aa,density_nn,density_na,density_multi,...
          str_aa,str_nn,str_na,str_multi] = multilayer_network_measures_batch(folder,conds,randomflag)

load([folder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat'])
initanalysisdata=analysis;
conditions = conds;
nconds = length(conditions);

if randomflag %also running analysis for control network
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
else
    CC_nmulti(1,1:nconds)=NaN;
    CC_amulti(1,1:nconds)=NaN;
    CC_aa(1,1:nconds)=NaN;
    CC_nn(1,1:nconds)=NaN;
    CC_multi(1,1:nconds)=NaN;
    K_nmulti(1,1:nconds)=NaN;
    K_amulti(1,1:nconds)=NaN;
    K_aa(1,1:nconds)=NaN;
    K_nn(1,1:nconds)=NaN;
    K_multi(1,1:nconds)=NaN;
    BC_nmulti(1,1:nconds)=NaN;
    BC_amulti(1,1:nconds)=NaN;
    BC_aa(1,1:nconds)=NaN;
    BC_nn(1,1:nconds)=NaN;
    BC_multi(1,1:nconds)=NaN;
    Eff_aa(1,1:nconds)=NaN;
    Eff_nn(1,1:nconds)=NaN;
    Eff_na(1,1:nconds)=NaN;
    Eff_na_ctrl(1,1:nconds)=NaN;
    density_aa(1,1:nconds)=NaN;
    density_nn(1,1:nconds)=NaN;
    density_na(1,1:nconds)=NaN;
    density_multi(1,1:nconds)=NaN;
    str_aa(1,1:nconds)=NaN;
    str_nn(1,1:nconds)=NaN;
    str_na(1,1:nconds)=NaN;
    str_multi(1,1:nconds)=NaN;
end
   
%% running section
if ~isempty(analysis(1).aspikedata.F_cell)
    if randomflag % run control analysis alongside
        count = 0;
        for ii = 1:2:nconds*2
            count = count+1;
            cindex = conditions(count);
            nneuros = size(analysis(cindex).nspikedata.F_cell,2);
            nastros = size(analysis(cindex).aspikedata.F_cell,2);
            ntot = nneuros+nastros;
            
            W = initanalysisdata(cindex).FC.S_multi; %for weighted connection matrix
            W_n = W(1:nneuros,1:nneuros); %neurons alone
            W_a = W(nneuros+1:end,nneuros+1:end); %astros alone
            
            L_na = 1./W; %undirected connection-length matrix, inverse of weights
            L_n = 1./W_n;
            L_a = 1./W_a;

            %clustering coefficient
            C_temp1=clustering_coef_wu(W); %gives Ntotx1 column of clustering coefficients
            C_temp2=clustering_coef_wu(W_n);
            C_temp3=clustering_coef_wu(W_a);
            
            CC_nmulti(1,ii) = nanmean(C_temp1(1:nneuros));
            CC_amulti(1,ii) = nanmean(C_temp1(nneuros+1:end));
            CC_nn(1,ii) = nanmean(C_temp2);
            CC_aa(1,ii) = nanmean(C_temp3);
            CC_multi(1,ii) = nanmean(C_temp1);

            %degree distribution
            deg_temp1 = degrees_und(W);
            deg_temp2 = degrees_und(W_n);
            deg_temp3 = degrees_und(W_a);
            
            %strength distribution
            str_temp1 = strengths_und(W);
            str_temp2 = strengths_und(W_n);
            str_temp3 = strengths_und(W_a);
            
            str_multi(1,ii) = nanmean(str_temp1/(ntot-1));
            str_na(1,ii) = nanmean(str_multi_MS(W,nneuros,nastros)/(ntot/2 -1));
            str_nn(1,ii) = nanmean(str_temp2/(nneuros-1));
            str_aa(1,ii) = nanmean(str_temp3/(nastros-1));
        
            K_nmulti(1,ii) = nanmean(deg_temp1(1:nneuros))/nneuros;
            K_amulti(1,ii) = nanmean(deg_temp1(nneuros+1:end))/nastros;
            K_multi(1,ii) = nanmean(deg_temp1)/ntot;
            K_nn(1,ii) = nanmean(deg_temp2)/nneuros;
            K_aa(1,ii) = nanmean(deg_temp3)/nastros;

            %density
            density_multi(1,ii) = density_und(W);
            density_na(1,ii) = density_multi_MS(W,nneuros,nastros);
            density_nn(1,ii) = density_und(W_n);
            density_aa(1,ii) = density_und(W_a);
            
            %path length/global efficiency
            D_na = distance_wei(L_na);
            D_nn = distance_wei(L_n);
            D_aa = distance_wei(L_a);
            
            [lambda_temp1,efficiency_temp1] = charpath(D_na); %characteristic path length
            [lambda_temp2,efficiency_temp2] = charpath(D_nn); %characteristic path length
            [lambda_temp3,efficiency_temp3] = charpath(D_aa); %characteristic path length
            
            %global efficiency
            Eff_na(1,ii) = efficiency_temp1;
            Eff_nn(1,ii) = efficiency_temp2;
            Eff_aa(1,ii) = efficiency_temp3;
            Eff_na_ctrl(1,ii) = efficiency_temp2*(nneuros/ntot)+efficiency_temp3*(nastros/ntot);

            %betweenness centrality
            BC_temp1 = betweenness_wei(L_na); %betweenness centrality vector
            BC_temp2 = betweenness_wei(L_n);
            BC_temp3 = betweenness_wei(L_a);
            
            BC_nmulti(1,ii) = nanmean(BC_temp1(1:nneuros)./((nneuros-1)*(nneuros-2)));
            BC_amulti(1,ii) = nanmean(BC_temp1(nneuros+1:end)./((nastros-1)*(nastros-2)));
            BC_nn(1,ii) = nanmean(BC_temp2./((nneuros-1)*(nneuros-2)));
            BC_aa(1,ii) = nanmean(BC_temp3./((nastros-1)*(nastros-2)));
            BC_multi(1,ii) = nanmean(BC_temp1./((ntot-1)*(ntot-2)));
            
            Wc = randmio_und(W, 100);%randomize it! 
            
            clear W BC_temp1 BC_temp2 BC_temp3 W_n W_a C_temp1 C_temp2 C_temp3 deg_temp1 deg_temp2 ...
                deg_temp3 str_temp1 str_temp2 str_temp3 D_na D_nn D_aa
            
            %recalculate network measures for control
            Wc_n = Wc(1:nneuros,1:nneuros); %neurons alone
            Wc_a = Wc(nneuros+1:end,nneuros+1:end); %astros alone
            
            Lc_na = 1./Wc; %undirected connection-length matrix, inverse of weights
            Lc_n = 1./Wc_n;
            Lc_a = 1./Wc_a;

            %clustering coefficient
            C_temp1=clustering_coef_wu(Wc); %gives Ntotx1 column of clustering coefficients
            C_temp2=clustering_coef_wu(Wc_n);
            C_temp3=clustering_coef_wu(Wc_a);
            
            CC_nmulti(1,ii+1) = nanmean(C_temp1(1:nneuros));
            CC_amulti(1,ii+1) = nanmean(C_temp1(nneuros+1:end));
            CC_nn(1,ii+1) = nanmean(C_temp2);
            CC_aa(1,ii+1) = nanmean(C_temp3);
            CC_multi(1,ii+1) = nanmean(C_temp1);

            %degree distribution
            deg_temp1 = degrees_und(Wc);
            deg_temp2 = degrees_und(Wc_n);
            deg_temp3 = degrees_und(Wc_a);
            
            %strength distribution
            str_temp1 = strengths_und(Wc);
            str_temp2 = strengths_und(Wc_n);
            str_temp3 = strengths_und(Wc_a);
            
            str_multi(1,ii+1) = nanmean(str_temp1/(ntot-1));
            str_na(1,ii+1) = nanmean(str_multi_MS(Wc,nneuros,nastros)/(ntot/2 -1));
            str_nn(1,ii+1) = nanmean(str_temp2/(nneuros-1));
            str_aa(1,ii+1) = nanmean(str_temp3/(nastros-1));
        
            K_nmulti(1,ii+1) = nanmean(deg_temp1(1:nneuros))/nneuros;
            K_amulti(1,ii+1) = nanmean(deg_temp1(nneuros+1:end))/nastros;
            K_multi(1,ii+1) = nanmean(deg_temp1)/ntot;
            K_nn(1,ii+1) = nanmean(deg_temp2)/nneuros;
            K_aa(1,ii+1) = nanmean(deg_temp3)/nastros;

            %density
            density_multi(1,ii+1) = density_und(Wc);
            density_na(1,ii+1) = density_multi_MS(Wc,nneuros,nastros);
            density_nn(1,ii+1) = density_und(Wc_n);
            density_aa(1,ii+1) = density_und(Wc_a);
            
            %path length/global efficiency
            Dc_na = distance_wei(Lc_na);
            Dc_nn = distance_wei(Lc_n);
            Dc_aa = distance_wei(Lc_a);
            
            [lambda_temp1,efficiency_temp1] = charpath(Dc_na); %characteristic path length
            [lambda_temp2,efficiency_temp2] = charpath(Dc_nn); %characteristic path length
            [lambda_temp3,efficiency_temp3] = charpath(Dc_aa); %characteristic path length
            
            %global efficiency
            Eff_na(1,ii+1) = efficiency_temp1;
            Eff_nn(1,ii+1) = efficiency_temp2;
            Eff_aa(1,ii+1) = efficiency_temp3;
            Eff_na_ctrl(1,ii+1) = efficiency_temp2*(nneuros/ntot)+efficiency_temp3*(nastros/ntot);

            %betweenness centrality
            BC_temp1 = betweenness_wei(Lc_na); %betweenness centrality vector
            BC_temp2 = betweenness_wei(Lc_n);
            BC_temp3 = betweenness_wei(Lc_a);
            
            BC_nmulti(1,ii+1) = nanmean(BC_temp1(1:nneuros))./((nneuros-1)*(nneuros-2));
            BC_amulti(1,ii+1) = nanmean(BC_temp1(nneuros+1:end))./((nastros-1)*(nastros-2));
            BC_nn(1,ii+1) = nanmean(BC_temp2)./((nneuros-1)*(nneuros-2));
            BC_aa(1,ii+1) = nanmean(BC_temp3)./((nastros-1)*(nastros-2));
            BC_multi(1,ii+1) = nanmean(BC_temp1)./((ntot-1)*(ntot-2));
        end
    else %just get real network properties
        for ii = 1:nconds
            cindex = conditions(ii);
            nneuros = size(analysis(cindex).nspikedata.F_cell,2);
            nastros = size(analysis(cindex).aspikedata.F_cell,2);
            ntot = nneuros+nastros;
            
            W = initanalysisdata(cindex).FC.S_multi; %for weighted connection matrix
            W_n = W(1:nneuros,1:nneuros); %neurons alone
            W_a = W(nneuros+1:end,nneuros+1:end); %astros alone
            
            L_na = 1./W; %undirected connection-length matrix, inverse of weights
            L_n = 1./W_n;
            L_a = 1./W_a;

            %clustering coefficient
            C_temp1=clustering_coef_wu(W); %gives Ntotx1 column of clustering coefficients
            C_temp2=clustering_coef_wu(W_n);
            C_temp3=clustering_coef_wu(W_a);
            
            CC_nmulti(1,ii) = nanmean(C_temp1(1:nneuros));
            CC_amulti(1,ii) = nanmean(C_temp1(nneuros+1:end));
            CC_nn(1,ii) = nanmean(C_temp2);
            CC_aa(1,ii) = nanmean(C_temp3);
            CC_multi(1,ii) = nanmean(C_temp1);

            %degree distribution
            deg_temp1 = degrees_und(W);
            deg_temp2 = degrees_und(W_n);
            deg_temp3 = degrees_und(W_a);
            
            %strength distribution
            str_temp1 = strengths_und(W);
            str_temp2 = strengths_und(W_n);
            str_temp3 = strengths_und(W_a);
            
            str_multi(1,ii) = nanmean(str_temp1/(ntot-1));
            str_na(1,ii) = nanmean(str_multi_MS(W,nneuros,nastros)/(ntot/2 -1));
            str_nn(1,ii) = nanmean(str_temp2/(nneuros-1));
            str_aa(1,ii) = nanmean(str_temp3/(nastros-1));
            
%             figure()
%             subplot(1,3,1)
%                 hist(str_temp1)
%                 title('multi')
%             subplot(1,3,2)
%                 hist(str_temp2)
%                 title('neurons')
%             subplot(1,3,3)
%                 hist(str_temp3)
%                 title('astros')
%             
            K_nmulti(1,ii) = nanmean(deg_temp1(1:nneuros))/nneuros;
            K_amulti(1,ii) = nanmean(deg_temp1(nneuros+1:end))/nastros;
            K_multi(1,ii) = nanmean(deg_temp1)/ntot;
            K_nn(1,ii) = nanmean(deg_temp2)/nneuros;
            K_aa(1,ii) = nanmean(deg_temp3)/nastros;

            %density
            density_multi(1,ii) = density_und(W);
            density_na(1,ii) = density_multi_MS(W,nneuros,nastros);
            density_nn(1,ii) = density_und(W_n);
            density_aa(1,ii) = density_und(W_a);
            
            %path length/global efficiency
            D_na = distance_wei(L_na);
            D_nn = distance_wei(L_n);
            D_aa = distance_wei(L_a);
            
            [lambda_temp1,efficiency_temp1] = charpath(D_na); %characteristic path length
            [lambda_temp2,efficiency_temp2] = charpath(D_nn); %characteristic path length
            [lambda_temp3,efficiency_temp3] = charpath(D_aa); %characteristic path length
            
            %global efficiency
            Eff_na(1,ii) = efficiency_temp1;
            Eff_nn(1,ii) = efficiency_temp2;
            Eff_aa(1,ii) = efficiency_temp3;
            Eff_na_ctrl(1,ii) = efficiency_temp2*(nneuros/ntot)+efficiency_temp3*(nastros/ntot);

            %betweenness centrality
            BC_temp1 = betweenness_wei(L_na); %betweenness centrality vector
            BC_temp2 = betweenness_wei(L_n);
            BC_temp3 = betweenness_wei(L_a);
            
            BC_nmulti(1,ii) = nanmean(BC_temp1(1:nneuros))./((nneuros-1)*(nneuros-2));
            BC_amulti(1,ii) = nanmean(BC_temp1(nneuros+1:end))./((nastros-1)*(nastros-2));
            BC_nn(1,ii) = nanmean(BC_temp2)./((nneuros-1)*(nneuros-2));
            BC_aa(1,ii) = nanmean(BC_temp3)./((nastros-1)*(nastros-2));
            BC_multi(1,ii) = nanmean(BC_temp1)./((ntot-1)*(ntot-2));

        end
    end
end
end