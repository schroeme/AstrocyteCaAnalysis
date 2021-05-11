function NeuronAstroTraceMES(folderpath)
%% Initialiaze 

SourceFolder = folderpath;
TargetFolder = [folderpath filesep 'Neuron-Astro Traces'];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep 'processed_analysis_spikech.mat']);
load([SourceFolder filesep files.name]); %load the processed analysis file
analysisfile=analysis;

%% Plot astrocyte traces

cells_perplot = 5;
%Count the number of events for each cell
for i = 1:length(analysis) %loop through each fov
    [T,N] = size(analysis(i).spikedata.rstr); %find the total number of cells
%     time_scaled = (1:T)./20;
    astrocyte_indeces = analysis(i).neuroastro.astrocytes;
    astrofig=figure;
    if length(astrocyte_indeces) < cells_perplot
        for k = 1:length(astrocyte_indeces)
            subplot(cells_perplot,1,k)
            plot(analysis(i).F_cell_scaled(astrocyte_indeces(k),:))
            title(['Astrocyte ' num2str(astrocyte_indeces(k))])
        end 
        xlabel('Time (s)')
        ylabel('Scaled flourescence')
        suptitle(['Condition ' num2str(i)])
        print(astrofig,'-dtiff',[TargetFolder filesep files(i).name(1:end-4) '_astro_trace.tif'])
        savefig(astrofig,[TargetFolder filesep files(i).name(1:end-4) '_astro_trace']);   
    else 
        for j = 1:round(length(astrocyte_indeces)/cells_perplot)
           round(length(astrocyte_indeces)/cells_perplot)
           astrofig=figure;
           for k = 1:cells_perplot
               subplot(cells_perplot,1,k)
               plot(analysis(i).F_cell_scaled(astrocyte_indeces(((j-1)*cells_perplot + k),:)))
               title(['Astrocyte ' num2str(astrocyte_indeces((j-1)*cells_perplot + k))])
           end 
           xlabel('Time (s)')
           ylabel('Scaled flourescence')
           savefig(astrofig,[TargetFolder filesep 'Astrocyte-Labeled Raster']);
        end 
    end 
end


end
