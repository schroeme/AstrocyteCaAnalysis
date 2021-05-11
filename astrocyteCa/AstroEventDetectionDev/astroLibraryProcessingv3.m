%CONTINUED FROM V2, NOT A DIFFERENT VERSION. THIS USES MSE3, the version of
%MSE where traces smaller than 5 events are excluded, and MSE for those
%traces is assigned NaN.

%% Load up all previously generated traces and values
load('astroMSE3.mat')
load('astrotrace_scalingfactors.mat')
a = scalingfactors{1};
b = scalingfactors{2};

load('raw_astrotrace_snippets.mat') %load raw snippets
load('full_astrotracelib.mat') %load full scaled library
load('shortened_astrotrace_lib.mat') %load shortened astrotrace lib with traces only longer than 5 frames

%% Plot a few surface plots of MSE3

%generate random traces to plot
raw_r = randi([1 size(MSE3,3)],1,20);
lib_r = randi([1 size(MSE3,2)],1,20);
for i = 1:20
    figure(i)
    %lib_r = randi([1 size(MSE,2)])
    MSE3_toplot = reshape(MSE3(:,lib_r(i),raw_r(i)),[18,100]);
    surf(b,a,MSE3_toplot)
    xlabel('Vertical scaling factor')
    ylabel('Horizontal scaling factor')
    %title(['MSE for raw trace ' num2str(raw_r(i)) ' , library trace ' num2str(lib_r)])
    clear MSE3_toplot
end 

%the above look reasonable.

%% Find local/global minimum MSE library traces
minMSE_eachtrace = zeros(length(rawsnippets_col),length(full_astrotrace_lib));
min_abind = zeros(length(rawsnippets_col),length(full_astrotrace_lib));
minMSE_alltrace = zeros(length(rawsnippets_col),1);
min_traceind = zeros(length(rawsnippets_col),1);

for rawi = 1:length(rawsnippets_col)%loop through each raw trace
    [minMSE_eachtrace(rawi,:),min_abind(rawi,:)] = min(MSE3(:,:,rawi));
    [minMSE_alltrace(rawi,1),min_traceind(rawi,1)] = min(minMSE_eachtrace(rawi,:));
end 

[unique_traceinds,ia,ic] = unique(min_traceind);

freq = histc(min_traceind,unique_traceinds);
bar(unique_traceinds,freq,'BarWidth',1)
xlabel('Library Trace Number')
ylabel('Frequency')
title('(A)')
axis([0 length(full_astrotrace_lib) 0 max(freq)+5])

repeat_traceinds = unique_traceinds(freq > 1);%take only those that were repeated more than once

%% Re-run MSE on the best lib traces

MSE_best = zeros(numel(shortened_astrotrace_lib{1}),length(repeat_traceinds),length(rawsnippets_col));

