function neuroastro_causality_inj_ctrl_MES(folderpath)

%Load the data
    load([folderpath filesep 'processed_analysis_inj_spikech.mat']);
    initanalysisdata=analysis;
    clear analysis
    
%Set parameters
alpha = 0.05; %probability of false positive
max_lag = 10; %number of lags to consider

%Call on the granger causality function
        %initialize data storage matrix
        F_an_ctrl = zeros(size(initanalysisdata.aspikedata.rstr,2),size(initanalysisdata.nspikedata.rstr,2));
        F_na_ctrl = zeros(size(initanalysisdata.aspikedata.rstr,2),size(initanalysisdata.nspikedata.rstr,2));
        c_v_an_ctrl = zeros(size(initanalysisdata.aspikedata.rstr,2),size(initanalysisdata.nspikedata.rstr,2));
        c_v_na_ctrl = zeros(size(initanalysisdata.aspikedata.rstr,2),size(initanalysisdata.nspikedata.rstr,2));
        astro_cause_neuro_count = 0;
        neuro_cause_astro_count = 0;
        
        neurons = [initanalysisdata.neuroastro.neighbor_neurons' initanalysisdata.neuroastro.other_neurons];
        astrocytes = initanalysisdata.neuroastro.astrocytes;
        
        for aindex = 1:size(initanalysisdata.aspikedata.rstr,2)%loop through each astrocyte
            %a = initanalysisdata(cindex).aspikedata.rstr(:,aindex); %column vector of astro spike train
            a = initanalysisdata.F_cell(astrocytes(aindex),:)';
            a = a(randperm(length(a)));
            
            for nindex = 1:size(initanalysisdata.nspikedata.rstr,2)%loop through each neuron
                %n = initanalysisdata(cindex).nspikedata.rstr(:,nindex); %column vector of neuro spike train
                n = initanalysisdata.F_cell(neurons(nindex),:)';
                n = n(randperm(length(n)));
                
                %does a cause n?
                [F_an_ctrl(aindex,nindex),c_v_an_ctrl(aindex,nindex)] = granger_cause(n,a,alpha,max_lag);
                %does n cause a?
                [F_na_ctrl(aindex,nindex),c_v_na_ctrl(aindex,nindex)] = granger_cause(a,n,alpha,max_lag);
 
                %We reject the null hypothesis that y does not Granger Cause x if the F-statistic is greater than the critical value
                if F_an_ctrl(aindex,nindex) > c_v_an_ctrl(aindex,nindex) && F_na_ctrl(aindex,nindex) > c_v_na_ctrl(aindex,nindex)
                    %disp('dual')
                elseif F_an_ctrl(aindex,nindex) > c_v_an_ctrl(aindex,nindex)
                    astro_cause_neuro_count = astro_cause_neuro_count + 1;
                    %disp('neuro causes astro')
                elseif F_na_ctrl(aindex,nindex) > c_v_na_ctrl(aindex,nindex)
                    neuro_cause_astro_count = neuro_cause_astro_count + 1;
                    %disp('astro causes neuro')
                end 
            end
            clear a n
        end
        initanalysisdata.neuroastro.F_a_ctrl=F_an_ctrl;
        initanalysisdata.neuroastro.F_na_ctrl=F_na_ctrl;
        initanalysisdata.neuroastro.c_v_an_ctrl=c_v_an_ctrl;
        initanalysisdata.neuroastro.c_v_na_ctrl=c_v_na_ctrl;
        initanalysisdata.neuroastro.an_cause_percent_ctrl=(astro_cause_neuro_count)/(numel(initanalysisdata(1).neuroastro.F_na));
        initanalysisdata.neuroastro.na_cause_percent_ctrl=(neuro_cause_astro_count)/(numel(initanalysisdata(1).neuroastro.F_an));
        initanalysisdata.neuroastro.mag_an_causality_ctrl=log(F_an_ctrl);
        initanalysisdata.neuroastro.mag_na_causality_ctrl=log(F_na_ctrl);
        
        analysis = initanalysisdata;
        save([folderpath filesep 'processed_analysis_inj_spikech.mat'],'analysis');
        clear F_an_ctrl F_na_ctrl c_v_an_ctrl c_v_na_ctrl astro_cause_neuro_count neuro_cause_astro_count
        
    end
