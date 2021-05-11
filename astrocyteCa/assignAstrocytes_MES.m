function assignAstrocytes_MES(folderpath)

%% Initialize

SourceFolder = [folderpath];
TargetFolder = [folderpath];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep 'processed_analysis.mat']);
load([SourceFolder filesep files.name]);
initanalysisdata=analysis;

%% Manually identify astrocytes
for cindex=1:length(analysis)
    astrocytes=[];
    
    [filepath,name,ext] = fileparts(analysis(cindex).filename);
    
    figure(1)
    uiopen([SourceFolder filesep 'segmentation' filesep 'Segmentation-' name '_labeled.fig'],1)
    
    disp([SourceFolder ' cond ' num2str(cindex)])
    x = input('Enter astrocyte indeces (if none, type 0):');
        if x == 0
            astrocytes = [];
        else 
            astrocytes = x;
        end
    
    %Save astrocyte & neuron indices
    analysis(cindex).neuroastro.astrocytes=astrocytes;
    neuron_indices = 1:size(analysis(cindex).F_cell,1);%create a vector with indices for neurons
    analysis(cindex).neuroastro.neurons=setdiff(neuron_indices,astrocytes);%save true neuron indices as difference between all indices and astro indices
    save([TargetFolder filesep 'processed_analysis_astro.mat'],'analysis');
    
    close(figure(1))
end

end 