for traceind = 1:length(repeat_traceinds)%loop through each "best" lib trace
    for abind = 1:numel(shortened_astrotrace_lib{repeat_traceinds(traceind)})%loop through each of the a*b options for that trace
        for rawind = 1:length(rawsnippets_col)%loop through each raw trace
            %Get the right length of the raw snippet to compare with
            if isempty(shortened_astrotrace_lib{repeat_traceinds(traceind)}{abind})
                MSE_best(abind,traceind,rawind) = NaN;
            else 
                N = length(shortened_astrotrace_lib{repeat_traceinds(traceind)}{abind}); %number of elements to get from the raw trace
                midcol = ceil(length(rawsnippets_col{rawind})/2); %find middle of raw snippet (theoretically where the event is)
    %             if length(full_astrotrace_lib{traceind}{abind}) == length(rawsnippets_col{rawind})
    %                 raw_resized = rawsnippets_col{rawind};
                if mod(N,2) == 1 %if the length of the lib snippet is odd
                    raw_resized = rawsnippets_col{rawind}((midcol - floor(N/2)):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
                else %the length of the lib snippet is even
                    raw_resized = rawsnippets_col{rawind}((midcol - floor(N/2) + 1):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
                end
                MSE_best(abind,traceind,rawind) = immse(raw_resized,shortened_astrotrace_lib{repeat_traceinds(traceind)}{abind});
            end 
            clear N raw_resized midcol
        end 
    end
end 

%% Plot a few surface plots

%generate random traces to plot
raw_r = randi([1 size(MSE_best,3)],1,10);
lib_r = randi([1 size(MSE_best,2)],1,10);
for i = 1:10
    figure(i)
    %lib_r = randi([1 size(MSE,2)])
    MSE_best_toplot = reshape(MSE_best(:,lib_r(i),raw_r(i)),[18,100]);
    surf(b,a,MSE_best_toplot)
    xlabel('Vertical scaling factor')
    ylabel('Horizontal scaling factor')
    %title(['MSE for raw trace ' num2str(raw_r(i)) ' , library trace ' num2str(lib_r)])
    clear MSE_best_toplot
end 

%% Now find the "best of the best" library traces USING METHOD 1
%Method 1 is a frequency-based method:
%Set minimum frequency for each library trace 
%Using new minimum MSE based on all scaled variations of that lib trace
%Min frequency threshold = 5% of all raw traces (can change this)
%Number of variations in a & b included for that trace = its frequency as best trace

minbestMSE_eachtrace = zeros(length(rawsnippets_col),length(repeat_traceinds));
minbest_abind = zeros(length(rawsnippets_col),length(repeat_traceinds));
minbestMSE_alltrace = zeros(length(rawsnippets_col),1);
minbest_traceind = zeros(length(rawsnippets_col),1);

for rawi = 1:length(rawsnippets_col)%loop through each raw trace
    [minbestMSE_eachtrace(rawi,:),minbest_abind(rawi,:)] = min(MSE_best(:,:,rawi));
    [minbestMSE_alltrace(rawi,1),minbest_traceind(rawi,1)] = min(minbestMSE_eachtrace(rawi,:));
end 

[unique_best_traceinds,ia2,ic2] = unique(minbest_traceind);

freq2 = histc(minbest_traceind,unique_best_traceinds);
bar(repeat_traceinds(unique_best_traceinds),freq2)
xlabel('Library Trace Number')
ylabel('Frequency')
title('Method 1: Histogram of "Best" Astro Library Traces')
axis([0 length(full_astrotrace_lib) 0 max(freq2)+5])

%normplot(freq2) %data is not normal, has a negative skew, which means heavy left tail, so let's use lower bound

freq_cutoff = 1; %ceil(mean(freq2) - 1.96 * (std(freq2))/sqrt(length(freq2)));%freq cutoff is lower bound of the 95% CI on the mean
%for now, no frequency cutoff (per Alex suggestion, keep everything so we
%can find those rare traces)
high_freq_traceinds = unique_best_traceinds(freq2 > freq_cutoff); %be more stringent this time
repeat_best_traceinds = repeat_traceinds(high_freq_traceinds);

%% Now find the best values for a and b for each trace

%Question we are answering: for each lib trace, what a and b combo(s)
%produced the lowest MSE?

%sort the MSE in ascending order
[sorted_best_MSE,sorting_ind] = sort(minbestMSE_eachtrace,'ascend');

%correspond the number of variations (in a and b) that trace gets with
% the number of times it appeared as the minimum
for i = 1:length(repeat_best_traceinds)
    best_abind{1,i} = repeat_traceinds(high_freq_traceinds(i));
    best_abind{2,i} = minbest_abind(sorting_ind(1:freq2(high_freq_traceinds(i)),high_freq_traceinds(i)));
end 

%find out how many traces we have
numel = 0;
for i = 1:length(best_abind)
    numel = numel + size(best_abind{2,i},1);
end

%% Now do Method 2 to find "best of best" lib traces

%Take X global minimum MSE values, and find the corresponding traces & scaling variations
% Now figure out "who" those min 130 belong to. To sort globally we need to
% flatten the MSE from the top 40 traces

x = 280; %change this to change the number of "top" traces we are taking
minbestMSE_flattened = reshape(minbestMSE_eachtrace,[size(minbestMSE_eachtrace,2)*280,1]);
minbest_abind_flattened = reshape(minbest_abind,[size(minbestMSE_eachtrace,2)*280,1]);
[sorted_minbestMSE_flattened,flattened_sorting_ind] = sort(minbestMSE_flattened,'ascend');

min_global_MSE = flattened_sorting_ind(1:x); %get the minimum 130 MSE traces (there will be some repeats)
min_global_ab = minbest_abind_flattened(min_global_MSE);%find the corresponding 

[raw,lib] = ind2sub([280,size(minbestMSE_eachtrace,2)],min_global_MSE); %get the row and column (aka raw and library trace) indeces from the vectorized form
length(unique(raw)); %only 46 of the 280 raw trace represented
length(unique(lib)); %21 / 40 of the lib traces are represented
best_lib_traces_method2 = repeat_traceinds(lib); %what are the best library traces via this method
[unique_traces_method2,unique_inds2,ic3] = unique(lib); %get the unique library traces from this method
[row,col] = ind2sub([1,280*size(minbestMSE_eachtrace,2)],unique_traces_method2); %re-stretch it out
unique_stretched = min_global_MSE(col);

%Let's visually compare which traces "won" btwn method 1 and method 2
freq3 = histc(best_lib_traces_method2,repeat_traceinds(unique(lib)));

%make a big matrix for comparison purposes and to help me think about what's going on: 
%first column is the index of the trace in the flattened matrix.
%second column is the ab index corresponding to that
%third column is the library trace index (in the top 40)
%fourth column is the library trace index (in the overall 217)
compare(:,1) = min_global_MSE;
compare(:,2) = min_global_ab;
compare(:,3) = lib;
compare(:,4) = repeat_traceinds(lib);

%From visualizing, there are indeed different "best" ab indexes for each
%unique library trace. I want to get these

for i = 1:length(unique_traces_method2); %loop through each row of the compare matrix (each of the min 130)
    best_abind2{1,i} = repeat_traceinds(unique_traces_method2(i));
    rownumbers = find(compare(:,4) == best_abind2{1,i});
    best_abind2{2,i} = compare(rownumbers,2);
    clear rownumbers
end 

numel2 = 0;
for i = 1:length(best_abind2)
    numel2 = numel2 + size(best_abind2{2,i},1);
end

%% Create comparative barplot btwn method 1 and method 2

%bar(repeat_traceinds(unique(lib)),freq3,'FaceColor','red','BarWidth',1)%,'width','1')


bar(repeat_traceinds(unique_best_traceinds),freq2,'FaceColor','blue','BarWidth',1)%,'width','1')
%bar(freq2,'FaceColor','blue','BarWidth',1)%,'width','1')
hold on 
bar(repeat_traceinds(unique_traces_method2),freq3,'FaceColor','red','BarWidth',1)%,'width','1')
%bar(freq3,'FaceColor','red','BarWidth',1)%,'width','1')
legend('method1: based on frequency','method2:global minimum MSE')
axis([0 225 0 max(freq2)+5])
xlabel('Astrocyte Library Trace')
ylabel('Frequency as "Best"')

