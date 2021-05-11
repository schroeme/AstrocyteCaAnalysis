function NA_SpikeAnalysis_Margaret_forMattsCode(folderpath)

load([folderpath filesep 'processed_analysis_astrocheck.mat']);
initanalysisdata=analysis;
clear analysis


for conditionno=1:length(initanalysisdata)
    analysis=initanalysisdata(conditionno);
    astrocytes=analysis(conditionno).neuroastro.astrocytes;
    neurons=analysis(conditionno).neuroastro.neurons;
    
    %Run neuron spike detection
    neurospikedata=spike_detect_mah_v1_Alexeditsv2_MESastros(folderpath,analysis,neurons);
    
    %Run astro spike detection
    astrospikedata=astro_eventdetection_MES(folderpath,analysis,astrocytes);
    
    initanalysisdata(conditionno).neurospikedata=neurospikedata;
    initanalysisdata(conditionno).astrospikedata=astrospikedata;
    clear analysis
end

analysis=initanalysisdata;
save([folderpath filesep 'processed_analysis_astrocheck.mat'],'analysis');

 