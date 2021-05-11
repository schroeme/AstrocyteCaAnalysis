
initanalysisdata=analysis;
close all
scrsz = get(groot,'ScreenSize');
SpikeFig=figure('Position',[1 scrsz(4)/3 scrsz(3)/1 scrsz(4)/3]);

%% Manually identify neurons that have only misidentified (false) peaks
for cindex=1:length(analysis) %loop through each condition
              
        falseastros=[];
        addastros = [];
        astrocyte_indices = analysis(cindex).neuroastro.astrocytes;
        neuron_indices = [analysis(cindex).neuroastro.other_neurons; analysis(cindex).neuroastro.neighbor_neurons];
        
    if cindex ~= 3     
        false_neurons=[];
        false_astros=[];
        
        %loop through all neurons in condition
            for nindex=1:size(analysis(cindex).nspikedata.peak_locs,1)
                %close all
                %plot trace
                plot(analysis(cindex).nspikedata.F_cell(:,nindex)./analysis(cindex).nspikedata.BG);
                title(['Neuron # ' num2str(nindex)])
                hold on

                peakloc=analysis(cindex).nspikedata.peak_locs{nindex};
                
                if (~isempty(peakloc))
                    plot(peakloc,analysis(cindex).nspikedata.F_cell(peakloc,nindex)./analysis(cindex).nspikedata.BG(peakloc),'ro');
                    x=1;
                    x = input('True neuron? ( Yes - 1; No - 0 ):');
                    if(x==0)
                       false_neurons=[false_neurons nindex];
                    end
                else
                    disp(['No spikes detected for neuron ' num2str(nindex)])
                end   
                hold off
            end

            %loop through all astrocytes in that condition
            for aindex=1:size(analysis(cindex).aspikedata.peak_locs,1)
                plot(analysis(cindex).aspikedata.F_cell(:,aindex)./analysis(cindex).aspikedata.BG);
                title(['Astrocyte # ' num2str(aindex)])
                hold on

                %plot peak location and select neurons with mis-detected peaks
                peakloc=analysis(cindex).aspikedata.peak_locs{aindex};
                if (~isempty(peakloc))
                    plot(peakloc,analysis(cindex).aspikedata.F_cell(peakloc,aindex)./analysis(cindex).aspikedata.BG(peakloc),'ro');
                    x=1;
                    x = input('True astrocyte? ( Yes - 1; No - 0 ):');
                    if(x==0)
                       false_astros=[false_astros aindex];
                    end
                else
                    disp(['No events detected for astrocyte ' num2str(aindex)])
                end   
                hold off
            end
            
            %now fix analysis - subtract false and add new
            astrocyte_indices = setdiff(astrocyte_indices,false_astros);
            neuron_indices = setdiff(neuron_indices,false_neurons);
            
            astrocyte_indices = [astrocyte_indices; false_neurons'];
            neuron_indices = [neuron_indices; false_astros'];
            
            analysis(cindex).neuroastro.astrocytes = astrocyte_indices;
            analysis(cindex).neuroastro.neurons = neuron_indices;
    end 
end
