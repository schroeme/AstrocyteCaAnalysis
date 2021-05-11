function CorrectForFalsePeaks_Alex_MES_inj(folderpath)

%% Initialiaze 

SourceFolder = [folderpath];
TargetFolder = [folderpath];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep 'processed_analysis_inj.mat']);
load([SourceFolder filesep files.name]);
initanalysisdata=analysis;

close all
scrsz = get(groot,'ScreenSize');
SpikeFig=figure('Position',[1 scrsz(4)/3 scrsz(3)/1 scrsz(4)/3]);

%% Manually identify neurons that have only misidentified (false) peaks
              
        neurons_nottruepeaks=[];
        astros_nottruepeaks=[];
        
        %loop through all neurons in condition
            for nindex=1:size(analysis.nspikedata.peak_locs,1)
                %close all
                %plot trace
                plot(analysis.nspikedata.F_cell(:,nindex)./analysis.nspikedata.BG);
                title(['Neuron # ' num2str(nindex)])
                hold on

                %plot peak location and select neurons with mis-detected peaks
                peakloc=analysis.nspikedata.peak_locs{nindex};
                if (~isempty(peakloc))
                    plot(peakloc,analysis.nspikedata.F_cell(peakloc,nindex)./analysis.nspikedata.BG(peakloc),'ro');
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

            %loop through all astrocytes in that condition
            for aindex=1:size(analysis.aspikedata.peak_locs,1)
                %close all
                %plot trace
                plot(analysis.aspikedata.F_cell(:,aindex)./analysis.aspikedata.BG);
                title(['Astrocyte # ' num2str(aindex)])
                hold on

                %plot peak location and select neurons with mis-detected peaks
                peakloc=analysis.aspikedata.peak_locs{aindex};
                if (~isempty(peakloc))
                    plot(peakloc,analysis.aspikedata.F_cell(peakloc,aindex)./analysis.aspikedata.BG(peakloc),'ro');
                    x=0;
                    x = input('No true peaks? ( Yes - 1; No - 0 ):');
                    if(x==1)
                       astros_nottruepeaks=[astros_nottruepeaks aindex];                
                    end
                else
                    disp(['No events detected for astrocyte ' num2str(aindex)])
                end   
                hold off
            end

            %Save selected spike data
            analysis.neuronsnotruepeaks=neurons_nottruepeaks;
            analysis.astrosnottruepeaks=astros_nottruepeaks;
            save([TargetFolder filesep files.name(1:end-4) '_spikech.mat'],'analysis');


%% Remove those false peaks from analysis data structure
analysis_peakcheck=analysis;

        neurons_nottruepeaks=analysis_peakcheck.neuronsnotruepeaks;
        astros_nottruepeaks=analysis_peakcheck.astrosnottruepeaks;
        analysis_peakcheck.nspikedata.rstr(:,neurons_nottruepeaks)=0;
        analysis_peakcheck.aspikedata.rstr(:,astros_nottruepeaks)=0;
        for j=1:length(neurons_nottruepeaks)
            nindex=neurons_nottruepeaks(j);
            analysis_peakcheck.nspikedata.amplitudes{nindex}=[];
            analysis_peakcheck.nspikedata.Spikes_cell{nindex}=[];
            analysis_peakcheck.nspikedata.baseline_locs{nindex}=[];
            analysis_peakcheck.nspikedata.peak_locs{nindex}=[];  
        end
        for k=1:length(astros_nottruepeaks)
            aindex=astros_nottruepeaks(k);
            analysis_peakcheck.aspikedata.amplitudes{aindex}=[];
            analysis_peakcheck.aspikedata.Spikes_cell{aindex}=[];
            analysis_peakcheck.aspikedata.baseline_locs{aindex}=[];
            analysis_peakcheck.aspikedata.peak_locs{aindex}=[];  
        end


% Save new analysis file with filtered data
analysis=analysis_peakcheck;
save([TargetFolder filesep files.name(1:end-4) '_spikech.mat'],'analysis');

close all
end