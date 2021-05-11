function CorrectForFalsePeaks_Alex_MES_astros(folderpath)

%% Initialiaze 

SourceFolder = [folderpath];
TargetFolder = [folderpath];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%uncomment this if you had to register
%load([folderpath filesep 'registration\renumbering_map']);

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep 'processed_analysis_astrocheck.mat']);
load([SourceFolder filesep files.name]);
initanalysisdata=analysis;

close all
scrsz = get(groot,'ScreenSize');
SpikeFig=figure('Position',[1 scrsz(4)/3 scrsz(3)/1 scrsz(4)/3]);

%% Manually identify neurons that have only misidentified (false) peaks
for cindex=1:1%length(initanalysisdata)-1
%         %uncomment this if you had to register
%        astrocyte_indices = analysis(cindex).neuroastro.astrocytes;
%         astrocytes = NaN(1,length(astrocyte_indices));
%         for aindex = 1:length(astrocyte_indices)
%             try
%                 [astrocytes(aindex),~] = find(r_map(:,cindex+1)==astrocyte_indices(aindex));
%             catch
%                 continue
%             end 
%         end
%         astrocytes = astrocytes(~isnan(astrocytes));

%         %uncomment this if you had to register
%         neuron_indices = [analysis(cindex).neuroastro.neighbor_neurons; analysis(cindex).neuroastro.other_neurons'];
%         neurons = NaN(1,length(neuron_indices));
%         for nindex = 1:length(neuron_indices)
%             try
%                 [neurons(nindex),~] = find(r_map(:,cindex+1)==neuron_indices(nindex));
%             catch
%                 continue
%             end
%         end
%         neurons = neurons(~isnan(neurons));
%     try
%         neurons = initanalysisdata(cindex).neuroastro.neurons;
%     catch
%         neurons = [initanalysisdata(cindex).neuroastro.neighbor_neurons; analysis(cindex).neuroastro.other_neurons'];
%     end
    if cindex ~= 3     
        neurons_nottruepeaks=[];
        astros_nottruepeaks=[];
        
        %loop through all neurons in condition
        %uncomment if you had to register
            %for nindex=1:length(neurons)
            for nindex=1:size(analysis(cindex).nspikedata.peak_locs,1)
                %close all
                %plot trace
                
                plot(analysis(cindex).nspikedata.F_cell(:,nindex)./analysis(cindex).nspikedata.BG);
                
                %uncomment if you had to register
                %plot(analysis(cindex).F_cell(:,neurons(nindex))./analysis(cindex).nspikedata.BG);
%                 
                title(['Neuron # ' num2str(nindex)])
                hold on

                %plot peak location and select neurons with mis-detected peaks
                %uncomment if you had to register
                %peakloc=analysis(cindex).nspikedata.peak_locs{neurons(nindex)};
                
              peakloc=analysis(cindex).nspikedata.peak_locs{nindex};
                
                if (~isempty(peakloc))
                    %uncomment if you had to register
                    %plot(peakloc,analysis(cindex).F_cell(peakloc,neurons(nindex))./analysis(cindex).nspikedata.BG(peakloc),'ro');
                    
                    plot(peakloc,analysis(cindex).nspikedata.F_cell(peakloc,nindex)./analysis(cindex).nspikedata.BG(peakloc),'ro');
                    x=0;
                    x = input('No true peaks? ( Yes - 1; No - 0 ):');
                    if(x==1)
                       neurons_nottruepeaks=[neurons_nottruepeaks nindex];
                    
                    %uncomment if registered
                    %neurons_nottruepeaks=[neurons_nottruepeaks neurons(nindex)];
                    end
                else
                    disp(['No spikes detected for neuron ' num2str(nindex)])
                end   
                hold off
            end

            %loop through all astrocytes in that condition
            
            %uncomment if registered
            %for aindex=1:size(astrocytes)
            for aindex=1:size(analysis(cindex).aspikedata.peak_locs,1)
                %close all
                %plot trace
                
                %uncomment if you had to register
                %plot(analysis(cindex).F_cell(:,astrocytes(aindex))./analysis(cindex).aspikedata.BG);
                
                plot(analysis(cindex).aspikedata.F_cell(:,aindex)./analysis(cindex).aspikedata.BG);
                title(['Astrocyte # ' num2str(aindex)])
                hold on

                %plot peak location and select neurons with mis-detected peaks
                peakloc=analysis(cindex).aspikedata.peak_locs{aindex};
                
                %uncomment if you had to register
                %peakloc=analysis(cindex).aspikedata.peak_locs{astrocytes(aindex)};
                
                if (~isempty(peakloc))
                    
                    plot(peakloc,analysis(cindex).aspikedata.F_cell(peakloc,aindex)./analysis(cindex).aspikedata.BG(peakloc),'ro');
                    
                    %uncomment if you had to register
                    %plot(peakloc,analysis(cindex).aspikedata.F_cell(peakloc,astrocytes(aindex))./analysis(cindex).aspikedata.BG(peakloc),'ro');
                    
                    x=0;
                    x = input('No true peaks? ( Yes - 1; No - 0 ):');
                    if(x==1)
                       astros_nottruepeaks=[astros_nottruepeaks aindex];
                    
                        %uncomment if registered
                        %astros_nottruepeaks=[astros_nottruepeaks astrocytes(aindex)];
                    end
                else
                    disp(['No events detected for astrocyte ' num2str(aindex)])
                end   
                hold off
            end

            %Save selected spike data
            analysis(cindex).neuronsnotruepeaks=neurons_nottruepeaks;
            analysis(cindex).astrosnottruepeaks=astros_nottruepeaks;
            
            save([TargetFolder filesep files.name(1:end-4) '_spikech.mat'],'analysis');
            save([TargetFolder filesep files.name(1:end-4)],'analysis');
    end 
end


%% Remove those false peaks from analysis data structure
analysis_peakcheck=analysis;

for cindex=1:length(analysis)  
    if cindex ~= 3
        neurons_nottruepeaks=analysis_peakcheck(cindex).neuronsnotruepeaks;
        astros_nottruepeaks=analysis_peakcheck(cindex).astrosnottruepeaks;
        analysis_peakcheck(cindex).nspikedata.rstr(:,neurons_nottruepeaks)=0;
        analysis_peakcheck(cindex).aspikedata.rstr(:,astros_nottruepeaks)=0;
        for j=1:length(neurons_nottruepeaks)
            nindex=neurons_nottruepeaks(j);
            analysis_peakcheck(cindex).nspikedata.amplitudes{nindex}=[];
            analysis_peakcheck(cindex).nspikedata.Spikes_cell{nindex}=[];
            analysis_peakcheck(cindex).nspikedata.baseline_locs{nindex}=[];
            analysis_peakcheck(cindex).nspikedata.peak_locs{nindex}=[];  
        end
        for k=1:length(astros_nottruepeaks)
            aindex=astros_nottruepeaks(k);
            analysis_peakcheck(cindex).aspikedata.amplitudes{aindex}=[];
            analysis_peakcheck(cindex).aspikedata.Spikes_cell{aindex}=[];
            analysis_peakcheck(cindex).aspikedata.baseline_locs{aindex}=[];
            analysis_peakcheck(cindex).aspikedata.peak_locs{aindex}=[];  
        end
    end
end


% Save new analysis file with filtered data
analysis=analysis_peakcheck;
save([TargetFolder filesep files.name(1:end-4) '_spikech'],'analysis');

%save([SourceFolder filesep 'networkdata' filesep 'processed_analysis_astrocheck_spikech_actfilt.mat'],'analysis');

close all