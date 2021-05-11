function W = generate_weight_matrix_astros(folderpath,binary,max_lag,n_ctrls)

%% Initialize
SourceFolder = [folderpath];
TargetFolder = [folderpath filesep 'networkdata'];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%get & load .mat processed_analysis file in the folder
load([SourceFolder filesep 'processed_analysis_astrocheck_spikech_actfilt.mat']);
initanalysisdata=analysis;

load([TargetFolder filesep 'processed_analysis_astrocheck_spikech_actfilt.mat']);
analysistarget=analysis;
% if length(initanalysisdata) < 5
%     initanalysisdata(4:5) = initanalysisdata(3:4); %make a dummy condition
% end
%     

if binary
    output = [1 1];
else
    output = [0 1];
end

%% Run code to generate either binary or weighted adjacency matrix

for cindex = 1:length(initanalysisdata)-1
    if cindex ~= 3 %skip over injury condition
        %individual segments
        %find the active segments
        traces = initanalysisdata(cindex).aspikedata.F_cell; %grab flourescence traces
        BG = initanalysisdata(cindex).aspikedata.BG;
        BG = repmat(BG,1,size(traces,2));
        traces = (traces - BG)./BG;
        
        %filter the traces and make smooth_trace;
        [b,a] = butter(5,1/2,'low');
        filtered_traces = filter(b,a,traces);
        
        lags = 0:(max_lag*(2/100)); %convert max lag in ms to frames
        lags = [lags lags];
        
        %3D matrix
        corr_temp=corr_lagged(filtered_traces,filtered_traces,lags);
        [maxcorr,ind] = max(corr_temp,[],3);
        
        for ii = 1:size(filtered_traces,2)
            for jj = 1:size(filtered_traces,2)
                %correlation between x and y, with a lag allowed
%                 corr_temp=corr_lagged(filtered_traces(:,ii),filtered_traces(:,jj),lags,1);
%                 [maxcorr, ind] = max(corr_temp);
                lag(ii,jj) = lags(ind(ii,jj));
                %correlation between x and randomized y, with a lag allowed
                %ctrl_x = AAFTsur(filtered_traces(:,ii),n_ctrls);
                ctrl_y = AAFTsur(filtered_traces(:,jj),n_ctrls);
                corr_ctrl =corr_lagged(filtered_traces(:,ii),ctrl_y,lags,ind);
                
                zscore = (maxcorr(ii,jj) - mean(corr_ctrl))/(std(corr_ctrl)/sqrt(n_ctrls));
                p = 1-normcdf(zscore);
                h=0;
                if p < 0.001;
                    h = 1;
                end
                if h
                    S(ii,jj) = maxcorr(ii,jj);
                else
                    S(ii,jj) = 0;
                end
                A(ii,jj) = h;
            end
        end
        
        %whole cells
        astro_group = initanalysisdata(cindex).neuroastro.astro_group;
        active_astros = initanalysisdata(cindex).neuroastro.astrocytes(initanalysisdata(cindex).activityfilterdata.activeastros);
        astro_group(:,3) = ismember(astro_group(:,1),active_astros);
        astro_group = astro_group(find(astro_group(:,3)),:); %get rid of nonactive cells
        
        %get number of unique active astros
        unique_aa=unique(astro_group(:,2));
        for ii = 1:length(unique_aa) %loop through each group
            g1idx = unique_aa(ii); %get group index
            cell_inds_group1 = find(astro_group(:,2)==g1idx); %find the index of cell in this group
            for jj = 1:length(unique_aa)
                g2idx = unique_aa(jj);
                cell_inds_group2 = find(astro_group(:,2)==g2idx);
                %loop through each pair of cells in each group and average
                %their connectivity
                for kk = 1:length(cell_inds_group1)
                    S_groups(kk,:) = S(cell_inds_group1(kk),cell_inds_group2);
%                     A_groups(kk,:) = A(cell_inds_group1(kk),cell_inds_group2);
                end    
            S_grouped(ii,jj) = mean(mean(S_groups));
%             A_grouped(ii,jj) = mean(mean(A_groups));
            clear S_groups
            end
        end
        
        if exist('S')
            %get diagonals
            idx = logical(eye(size(S)));
            idx_g = logical(eye(size(S_grouped)));
            S(idx) = 0; %set diagonals equal to 0 (no self-loops)
            S_grouped(idx_g) = 0;
            A(idx) = 0;
%             A_grouped(idx_g) = 0;
            figure()
            subplot(2,2,1)
            imagesc(S)
            subplot(2,2,2)
            imagesc(A)
            subplot(2,2,3)
            imagesc(S_grouped)
%             subplot(2,2,4)
%             imagesc(A_grouped)
        else
            disp('No active astrocytes :(')
            S = [];
            A = [];
            S_grouped = [];
%             A_grouped = [];
        end
        
        analysistarget(cindex).FC.S_as = S;
        analysistarget(cindex).FC.A_as = A;
        analysistarget(cindex).FC.S_ag = S_grouped;
%         analysistarget(cindex).FC.A_ag = A_grouped;
        
    end
%     if binary
%         W{cindex} = A;
%     else
%         W{cindex} = S;
%     end
end

analysis = analysistarget;

save([TargetFolder filesep 'processed_analysis_astrocheck_spikech_actfilt'],'analysis');
