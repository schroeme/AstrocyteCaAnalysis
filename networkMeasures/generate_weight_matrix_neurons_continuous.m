function W = generate_weight_matrix_neurons_continuous(folderpath,max_lag,n_ctrls)

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

%% Run code to generate either binary or weighted adjacency matrix for neurons


for cindex = 1:length(initanalysisdata)-1
    if cindex ~= 3 %skip over injury condition

        %NEURONS
        %find active neuron traces
        ntraces = initanalysisdata(cindex).nspikedata.F_cell; %grab flourescence traces
        BGn = initanalysisdata(cindex).nspikedata.BG;
        BGn = repmat(BGn,1,size(ntraces,2));
        ntraces = (ntraces - BGn)./BGn;

        %filter the traces and make smooth_trace;
        [b,a] = butter(5,1/2,'low');
        all_traces= filter(b,a,ntraces);

        nneuros = size(all_traces,2);

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
                        S(ii,jj) = maxcorr(ii,jj);
                    else
                        S(ii,jj) = 0;
                    end
                    A(ii,jj) = h;
                else
                    S(ii,jj) = 0;
                    A(ii,jj) = 0;
                end
            end
        end


        A=A+A';
        S=S+S';
        %get diagonals and set them to 0
        idx = logical(eye(size(S)));
        S(idx) = 0; %set diagonals equal to 0 (no self-loops)
        A(idx) = 0;

        figure()
        subplot(1,2,1)
        imagesc(S)
        subplot(1,2,2)
        imagesc(A)

        initanalysisdata(cindex).FC.S_n2 = S;
        initanalysisdata(cindex).FC.A_n2 = A;

    end
end
analysis = initanalysisdata;

save([TargetFolder filesep 'processed_analysis_astrocheck_spikech_actfilt_v3'],'analysis');
