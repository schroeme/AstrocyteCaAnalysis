function SpikeAnalysis_neuroastro_MS(folderpath)

load([folderpath filesep 'processed_analysis_astrocheck.mat']);

%uncomment this if you had to register
% load([folderpath filesep 'registration\renumbering_map']);
initanalysisdata=analysis;
clear analysis
for conditionno=1:1%length(initanalysisdata)
    %if conditionno ~= 3 %for all other conditions but injury (3rd condition)
        analysis=initanalysisdata(conditionno);
        astrocytes=analysis.neuroastro.astrocytes;
        
%         %uncomment this if you had to register
%         astrocyte_indices = analysis.neuroastro.astrocytes;
%         astrocytes = NaN(1,length(astrocyte_indices));
%         for aindex = 1:length(astrocyte_indices)
%             try
%                 astrocytes(aindex) = find(r_map(:,conditionno+1)==astrocyte_indices(aindex));
%             catch
%                 continue
%             end 
%         end
%         astrocytes = ~isnan(astrocytes);
%         
        try
            neurons=[analysis.neuroastro.neighbor_neurons' analysis.neuroastro.other_neurons];
        catch
            neurons=analysis.neuroastro.other_neurons;
        end
%         %uncomment this if you had to register
%         neuron_indices = [analysis.neuroastro.neighbor_neurons; analysis.neuroastro.other_neurons'];
%         neurons = NaN(1,length(neuron_indices));
%         for nindex = 1:length(neuron_indices)
%             try
%                 neurons(nindex) = find(r_map(:,conditionno+1)==neuron_indices(nindex));
%             catch
%                 continue
%             end
%         end
%         neurons = ~isnan(neurons);
%         
        aspikedata=astro_eventdetection_MES(folderpath,analysis,astrocytes);
        nspikedata=spike_detect_mah_v1_Alexeditsv2_MESastros(folderpath,analysis,neurons);

        initanalysisdata(conditionno).aspikedata=aspikedata;
        initanalysisdata(conditionno).nspikedata=nspikedata;
        clear analysis
    %end
end

analysis=initanalysisdata;
save([folderpath filesep 'processed_analysis_astrocheck.mat'],'analysis');

 