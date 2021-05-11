function [FCdistcorr_na,FCdistcorr_nn,FCdistcorr_aa,...
    weights_nn,weights_aa,weights_na] = mln_FCdistcorr(folder,nsamples)
% Compares functionally and spatially-derived weights for each layer and inter-layer weights
% Collapses weights into vector form for plotting and calculates a
% Pearson's correlation between the two
%

rng(0); %set random number generator seed

load([folder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat'])
initanalysisdata=analysis;
conditions = [1 2 4];
%% running section

for ii = 1:3 %loop through conditions
    cindex = conditions(ii);
    nneuros = size(analysis(cindex).nspikedata.F_cell,2);
    W_nn = analysis(cindex).FC.S_n2;
    dist_nn = analysis(cindex).FC.n_dist;
    
    %create random matrices with diagonal equal to zero
    for rr = 1:nsamples
        rand_n1 = rand(nneuros,nneuros);
        rand_n2 = rand(nneuros,nneuros);
        idx = logical(eye(size(rand_n1)));
        rand_n1(idx) = 0; %set diagonals equal to 0 (no self-loops)
        rand_n2(idx) = 0;
        randcorr(rr,1) = corr2(rand_n1,rand_n2);
    end
    
    FCdistcorr_nn(ii,1)=corr2(W_nn,dist_nn) - mean(randcorr);
    weights_nn{ii} = flatten_combine_weights(W_nn,dist_nn);
    
    if isempty(analysis(1).aspikedata.F_cell) % if 2 or fewer active astrocytes
        FCdistcorr_na(ii,1)=NaN;
        FCdistcorr_aa(ii,1)=NaN;

        weights_aa{ii} = [];
        weights_na{ii} = [];
    elseif numel(analysis(1).FC.S_as) <= 4
        FCdistcorr_na(ii,1)=NaN;
        FCdistcorr_aa(ii,1)=NaN;

        weights_aa{ii} = [];
        weights_na{ii} = [];
    else
        nastros = size(analysis(cindex).aspikedata.F_cell,2);
        ntot = nneuros+nastros;
        W = initanalysisdata(cindex).FC.S_multi; %for weighted connection matrix
        W_na = W(1:nneuros,nneuros+1:ntot);
        W_aa = analysis(cindex).FC.S_as;
        
        dist_aa = analysis(cindex).FC.a_dist;
        dist_na = analysis(cindex).FC.na_dist;
        
        for rr = 1:nsamples
            %create random matrices with diagonal equal to zero
            rand_a1 = rand(nastros,nastros);
            rand_a2 = rand(nastros,nastros);
            idx = logical(eye(size(rand_a1)));
            rand_a1(idx) = 0; %set diagonals equal to 0 (no self-loops)
            rand_a2(idx) = 0;
            randcorr_aa(rr,1) = corr2(rand_a1,rand_a2);

            %create random matrices with diagonal equal to zero
            rand_na1 = rand(size(dist_na));
            rand_na2 = rand(size(dist_na));
            randcorr_na(rr,1) = corr2(rand_na1,rand_na2);
        end
        
        FCdistcorr_na(ii,1)=corr2(W_na,dist_na) - mean(randcorr_aa);
        FCdistcorr_aa(ii,1)=corr2(W_aa,dist_aa) - mean(randcorr_na);
        weights_aa{ii} = flatten_combine_weights(W_aa,dist_aa);
        weights_na{ii} = flatten_combine_weights(W_na,dist_na);
        
    end

end