%% Collect the actual traces for method 1
astrospikes = {};

for tindex = 1:length(best_abind) %loop through each trace
    for varindex = 1:length(best_abind{2,tindex})%loop through each variation of that trace
        astrospikes{tindex,varindex} = full_astrotrace_lib{best_abind{1,tindex}}{best_abind{2,tindex}(varindex)};
    end 
end 

astrospikes = astrospikes(~cellfun('isempty',astrospikes));
astrospikes = reshape(astrospikes,1,length(astrospikes));

save('astrospikes1','astrospikes')

%% Collection for method 2
astrospikes2 = {};

for tindex2 = 1:length(best_abind2) %loop through each trace
    for varindex2 = 1:length(best_abind2{2,tindex2})%loop through each variation of that trace
        astrospikes2{tindex2,varindex2} = full_astrotrace_lib{best_abind2{1,tindex2}}{best_abind2{2,tindex2}(varindex2)};
    end 
end 

astrospikes2 = astrospikes2(~cellfun('isempty',astrospikes2));
astrospikes2 = reshape(astrospikes2,1,length(astrospikes2));

save('astrospikes2','astrospikes2')

%% Make plots of lib traces overlaid with raw traces

%% Gather traces for overlay plots

%find the corresponding raw trace that matches the lib trace
for i = 1:length(repeat_traceinds)%loop through each library trace we kept
    %make the corresponding raw trace index the third column
    [temp(rawi,1),rawind_for_overlap(i,3)] = min(minbestMSE_eachtrace(:,i));
    %first column will be lib trace index
    rawind_for_overlap(i,1) = repeat_traceinds(i);
    %second column will be corresponding variation (abind) of that trace
    rawind_for_overlap(i,2) = minbest_abind(rawind_for_overlap(i,3),i);
end 

%Now make the actual plots
for i = 10:30
    N = length(shortened_astrotrace_lib{rawind_for_overlap(i,1)}{rawind_for_overlap(i,2)}); %number of elements to get from the raw trace
    midcol = ceil(length(rawsnippets_col{rawind_for_overlap(i,3)})/2); %find middle of raw snippet (theoretically where the event is)     
    if mod(N,2) == 1 %if the length of the lib snippet is odd
        raw_resized = rawsnippets_col{rawind_for_overlap(i,3)}((midcol - floor(N/2)):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
    else %the length of the lib snippet is even
        raw_resized = rawsnippets_col{rawind_for_overlap(i,3)}((midcol - floor(N/2) + 1):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
    end
    figure(i)
    plot([(1:N)./20],shortened_astrotrace_lib{rawind_for_overlap(i,1)}{rawind_for_overlap(i,2)})
    hold on
    plot([(1:N)./20],raw_resized)
    xlabel('Time (s)')
    ylabel('F/F_0')
    legend('Library','Raw')
    clear raw_resized N midcol
end 

%Overlay plots look good/make sense, except really beginning to think we
%should exclude lib traces <5 points long. Going to remove those now