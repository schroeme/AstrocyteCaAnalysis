function removeFalseAstros_MES(folderpath)

%% Initialiaze 

SourceFolder = [folderpath];
TargetFolder = [folderpath];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%find & load the processed analysis file in the folder
load([SourceFolder filesep 'processed_analysis_astro.mat']);

%uncomment the below if you had to register
%load([SourceFolder filesep 'processed_analysis_astro_reg.mat']);
%load(['J:\MeaneyLab\MSchroeder\DataOriginal\Injury_10-25-18\D03\registration\renumbering_map']);

close all
scrsz = get(groot,'ScreenSize');
SpikeFig=figure('Position',[1 scrsz(4)/3 scrsz(3)/1 scrsz(4)/3]);

%% Manually identify neurons that have only misidentified (false) peaks
for cindex=1:length(analysis) %loop through each condition
              
        falseastros=[];
        astros_nonactive=[];
        addastros = [];
        astrocyte_indices = analysis(cindex).neuroastro.astrocytes;
        try
            on_indices = analysis(cindex).neuroastro.other_neurons;
        catch
            on_indices = analysis(cindex).neuroastro.neurons;
        end
        
        if cindex==1
            for aindex=1:length(astrocyte_indices)
                subplot(2,1,1)
                rand_neuron_index = datasample(on_indices,1);
                %rand_neuron_index = find(r_map(:,cindex+1)==rand);
                plot(analysis(cindex).F_cell_scaled(rand_neuron_index,:));
                title(['Condition # ' num2str(cindex) 'Other Neuron # ' num2str(rand_neuron_index)])
                subplot(2,1,2)
                %astro_index = find(r_map(:,cindex+1)==astrocyte_indices(aindex));
                plot(analysis(cindex).F_cell_scaled(astrocyte_indices(aindex),:));
                title(['Condition # ' num2str(cindex) 'Astrocyte # ' num2str(astrocyte_indices(aindex))])
                hold on
                x=1;
                x = input('Active cell? ( Yes - 1; No - 0; False astro - 2; Neuron is astro - 3 ):');
                if(x==0)
                   astros_nonactive=[astros_nonactive astrocyte_indices(aindex)];
                elseif(x==3)
                   addastros = [addastros rand_neuron_index];
                elseif(x==2)
                   falseastros =[falseastros astrocyte_indices(aindex)];
                   on_indices = [on_indices astrocyte_indices(aindex)];
                end
                clear rand_neuron_index
                hold off
            end
            analysis(cindex).neuroastro.nonactiveastro = astros_nonactive;
            analysis(cindex).neuroastro.addedastro = addastros;
            analysis(cindex).neuroastro.falseastros = falseastros;
            astrocyte_indices=setdiff(astrocyte_indices,astros_nonactive);%delete nonactive astrocytes
            astrocyte_indices=setdiff(astrocyte_indices,falseastros); %remove false astrocytes from the indices list
            astrocyte_indices = [astrocyte_indices addastros];%add the new astrocytes to the indices list
            
            for k = 1:length(analysis)
                analysis(k).neuroastro.astrocytes = astrocyte_indices;%save new astro indices
                analysis(k).neuroastro.other_neurons = on_indices;
            end 
            
        elseif cindex == length(analysis) %when we reach the last condition
            for aindex=1:length(astrocyte_indices)
                subplot(2,1,1)
                
                %uncomment if you had to register
                %rand = datasample(on_indices,1);
                %rand_neuron_index = find(r_map(:,cindex+1)==rand);
                
                rand_neuron_index = datasample(on_indices,1);
                plot(analysis(cindex).F_cell_scaled(rand_neuron_index,:));
                title(['Condition # ' num2str(cindex) 'Other Neuron # ' num2str(rand_neuron_index)])
                subplot(2,1,2)
                
                %uncomment if you had to register
                %astro_index = find(r_map(:,cindex+1)==astrocyte_indices(aindex));
                %plot(analysis(cindex).F_cell_scaled(astro_index,:));
                
                plot(analysis(cindex).F_cell_scaled(astrocyte_indices(aindex),:));
                title(['Condition # ' num2str(cindex) 'Astrocyte # ' num2str(astrocyte_indices(aindex))])
                hold on
                x=1;
                x = input('True astrocyte? ( Yes - 1; No - 0):');
                if(x==0)
                   falseastros =[falseastros astrocyte_indices(aindex)];
                   on_indices = [on_indices astrocyte_indices(aindex)];
                end
                hold off
            end 
           
            astrocyte_indices=setdiff(astrocyte_indices,falseastros); %remove false astrocytes from the indices list

            for k = 1:length(analysis)
                analysis(k).neuroastro.astrocytes = astrocyte_indices;%save new astro indices
                analysis(k).neuroastro.other_neurons = on_indices;
            end 
            
        end 
end

    %Re-save updated analysis folder   
    %analysis(1).rmap = r_map;
    save([TargetFolder filesep 'processed_analysis_astrocheck.mat'],'analysis');
    
close all