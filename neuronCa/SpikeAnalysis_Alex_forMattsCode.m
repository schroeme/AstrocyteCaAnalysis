function SpikeAnalysis_Alex_forMattsCode(folderpath)

load([folderpath filesep 'processed_analysis.mat']);
initanalysisdata=analysis;
clear analysis

for conditionno=1:length(initanalysisdata)
    %for conditionno=2:2
    analysis=initanalysisdata(conditionno);
    spikedata=spike_detect_mah_v1_Alexeditsv2(folderpath,analysis);
    
    initanalysisdata(conditionno).spikedata=spikedata;
    clear analysis
end

analysis=initanalysisdata;
save([folderpath filesep 'processed_analysis.mat'],'analysis');

 