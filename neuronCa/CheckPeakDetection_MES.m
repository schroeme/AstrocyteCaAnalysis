function CheckPeakDetection_MES(folderpath)

%% Initialiaze 

SourceFolder = folderpath;
TargetFolder = [folderpath filesep 'checkSpikes'];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep 'processed_analysis*.mat']);
load([SourceFolder filesep files.name]);
analysisfile=analysis;

%%
close all
fov = length(analysis)
for i = 1:fov %3 fields of view for each dish
    Hfig = figure(i) %create a new figure for each field of view
    [T,N] = size(analysis(i).spikedata.F_cell) %find the number of neurons and frames for that FOV
    neurons = randsample(1:N,10);%choose 10 random neurons out of the N neurons in each fov
        for j = 1:10 %for each of those 10 neurons
            subplot(10,1,j) %plot in that location of the subplot of 5 rows and 2 columns
            plot(analysis(i).spikedata.F_cell(:,neurons(j))) %plot the F_cell for that neuron over all frames
            hold on
            x = analysis(i).spikedata.peak_locs{neurons(j)}; %store the peak locations of that randomly selected neuron as x
            y = analysis(i).spikedata.F_cell((analysis(i).spikedata.peak_locs{neurons(j)}),neurons(j)); %store the F_cell at that peak location as y
            plot(x,y,'o') %Plot dots over at the peaks
            title(['Neuron' num2str(neurons(j))])
            ylabel('F_cell_delta')
            clear x y
        end 
    %suptitle(['Field of view' num2str(fov)])
    xlabel('Frame number')
    
    %print(Hfig,'-dtiff',[TargetFolder filesep regexprep(analysis(i).filename(1:end-4),'\W','') '_spikeCheck.tif']);
    %savefig(Hfig,[TargetFolder filesep regexprep(analysis(i).filename(1:end-4),'\W','') '_spikeCheck']);
end 

end 