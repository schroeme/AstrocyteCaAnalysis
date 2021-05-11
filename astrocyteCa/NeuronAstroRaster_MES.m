function NeuronAstroRaster_MES(folderpath)

%% Initialize
SourceFolder = folderpath;
TargetFolder = [folderpath filesep 'RasterPlots'];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep 'processed_analysis_astrocheck_spikech.mat']);
load([SourceFolder filesep files.name]); %load the processed analysis file

%% Plot Raster for each dish
fov = length(analysis);
astrocyte_indeces = [];
close all
conds = {'(A)';'(B)'};
for i = 1:fov %loop through each fov
    Hfig = figure(1);
    %suptitle(folderpath);
    [F,N] = size(analysis(i).nspikedata.rstr); %find the number of neruons in that FOV
    [F,A] = size(analysis(i).aspikedata.rstr);
    y = [];
    active_astros=analysis(i).activityfilterdata.activeastros;
    subplot(fov,1,i);
    for j = 1:N %for each active neuron
        x = find(analysis(i).nspikedata.rstr(:,j))';
        y(1:length(x)) = j;
        plot(x,y,'. b')
        hold on
        clear x y
    end 
    for k = 1:A %for each active astrocyte
        x = find(analysis(i).aspikedata.rstr(:,k))';
        y(1:length(x)) = active_astros(k);
        plot(x,y,'x r','LineWidth',2)
        hold on
        clear x y
    end 
    axis([0 1200 1 N+3])
    xlabel('time (s)')
    ylabel('Cell')
    title([conds{i}])
end 
 
%savefig(Hfig,[TargetFolder filesep 'Astrocyte-Labeled Raster']);
end 