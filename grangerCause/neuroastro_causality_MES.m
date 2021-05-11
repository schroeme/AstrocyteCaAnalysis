function neuroastro_causality_MES(folderpath,nctrls)

%Load the data
    load([folderpath filesep 'processed_analysis_astrocheck_spikech_actfilt.mat']);
    initanalysisdata=analysis;
    clear analysis
    
%Set parameters
alpha = 0.05; %probability of false positive
max_lag = 40; %number of lags to consider

%Call on the granger causality function
    for cindex=1:1%length(initanalysisdata) %loop through each condition
        %if cindex ~=3 %for all other conditions except injury
            
%             astros = initanalysisdata(cindex).neuroastro.astrocytes;
%             active_astros = astros(initanalysisdata(cindex).activityfilterdata.activeastros);
%             neuros = [initanalysisdata(cindex).neuroastro.other_neurons initanalysisdata(cindex).neuroastro.neighbor_neurons'];
%             active_neuros = neuros(initanalysisdata(cindex).activityfilterdata.activeneurons);
            
            %find the active astro segments
            atraces = initanalysisdata(cindex).aspikedata.F_cell; %grab flourescence traces
            BGa = initanalysisdata(cindex).aspikedata.BG;
            BGa = repmat(BGa,1,size(atraces,2));
            atraces = atraces./BGa;

            %NEURONS
            %find active neuron traces
            ntraces = initanalysisdata(cindex).nspikedata.F_cell; %grab flourescence traces
            BGn = initanalysisdata(cindex).nspikedata.BG;
            BGn = repmat(BGn,1,size(ntraces,2));
            ntraces = ntraces./BGn;

            %filter the traces and make smooth_trace;
            [b,a] = butter(15,.2,'low');
            filtered_atraces = filter(b,a,atraces);
            filtered_ntraces = filter(b,a,ntraces);
            
            filtered_atraces=filtered_atraces(30:end,:);
            filtered_ntraces=filtered_ntraces(30:end,:);
            
            nneuros = size(filtered_ntraces,2);
            nastros = size(filtered_atraces,2);
            
            %initialize data storage matrix
            F_an = zeros(nastros,nneuros);
            F_na = F_an;
            c_v_an = F_an;
            c_v_na = F_an;
            
%             F_an_ctrl = F_an;
%             F_na_ctrl = F_an;
%             c_v_an_ctrl = F_an;
%             c_v_na_ctrl = F_an;
            
            astro_cause_neuro_count = 0;
            neuro_cause_astro_count = 0;
            
            astro_cause_neuro_count_ctrl = 0;
            neuro_cause_astro_count_ctrl = 0;

            for aindex = 1:nastros%loop through each astrocyte
                a = filtered_atraces(:,aindex);
                a_perm = AAFTsur(a,nctrls);
                
                for nindex = 1:nneuros%loop through each neuron
                    n = filtered_ntraces(:,nindex);
                    n_perm = AAFTsur(n,nctrls);
                    
                    %does a cause n?
                    [F_an(aindex,nindex),c_v_an(aindex,nindex)] = granger_cause(n,a,alpha,max_lag);
                    
                    %does n cause a?
                    [F_na(aindex,nindex),c_v_na(aindex,nindex)] = granger_cause(a,n,alpha,max_lag);
                    
%                         [F_na_ctrl(aindex,nindex),c_v_na_ctrl(aindex,nindex)] = granger_cause(a_perm,n_perm,alpha,max_lag);
%                         [F_an_ctrl(aindex,nindex),c_v_an_ctrl(aindex,nindex)] = granger_cause(n_perm,a_perm,alpha,max_lag);                    
                    %go through the controls
                    for ctindex = 1:nctrls
                        [F_na_ctrl(ctindex,1),c_v_na_ctrl(ctindex,1)] = granger_cause(a,n_perm(:,ctindex),alpha,max_lag);
                        [F_an_ctrl(ctindex,1),c_v_an_ctrl(ctindex,1)] = granger_cause(n,a_perm(:,ctindex),alpha,max_lag);
                    end
                    isnactrl=F_na_ctrl>c_v_na_ctrl;
                    pna=mean(isnactrl);
                    isanctrl=F_an_ctrl>c_v_an_ctrl;
                    pan=mean(isanctrl);
                    
                    %We reject the null hypothesis that y does not Granger Cause x if the F-statistic is greater than the critical value
                    if pna < 0.1 && F_na(aindex,nindex) > c_v_na(aindex,nindex) %if not a false positive
                        neuro_cause_astro_count = neuro_cause_astro_count + 1;
                    else
                        F_na(aindex,nindex) = 0; %false positive or not strong enough
                    end
                    
                    if pan < 0.1 && F_an(aindex,nindex) > c_v_an(aindex,nindex)
                        astro_cause_neuro_count = astro_cause_neuro_count + 1;
                    else
                        F_an(aindex,nindex) = 0; %false positive or not strong enough
                    end
                
                end
                clear a n n_perm a_perm
            end
            initanalysisdata(cindex).neuroastro.F_an=F_an;
            initanalysisdata(cindex).neuroastro.F_na=F_na;
            initanalysisdata(cindex).neuroastro.c_v_an=c_v_an;
            initanalysisdata(cindex).neuroastro.c_v_na=c_v_na;
            initanalysisdata(cindex).neuroastro.an_cause_percent=(astro_cause_neuro_count)/(numel(initanalysisdata(cindex).neuroastro.F_na));
            initanalysisdata(cindex).neuroastro.na_cause_percent=(neuro_cause_astro_count)/(numel(initanalysisdata(cindex).neuroastro.F_an));
            initanalysisdata(cindex).neuroastro.mag_an_causality=log(F_an);
            initanalysisdata(cindex).neuroastro.mag_na_causality=log(F_na);
            
            initanalysisdata(cindex).neuroastro.F_an_ctrl=F_an_ctrl;
            initanalysisdata(cindex).neuroastro.F_na_ctrl=F_na_ctrl;
            initanalysisdata(cindex).neuroastro.c_v_an_ctrl=c_v_an_ctrl;
            initanalysisdata(cindex).neuroastro.c_v_na_ctrl=c_v_na_ctrl;
            initanalysisdata(cindex).neuroastro.an_cause_percent_ctrl=(astro_cause_neuro_count_ctrl)/(numel(initanalysisdata(cindex).neuroastro.F_na));
            initanalysisdata(cindex).neuroastro.na_cause_percent_ctrl=(neuro_cause_astro_count_ctrl)/(numel(initanalysisdata(cindex).neuroastro.F_an));
            initanalysisdata(cindex).neuroastro.mag_an_causality_ctrl=log(F_an_ctrl);
            initanalysisdata(cindex).neuroastro.mag_na_causality_ctrl=log(F_na_ctrl);

            analysis = initanalysisdata;
            save([folderpath filesep 'processed_analysis_astrocheck_spikech.mat'],'analysis');
            clear F_an F_na c_v_an c_v_na astro_cause_neuro_count neuro_cause_astro_count F_an_ctrl F_na_ctrl c_v_an_ctrl c_v_na_ctrl astro_cause_neuro_count_ctrl neuro_cause_astro_count_ctrl
        %end
    end
