function [ER,CC,K,BC,Eff,density,str] = network_measures_batch(folder,celltype,bin,conds,randomflag)

load([folder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat'])
initanalysisdata=analysis;
conditions = conds;
nconds = length(conditions);
if randomflag
    if celltype == 'n' && bin == 0 %neuron graphs, weighted
        count = 0;
        for ii = 1:2:nconds*2 %loop through conditions
            count = count + 1;
            cindex = conditions(count);

            %W = initanalysisdata(cindex).FC.S; %for weighted connection matrix
            %nneuros = length(initanalysisdata(cindex).FC.S);
            W = initanalysisdata(cindex).FC.S_n2;
            idx = logical(eye(size(W)));
            W(idx) = 0;
            L = 1./W; %undirected connection-length matrix, inverse of weights
            N = length(W);
            
            ER(1,ii) = event_rate(initanalysisdata(cindex).nspikedata.peak_locs,initanalysisdata(cindex).frames);

            %clustering coefficient
            C_temp=clustering_coef_wu(W);
            CC(1,ii) = nanmean(C_temp);

            %degree distribution
            deg_temp = degrees_und(W);
            K(1,ii) = nanmean(deg_temp)/N;

            %strength
            str_temp = strengths_und(W);
            str(1,ii) = nanmean(str_temp./N);

            %path length
            D = distance_wei(L);
            [lambda_temp,efficiency_temp] = charpath(D); %characteristic path length
            Eff(1,ii) = efficiency_temp;

            BC_temp = betweenness_wei(L); %betweenness centrality vector
            BC(1,ii) = nanmean(BC_temp/((N-2)*(N-1)));

            density(1,ii)=density_und(W);
            
            % now repeat everything for randomized version
            Wc = randmio_und(W, 100);%randomize it!
            Lc = 1./Wc; %undirected connection-length matrix, inverse of weights

            %clustering coefficient
            C_temp=clustering_coef_wu(Wc);
            CC(1,ii+1) = nanmean(C_temp);

            %degree distribution
            deg_temp = degrees_und(Wc);
            K(1,ii+1) = nanmean(deg_temp)/N;

            %strength
            str_temp = strengths_und(Wc);
            str(1,ii+1) = nanmean(str_temp./N);

            %path length
            Dc = distance_wei(Lc);
            [lambda_temp,efficiency_temp] = charpath(Dc); %characteristic path length
            Eff(1,ii+1) = efficiency_temp;

            BC_temp = betweenness_wei(Lc); %betweenness centrality vector
            BC(1,ii+1) = nanmean(BC_temp/((N-2)*(N-1)));

            density(1,ii+1)=density_und(Wc);
            
        end

    elseif celltype == 'n' && bin == 1 %neuron w/ binary graph, generated using
        count = 0;
        for ii = 1:2:nconds*2 %loop thro
            count = count+1;
            cindex = conditions(count);
            W = initanalysisdata(cindex).FC.A; %for binary connection matrix
            idx = logical(eye(size(W)));
            W(idx) = 0;
            %%L = 1./W; %undirected connection-length matrix, inverse of weights
            N = length(W);
            
            ER(1,ii) = event_rate(initanalysisdata(cindex).nspikedata.peak_locs,initanalysisdata(cindex).frames);

            %clustering coefficient
            C_temp=clustering_coef_bu(W);
            CC(1,ii) = nanmean(C_temp);

            %degree distribution
            deg_temp = degrees_und(W);
            K(1,ii) = nanmean(deg_temp)/N;

            %path length
            Eff(1,ii) = efficiency_bin(W);

            BC_temp = betweenness_bin(W); %betweenness centrality vector
            BC(1,ii) = nanmean(BC_temp/((N-2)*(N-1)));

            density(1,ii) = density_und(W);
            str(1,ii)=NaN;
            
            % now repeat everything for randomized version
            Wc = randmio_und(W, 100);%randomize it!
            %%Lc = 1./W; %undirected connection-length matrix, inverse of weights
            
            %clustering coefficient
            C_temp=clustering_coef_bu(Wc);
            CC(1,ii+1) = nanmean(C_temp);

            %degree distribution
            deg_temp = degrees_und(Wc);
            K(1,ii+1) = nanmean(deg_temp)/N;

            %path length
            Eff(1,ii+1) = efficiency_bin(Wc);

            BC_temp = betweenness_bin(Wc); %betweenness centrality vector
            BC(1,ii+1) =  nanmean(BC_temp/((N-2)*(N-1)));

            density(1,ii+1) = density_und(Wc);
            str(1,ii+1)=NaN;
            
         end

    else celltype == 'a' && bin == 0; %astrocyte w/ weighted graph
        count = 0;
        for ii = 1:2:nconds*2 %loop through conditions
            count = count+1;
            cindex = conditions(count);
            if isempty(analysis(cindex).aspikedata.F_cell) %|| analysis(cindex).FC.S_as == 0
                CC(1,ii)=NaN;
                K(1,ii)=NaN;
                Eff(1,ii)=NaN;
                BC(1,ii)=NaN;
                density(1,ii)=NaN;
                str(1,ii)=NaN;
                ER(1,ii)=NaN;
                
                CC(1,ii+1)=NaN;
                K(1,ii+1)=NaN;
                Eff(1,ii+1)=NaN;
                BC(1,ii+1)=NaN;
                density(1,ii+1)=NaN;
                str(1,ii+1)=NaN;


            else
                nneuros=length(initanalysisdata(cindex).FC.S);
                W = initanalysisdata(cindex).FC.S_multi(nneuros+1:end,nneuros+1:end); %for weighted connection matrix
                L = 1./W; %undirected connection-length matrix, inverse of weights
                N = length(W);
                %clustering coefficient
                C_temp=clustering_coef_wu(W);
                CC(1,ii) = nanmean(C_temp);
                
                ER(1,ii) = event_rate(initanalysisdata(cindex).aspikedata.peak_locs,initanalysisdata(cindex).frames);

                %degree distribution
                deg_temp = degrees_und(W);
                K(1,ii) = nanmean(deg_temp)/N;

                %strength
                str_temp = strengths_und(W);
                str(1,ii) = nanmean(str_temp./N);

                %path length
                D = distance_wei(L);
                [lambda_temp,efficiency_temp] = charpath(D); %characteristic path length
                Eff(1,ii) = efficiency_temp;

                BC_temp = betweenness_wei(L); %betweenness centrality vector
                BC(1,ii) = nanmean(BC_temp/((N-2)*(N-1)));

                density(1,ii)=density_und(W);
                
                %calculate everything for random network
                if N > 9
                    Wc = randmio_und(W, 100);%randomize it!
                else
                    Wc = W;
                end
                Lc = 1./Wc; %undirected connection-length matrix, inverse of weights
                %clustering coefficient
                C_temp=clustering_coef_wu(Wc);
                CC(1,ii+1) = nanmean(C_temp);

                %degree distribution
                deg_temp = degrees_und(Wc);
                K(1,ii+1) = nanmean(deg_temp)/N;

                %strength
                str_temp = strengths_und(Wc);
                str(1,ii+1) = nanmean(str_temp./N);

                %path length
                Dc = distance_wei(Lc);
                [lambda_temp,efficiency_temp] = charpath(Dc); %characteristic path length
                Eff(1,ii+1) = efficiency_temp;

                BC_temp = betweenness_wei(Lc); %betweenness centrality vector
                BC(1,ii+1) = nanmean(BC_temp/((N-2)*(N-1)));

                density(1,ii+1)=density_und(W);
            end
        end


    end
else
    if celltype == 'n' && bin == 0 %neuron graphs, weighted
        for ii = 1:length(conditions) %loop through
            cindex = conditions(ii);

            %W = initanalysisdata(cindex).FC.S; %for weighted connection matrix
            nneuros = length(initanalysisdata(cindex).FC.S);
            W = initanalysisdata(cindex).FC.S_n2;
            idx = logical(eye(size(W)));
            W(idx) = 0;
            L = 1./W; %undirected connection-length matrix, inverse of weights
            N = length(W);

            %clustering coefficient
            C_temp=clustering_coef_wu(W);
            CC(1,ii) = nanmean(C_temp);

            %degree distribution
            deg_temp = degrees_und(W);
            K(1,ii) = nanmean(deg_temp)/N;

            %strength
            str_temp = strengths_und(W);
            str(1,ii) = nanmean(str_temp)/N;

            %path length
            D = distance_wei(L);
            [lambda_temp,efficiency_temp] = charpath(D); %characteristic path length
            Eff(1,ii) = efficiency_temp;

            BC_temp = betweenness_wei(L); %betweenness centrality vector
            BC(1,ii) = nanmean(BC_temp)/N;

            density(1,ii)=density_und(W);
        end

    elseif celltype == 'n' && bin == 1;%neuron w/ binary graph
        for ii = 1:length(conditions) %loop thro
            cindex = conditions(ii);
            W = initanalysisdata(cindex).FC.A; %for binary connection matrix
            idx = logical(eye(size(W)));
            W(idx) = 0;
            L = 1./W; %undirected connection-length matrix, inverse of weights
            N = length(W);

            %clustering coefficient
            C_temp=clustering_coef_bu(W);
            CC(1,ii) = nanmean(C_temp);

            %degree distribution
            deg_temp = degrees_und(W);
            K(1,ii) = nanmean(deg_temp)/N;

            %path length
            Eff(1,ii) = efficiency_bin(W);

            BC_temp = betweenness_bin(W); %betweenness centrality vector
            BC(1,ii) = nanmean(BC_temp)/N;

            density(1,ii) = density_und(W);
            str(1,ii)=NaN;
         end

    else celltype == 'a' && bin == 0; %astrocyte w/ weighted graph
        for ii = 1:length(conditions) %loop through conditions
            cindex = conditions(ii);
            if isempty(analysis(cindex).aspikedata.F_cell) %|| analysis(cindex).FC.S_as == 0
                CC(1,ii)=NaN;
                K(1,ii)=NaN;
                Eff(1,ii)=NaN;
                BC(1,ii)=NaN;
                density(1,ii)=NaN;
                ncs(1,ii)=NaN;
                ncf(1,ii)=NaN;
                scs(1,ii)=NaN;
                scf(1,ii)=NaN;
                AR(1,ii)=NaN;
                Q_s(1,ii)=NaN;
                Q_f(1,ii)=NaN;
                nca(1,ii)=NaN;
                sca(1,ii)=NaN;
                AR_ag_af(1,ii)=NaN;
                AR_ag_as(1,ii)=NaN;
                str(1,ii)=NaN;

            else
                nneuros=length(initanalysisdata(cindex).FC.S);
                W = initanalysisdata(cindex).FC.S_multi(nneuros+1:end,nneuros+1:end); %for weighted connection matrix
                L = 1./W; %undirected connection-length matrix, inverse of weights
                N = length(W);
                %clustering coefficient
                C_temp=clustering_coef_wu(W);
                CC(1,ii) = nanmean(C_temp);

                %degree distribution
                deg_temp = degrees_und(W);
                K(1,ii) = nanmean(deg_temp)/N;

                %strength
                str_temp = strengths_und(W);
                str(1,ii) = nanmean(str_temp)/N;

                %path length
                D = distance_wei(L);
                [lambda_temp,efficiency_temp] = charpath(D); %characteristic path length
                Eff(1,ii) = efficiency_temp;

                BC_temp = betweenness_wei(L); %betweenness centrality vector
                BC(1,ii) = nanmean(BC_temp)/N;

                density(1,ii)=density_und(W);

            end
        end


    end
end
