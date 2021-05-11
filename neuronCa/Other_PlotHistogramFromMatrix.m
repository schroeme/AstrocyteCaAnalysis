function Other_PlotHistogramFromMatrix(folderpath)
close all

%% Initialiaze 

SourceFolder = [folderpath filesep 'activitydata'];
TargetFolder = [folderpath filesep 'activitydata'];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep 'processed_analysis*.mat']);
load([SourceFolder filesep files.name]);
analysisfile=analysis;

%conditions={'Pre', '0 hrs', '6 hrs', '15 hrs'};
conditions={'DIV 10', 'DIV 14'};
xlimits=[0 0.6];

close all


%% Plot histogram of even frequency for each condition

Hall=figure(100);
set(Hall,'PaperPositionMode','auto'); 
set(Hall,'PaperOrientation','portrait');
set(Hall,'Position',[50 50 1200 800]);

for cindex=1:numel(analysisfile)   %go through all conditions for a dish
    
    clear datastruct
    activitydata=cellfun(@length,analysis(cindex).spikedata.peak_locs)/analysis(cindex).frames*20;
    
    H=figure();
    set(H,'PaperPositionMode','auto'); 
    set(H,'PaperOrientation','portrait');
    set(H,'Position',[50 50 1200 800]);
    hist(activitydata);
    %xlim(xlimits);  
    xlabel('Frequency (Hz)');
    ylabel('Number of neurons');
    set (gca,'FontSize',20);   
    box on
    title(conditions{cindex});
    suptitle(analysisfile(1).filename); 
    
    figure(Hall)     
    subplot(2,2,cindex)
    hist(activitydata);
    hold on 
    xlim(xlimits);  
    xlabel('Frequency (Hz)');
    ylabel('Number of neurons');
    set (gca,'FontSize',20); 
    box on
    title(conditions{cindex});
    
    print(H,'-dtiff',[TargetFolder filesep regexprep(analysisfile(1).filename(1:end-4),'\W','') '_Hist_Condition' num2str(cindex) '.tif']);
    savefig(H,[TargetFolder filesep regexprep(analysisfile(1).filename(1:end-4),'\W','') '_Hist_Condition' num2str(cindex)]);
    
      
end  
    
    figure(Hall)
    suptitle(analysisfile(1).filename); 

    print(Hall,'-dtiff',[TargetFolder filesep regexprep(analysisfile(1).filename(1:end-4),'\W','') '_Hist_AllConditions.tif']);
    savefig(Hall,[TargetFolder filesep regexprep(analysisfile(1).filename(1:end-4),'\W','') '_Hist_AllConditions']);
   
    


end
