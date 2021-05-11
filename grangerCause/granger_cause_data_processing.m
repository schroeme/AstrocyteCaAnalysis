function granger_cause_data_processing

%% Running section - ACTUAL
% list all folders to analyze and group together here:
allfolders={         
              'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01';
              'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02';
              'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03';
              'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01';
              'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02';
              'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01';
              'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02';
              'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03';
'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01';
'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02';
'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03';
'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04';
'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05';
'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01';
'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02';
        };
    
for findex = 1:length(allfolders)
    folder=allfolders{findex};
    load([folder filesep 'processed_analysis_astrocheck_spikech_GC2.mat'])
    
    for cindex = 1:1
        try
            %N-A causality
            CD_na(cindex,findex)=analysis(cindex).GC.cd_na;
            PC_na(cindex,findex)=analysis(cindex).GC.pc_na;
            %A-N causality
            CD_an(cindex,findex)=analysis(cindex).GC.cd_an;
            PC_an(cindex,findex)=analysis(cindex).GC.pc_an;
        catch
            disp('Caught')
            CD_na(cindex,findex)=NaN;
            PC_na(cindex,findex)=NaN;
            %A-N causality
            CD_an(cindex,findex)=NaN;
            PC_an(cindex,findex)=NaN;
        end
    end
end