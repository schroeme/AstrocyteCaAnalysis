function W = generate_weight_matrix_multilayer(folderpath,max_lag,n_ctrls)

%% Initialize
SourceFolder = [folderpath]
%TargetFolder = [folderpath filesep 'networkdata'];
TargetFolder = [folderpath];

% if ~exist(TargetFolder, 'dir')
%  mkdir(TargetFolder);
% end

%get & load .mat processed_analysis file in the folder
load([SourceFolder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3.mat']);
initanalysisdata=analysis;

%% Run code to generate either binary or weighted adjacency matrix

if isempty(analysis(1).aspikedata.F_cell)
    disp('No active astrocytes :(')
    S_multilayer = [];
    A_multilayer = [];
    for cindex = 1:length(initanalysisdata)-1
        if cindex ~= 3
            initanalysisdata(cindex).FC.S_multi = S_multilayer;
            initanalysisdata(cindex).FC.A_multi = A_multilayer;
        end
    end
            
else
    for cindex = 1:length(initanalysisdata)-1
        if cindex ~= 3 %skip over injury condition

            %ASTROS
            %find the active astro segments
            atraces = initanalysisdata(cindex).aspikedata.F_cell; %grab flourescence traces
            BGa = initanalysisdata(cindex).aspikedata.BG;
            BGa = repmat(BGa,1,size(atraces,2));
            atraces = (atraces - BGa)./BGa;

            %NEURONS
            %find active neuron traces
            ntraces = initanalysisdata(cindex).nspikedata.F_cell; %grab flourescence traces
            BGn = initanalysisdata(cindex).nspikedata.BG;
            BGn = repmat(BGn,1,size(ntraces,2));
            ntraces = (ntraces - BGn)./BGn;

            %filter the traces and make smooth_trace;
            [b,a] = butter(5,1/2,'low');
            filtered_atraces = filter(b,a,atraces);
            filtered_ntraces = filter(b,a,ntraces);
            
            nneuros = size(filtered_ntraces,2);

            all_traces = [filtered_ntraces filtered_atraces];
            A_multilayer = zeros(size(all_traces,2),size(all_traces,2));
            S_multilayer = zeros(size(all_traces,2),size(all_traces,2));

            lags = 0:(max_lag*(2/100)); %convert max lag in ms to frames
            lags = [lags lags];

            %3D matrix
            corr_temp=corr_lagged(all_traces,all_traces,lags);
            [maxcorr,ind] = max(corr_temp,[],3);

            %loop through all neurons and astros
            for ii = 1:size(all_traces,2)
                parfor jj = 1:size(all_traces,2)
                    if (jj>ii)
                        %lag(ii,jj) = lags(ind(ii,jj));
                        ctrl_y = AAFTsur(all_traces(:,jj),n_ctrls);
                        corr_ctrl =corr_lagged(all_traces(:,ii),ctrl_y,lags,ind(ii,jj));
                        zscore = (maxcorr(ii,jj) - mean(corr_ctrl))/std(corr_ctrl);
                        p = 1-normcdf(zscore);
                        h=0;
                        if p < 0.05;
                            h = 1;
                        end
                        if h
                            S_multilayer(ii,jj) = maxcorr(ii,jj);
                        else
                            S_multilayer(ii,jj) = 0;
                        end
                        A_multilayer(ii,jj) = h;
                    else
                        S_multilayer(ii,jj) = 0;
                        A_multilayer(ii,jj) = 0;
                    end
                end
            end
            
            astro_group = initanalysisdata(cindex).neuroastro.astro_group;
            active_astros = initanalysisdata(cindex).neuroastro.astrocytes(initanalysisdata(cindex).activityfilterdata.activeastros);
            astro_group(:,3) = ismember(astro_group(:,1),active_astros);
            astro_group = astro_group(find(astro_group(:,3)),:); %get rid of nonactive cells
        
            A_multilayer=A_multilayer+A_multilayer';
            S_multilayer=S_multilayer+S_multilayer';
            %get diagonals and set them to 0
            idx = logical(eye(size(S_multilayer)));
            S_multilayer(idx) = 0; %set diagonals equal to 0 (no self-loops)
            A_multilayer(idx) = 0;

            figure()
            subplot(1,2,1)
            imagesc(S_multilayer)
            subplot(1,2,2)
            imagesc(A_multilayer)
            
            initanalysisdata(cindex).FC.S_multi = S_multilayer;
            initanalysisdata(cindex).FC.A_multi = A_multilayer;
            initanalysisdata(cindex).FC.S_as = S_multilayer(nneuros+1:end,nneuros+1:end);
            initanalysisdata(cindex).FC.A_as = A_multilayer(nneuros+1:end,nneuros+1:end);
            initanalysisdata(cindex).FC.S_n2 = S_multilayer(1:nneuros,1:nneuros);
            initanalysisdata(cindex).FC.A_n2 = A_multilayer(1:nneuros,1:nneuros);
            %initanalysisdata(cindex).FC.astro_group = astro_group;

        end
    end
end
analysis = initanalysisdata;

save([TargetFolder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3'],'analysis');
