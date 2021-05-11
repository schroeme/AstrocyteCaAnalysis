function CollectAstrocyteTraces(folderpath)
%% Initialiaze 

SourceFolder = folderpath;
TargetFolder = [SourceFolder filesep 'AstrocyteTraces'];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep 'processed_analysis_spikech.mat']);
load([SourceFolder filesep files.name]); %load the processed analysis file
analysisfile=analysis;

%% Collect astrocyte traces

for cindex = 1:length(analysis) %loop through each fov
    astrocyte_indeces = analysis(cindex).neuroastro.astrocytes;%get indices of confirmed astrocytes
    for aindex = 1:length(astrocyte_indeces)
        trace{aindex,cindex}=(analysis(cindex).F_cell_scaled(astrocyte_indeces(aindex),:));
    end  
end

save([TargetFolder filesep '_astrotrace'],'trace');

end
