function CreateAstroLib()
%% Initialiaze 

SourceFolder = 'E:\MargaretFall2018\MargaretSpring2018Data\AstrocyteTraces';

%find & load the processed analysis file in the folder
files = dir([SourceFolder filesep '*astrotrace.mat']);
for i=1:length(files)%loop through each dish
    load([SourceFolder filesep files(i).name]); %load the astrocyte trace file
    nsegments(i) = length(trace);
end

close all
scrsz = get(groot,'ScreenSize');
SpikeFig=figure('Position',[1 scrsz(4)/3 scrsz(3)/1 scrsz(4)/3]);

%% Create a library of traces based on user choice

astrotrace_lib = {};

for dindex = 1:length(trace) %loop through each dish
    for cindex = 1:size(trace(dindex).trace,2) %loop through each condition in the dish
        for aindex =1:size(trace(dindex).trace,1)%loop through each astro in that dish
            %plot trace for that astro
            plot(trace(dindex).trace{aindex,cindex})
            title(['Astrocyte # ' num2str(dindex*cindex*aindex)])
            hold on
            x=0;
            x = input('Keep trace? ( Yes - 1; No - 0:');
            if(x==1)
                astrotrace_lib{end+1} = trace(dindex).trace{aindex,cindex};
            end 
            hold off
        end 
    end
end
    no_traces_examined = aindex*cindex*dindex
    no_traces_chosen = size(astrotrace_lib,2)
    save([SourceFolder filesep 'astrotrace_lib'],'astrotrace_lib');

close all

