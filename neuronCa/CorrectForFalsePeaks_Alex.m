function CorrectForFalsePeaks_Alex(folderpath)

%% Initialiaze 

SourceFolder = [folderpath];
TargetFolder = [folderpath];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep 'processed_analysis_astrocheck_spikech.mat']);
load([SourceFolder filesep files.name]);
initanalysisdata=analysis;

close all
scrsz = get(groot,'ScreenSize');
SpikeFig=figure('Position',[1 scrsz(4)/3 scrsz(3)/1 scrsz(4)/3]);

%% Manually identify neurons that have only misidentified (false) peaks
for cindex=1:1%length(analysis)
%for cindex=2;
              
        neurons_nottruepeaks=[];

        for nindex=1:size(analysis(cindex).spikedata.peak_locs,1)
            %close all
            %plot trace
            plot(analysis(cindex).spikedata.F_cell(:,nindex)./analysis(cindex).spikedata.BG);
            title(['Neuron # ' num2str(nindex)])
            hold on

            %plot peak location and select neurons with mis-detected peaks
            peakloc=analysis(cindex).spikedata.peak_locs{nindex};
            if (~isempty(peakloc))
                plot(peakloc,analysis(cindex).spikedata.F_cell(peakloc,nindex)./analysis(cindex).spikedata.BG(peakloc),'ro');
                x=0;
                x = input('No true peaks? ( Yes - 1; No - 0 ):');
                if(x==1)
                   neurons_nottruepeaks=[neurons_nottruepeaks nindex];                
                end
            else
                disp(['No spikes detected for neuron ' num2str(nindex)])
            end   
            hold off
        end
    
    %Save selected spike data
    analysis(cindex).neuronsnotruepeaks=neurons_nottruepeaks;      
    save([TargetFolder filesep files.name(1:end-4) '_spikech.mat'],'analysis');
end


%% Remove those false peaks from analysis data structure
analysis_peakcheck=analysis;

for cindex=1:length(analysis)  
        neurons_nottruepeaks=analysis_peakcheck(cindex).neuronsnotruepeaks;
        analysis_peakcheck(cindex).spikedata.rstr(:,neurons_nottruepeaks)=0;
        for j=1:length(neurons_nottruepeaks)
            nindex=neurons_nottruepeaks(j);
            analysis_peakcheck(cindex).spikedata.amplitudes{nindex}=[];
            analysis_peakcheck(cindex).spikedata.Spikes_cell{nindex}=[];
            analysis_peakcheck(cindex).spikedata.baseline_locs{nindex}=[];
            analysis_peakcheck(cindex).spikedata.peak_locs{nindex}=[];  
        end
end


% Save new analysis file with filtered data
analysis=analysis_peakcheck;
save([TargetFolder filesep files.name(1:end-4) '_spikech.mat'],'analysis');

close all