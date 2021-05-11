function granger_cause_data_processing_inj_MS

%% Running section
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


%% Injury pds 

for findex = 1:length(allfolders) %loop through each folder

        folder=allfolders{findex};
        direct=dir(folder);
        names = {direct.name}';
        dirIndex = [direct.isdir];
        subfolders=names(dirIndex);
        subfolders=subfolders(3:end);
        postidx=strfind(subfolders,'Post');
        postidx=find(not(cellfun('isempty',postidx)));

        for ii = 1:postidx(1)-1 %loop through all injury periods
            subfolder=subfolders{ii};
            try
                load([folder filesep subfolder filesep 'processed_analysis_astrocheck_spikech_GC'])
                if ~isempty(analysis.GC.pc_na) && isreal(analysis.GC.F)
                    pc_na(ii,1) = analysis.GC.pc_na;
                    pc_an(ii,1) = analysis.GC.pc_an;
                    cd_na(ii,1) = analysis.GC.cd_na;
                    cd_an(ii,1) = analysis.GC.cd_an;
                else
                    pc_na(ii,1) = NaN;
                    pc_an(ii,1) = NaN;
                    cd_na(ii,1) = NaN;
                    cd_an(ii,1) = NaN;
                end
            catch
                pc_na(ii,1) = NaN;
                pc_an(ii,1) = NaN;
                cd_na(ii,1) = NaN;
                cd_an(ii,1) = NaN;
            end
        end
        mean_pc_na_inj(1,findex)=nanmean(pc_na);
        mean_pc_an_inj(1,findex)=nanmean(pc_an);
        mean_cd_na_inj(1,findex)=nanmean(cd_na);
        mean_cd_an_inj(1,findex)=nanmean(cd_an);
        
        clear pc_na pc_an cd_na cd_an
        for pp = postidx(1):postidx(end) %loop through all post injury periods
            subfolder=subfolders{pp};
            try
                load([folder filesep subfolder filesep 'processed_analysis_astrocheck_spikech_GC'])
                if ~isempty(analysis.GC.pc_na) && isreal(analysis.GC.F)
                    pc_na(pp,1) = analysis.GC.pc_na;
                    pc_an(pp,1) = analysis.GC.pc_an;
                    cd_na(pp,1) = analysis.GC.cd_na;
                    cd_an(pp,1) = analysis.GC.cd_an;
                else
                    pc_na(pp,1) = NaN;
                    pc_an(pp,1) = NaN;
                    cd_na(pp,1) = NaN;
                    cd_an(pp,1) = NaN;
                end
            catch
                pc_na(pp,1) = NaN;
                pc_an(pp,1) = NaN;
                cd_na(pp,1) = NaN;
                cd_an(pp,1) = NaN;
            end
        end
        mean_pc_na_postinj(1,findex)=nanmean(pc_na);
        mean_pc_an_postinj(1,findex)=nanmean(pc_an);
        mean_cd_na_postinj(1,findex)=nanmean(cd_na);
        mean_cd_an_postinj(1,findex)=nanmean(cd_an);
        clear pc_na pc_an cd_na cd_an

end