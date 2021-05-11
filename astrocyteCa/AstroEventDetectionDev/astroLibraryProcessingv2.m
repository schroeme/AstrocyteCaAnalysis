function astroLibraryProcessingv2()

%astrotrace_lib -- structure containing example traces      
load([pwd filesep 'procssed_astrotracelib.mat']);
    
%% Smooth the library signals

for i=1:length(astrotrace_lib)
    smoothtrace{i,1}=smooth(smooth(smooth(smooth(astrotrace_lib{i}))));
end 

%plot smoothed traces to view them
%plot(smoothtrace{i})

% %% Estimage Background Noise
% 
% for i=1:length(astrotrace_lib)
%     Fo(i,1)=min(astrotrace_lib{i});
% end
% 
% BG_mod=fit([1:size(astrotrace_lib,2)]',Fo,'linearinterp');
% coefs=mean(BG_mod.p.coefs);
% 
% BG_linfit=(1:size(Fo)).*coefs(1)+coefs(2);
% 
% BG=BG_linfit';
% 
% [b,a]=butter(15,1/10,'high');
% BG_noise=5*std(filtfilt(b,a,mean(Fo,2)))/mean(BG);
% 
% %% Calculate SNR of raw traces
% 
% for xx=1:size(astrotrace_lib,2)
%     x=astrotrace_lib{:,xx}./BG(xx);
%     % Estimate SNR of signal
%     snr_win=[5:25:200 500 1000 2000];
%     x_std_cell=cell(length(snr_win),1);
%     for yy_tmp=1:length(snr_win)
%         x_std_cell{yy_tmp}=zeros(size(x,1)-snr_win(yy_tmp),1);
%         for xx_tmp=1:size(x_std_cell{yy_tmp},1); 
%             x_std_cell{yy_tmp}(xx_tmp)=std(x(xx_tmp:(xx_tmp+snr_win(yy_tmp)))); 
%         end
%         SNR_tmp(yy_tmp)=prctile(x_std_cell{yy_tmp},99)./prctile(x_std_cell{yy_tmp},1);
%     end
%     SNR=std(~isnan(SNR_tmp));
% end 

%% First do event detection!

timewindow = 20;%in frames per second
timebin = 1200; %in frames, length of the time bin over which to compare peaks
grouped_locs = [];
grouped_pks = [];
min_pk_distance = timebin/3;%max 3 events per time window

for i=1:length(astrotrace_lib)%loop through all traces
    binned_time = 1:timebin:length(astrotrace_lib{i})+1;
    for j = 1:length(binned_time)-1%loop through each time bin
        %find the local peaks in that timebin
        overall_max_pk_height(i) = max(smoothtrace{i});
        if j == length(binned_time)-1
            max_pk_height(j) = max(smoothtrace{i}(binned_time(j):end));
            if max_pk_height(j) >= overall_max_pk_height - .2; %if the max pk height is relatively high
                [temp_pks{j},temp_locs{j}]=findpeaks(smoothtrace{i}(binned_time(j):end),'MinPeakHeight',.95*max_pk_height(j),'MinPeakDistance',min_pk_distance);
            else
                temp_locs{j} = [];
                temp_pks{j} = [];
            end 
        else 
            max_pk_height(j) = max(smoothtrace{i}(binned_time(j):binned_time(j+1)));
            if max_pk_height(j) >= overall_max_pk_height - .2; %if the max pk height is relatively high
                [temp_pks{j},temp_locs{j}]=findpeaks(smoothtrace{i}(binned_time(j):binned_time(j+1)),'MinPeakHeight',.97*max_pk_height(j),'MinPeakDistance',min_pk_distance);
            else
                temp_locs{j} = [];
                temp_pks{j} = [];
            end 
        end 
        grouped_locs = [grouped_locs (temp_locs{j} + binned_time(j)-1)'];
        grouped_pks = [grouped_pks temp_pks{j}'];
    end 
    clear max_pk_height overall_max_pk_height
    all_grouped_locs{i,1} = grouped_locs;
    all_grouped_pks{i,1} = grouped_pks;
    clear binned_time temp_locs temp_pks grouped_locs grouped_pks
    grouped_locs = [];
    grouped_pks = [];
end

%% Go through and decide which traces I want to keep

scrsz = get(groot,'ScreenSize');
SpikeFig=figure('Position',[1 scrsz(4)/3 scrsz(3)/1 scrsz(4)/3]);
bad_traces=[];
for i = 1:length(all_grouped_pks)
    plot(smoothtrace{i})
    hold on
    plot(all_grouped_locs{i,:},all_grouped_pks{i,:},'ro')
    hold on
    x=0;
    x = input('Keep? ( Yes - 1; No - 0 :');
    if(x==0)
       bad_traces=[bad_traces i];                
    end 
    hold off 
end

for i = 1:length(bad_traces)
    smoothtrace{bad_traces(i)}=[];
    all_grouped_pks{bad_traces(i)}=[];
    all_grouped_locs{bad_traces(i)}=[];
end 
good_smoothtrace = smoothtrace(~cellfun('isempty',smoothtrace));
all_grouped_pks2 = all_grouped_pks(~cellfun('isempty',all_grouped_pks));
all_grouped_locs2 = all_grouped_locs(~cellfun('isempty',all_grouped_locs));

%% Get snippets of these good traces

for i=1:length(good_smoothtrace)
    for j=1:length(all_grouped_pks2{i})
        if all_grouped_locs2{i}(j) + timewindow > length(good_smoothtrace{i})
            snippet_indices{i,j} = [all_grouped_locs2{i}-timewindow length(good_smoothtrace{i})];
        elseif all_grouped_locs2{i}(j) - timewindow < 1
            snippet_indices{i,j} = [1 all_grouped_locs2{i}+timewindow];
        else
            snippet_indices{i,j} = [all_grouped_locs2{i}(j)-timewindow all_grouped_locs2{i}(j)+timewindow];
        end
        snippets{i,j}=good_smoothtrace{i}(snippet_indices{i,j}(1):snippet_indices{i,j}(2));
    end 
end

snippets_col=reshape(snippets,numel(snippets),1);
snippets_col=snippets_col(~cellfun('isempty',snippets_col));

processed_astrotracelib = snippets_col;
save([pwd filesep 'processed_astrotracelib2'],'snippets_col')
    

%% Plot a couple snippets

for i=1:10
    subplot(2,5,i)
    plot(snippets_col{i})
    axis([0 2*timewindow+1 min(snippets_col{i}) max(snippets_col{i})])
    xlabel('frames')
    ylabel('F/F_0')
end

%% Manually choose x bounds of the snippets

%each can/should be a different size. want to capture beginning of peak to
%3/4 way through the peak
scrsz = get(groot,'ScreenSize');
SpikeFig=figure('Position',[1 scrsz(4)/3 scrsz(3)/1 scrsz(4)/3]);

for i=198:length(snippets_col)
    plot(snippets_col{i})
    hold on
    bounds=input('Enter bounds of snippet to keep [x y]:');
    snippets2{i}=snippets_col{i}(bounds(1):bounds(2))
    hold off
end 

save([pwd filesep 'processed_astrotracelib'],'snippets2')
%% plot a couple of the new snippets
figure()
for i=40:50
    subplot(5,2,i-39)
    plot((1:length(snippets2{i}))./20,snippets2{i})
    xlabel('Time')
    ylabel('F/F_0')
end

%% Modify each snippet in length and width

fps=20;
max_event_width = 4*fps; %max event width of 4 seconds
min_event_width = 5; %minimum event width of 250ms (5 frame)

for i = 1:length(snippets2)
    tallest_peak(i) = max(all_grouped_pks2{i});
    shortest_peak(i) = min(all_grouped_pks2{i});
end 

min_event_height = min(shortest_peak);
max_event_height = max(tallest_peak);

%find range of widths and heights
range_width = linspace(min_event_width,max_event_width,20);
range_height = linspace(min_event_height,max_event_height);

%create 100 of each scaling factor
a = range_width ./ mean(range_width); %normalize the range wrt the mean
b = range_height ./ mean(range_height);

full_astrotrace_lib = cell(length(snippets2),1);
for i = 1:length(full_astrotrace_lib)
    full_astrotrace_lib{i,1} = cell(length(a),length(b));
end

for snippetind = 1:length(snippets2)
    trace = snippets2{snippetind};
    n = numel(trace);
    for bind = 1:length(b)
        bscaled_trace{bind} = b(bind)*trace;
        for aind = 1:length(a)
            scaled_trace{aind,bind} = interp1(1:n, bscaled_trace{bind}, linspace(1, n, a(aind)*n), 'pchip');
        end 
    end 
    disp(['Completed snippet ' num2str(snippetind)])
    full_astrotrace_lib{snippetind,1} = scaled_trace;
    clear trace n bscaled_trace scaled_trace
end 

for i = 1:length(full_astrotrace_lib)
    full_astrotrace_lib{i,1}=full_astrotrace_lib{i}(2:end,:);
end 

save([pwd filesep 'full_astrotracelib'],'full_astrotrace_lib')

%% Run same peak detection on raw data
% the max length of a library trace is 77, so we want our time window to be
% 40 here
timewindow = 40;
[rawpks,rawlocs]= astrocyte_peakdetection_MS(astrotrace_lib);
%Get snippets
for i=1:length(astrotrace_lib)
    for j=1:length(rawpks{i})
        if rawlocs{i}(j) + timewindow > length(astrotrace_lib{i})
            snippet_indices{i,j} = [rawlocs{i}-timewindow length(astrotrace_lib{i})];
        elseif rawlocs{i}(j) - timewindow < 1
            snippet_indices{i,j} = [1 rawlocs{i}+timewindow];
        else
            snippet_indices{i,j} = [rawlocs{i}(j)-timewindow rawlocs{i}(j)+timewindow];
        end
        rawsnippets{i,j}=astrotrace_lib{i}(snippet_indices{i,j}(1):snippet_indices{i,j}(2));
    end 
end

rawsnippets_col=reshape(rawsnippets,numel(rawsnippets),1);
rawsnippets_col=rawsnippets_col(~cellfun('isempty',rawsnippets_col));

save([pwd filesep 'raw_astrotrace_snippets'],'rawsnippets_col')

%% Now calculate correlation and MSE

%preallocate memory
MSE = zeros(numel(full_astrotrace_lib{1}),length(full_astrotrace_lib),length(rawsnippets_col));
corr_coeff = zeros(length(full_astrotrace_lib{1}{1}),length(full_astrotrace_lib),length(rawsnippets_col));
for rawind = 1:length(rawsnippets_col)%loop through each raw trace
    for traceind = 1:length(full_astrotrace_lib)%loop through each lib trace
        for abind = 1:numel(full_astrotrace_lib{traceind})%loop through each of the a*b options for that trace
            %Now check which is longer and resample the shorter one to
            %match the longer one
            if length(rawsnippets_col{rawind}) < length(full_astrotrace_lib{traceind}{abind})
                reshaped_raw = interp1(rawsnippets_col{rawind}, linspace(1, length(rawsnippets_col{rawind}),...
                    length(full_astrotrace_lib{traceind}{abind})));   % Resample raw snippet to match the length of the snippet
                c = abs(corrcoef(reshaped_raw,full_astrotrace_lib{traceind}{abind}));   % Corrcoeff solution here
                corr_coeff(abind,traceind,rawind) = c(2,1);
                MSE(abind,traceind,rawind) = immse(reshaped_raw,full_astrotrace_lib{traceind}{abind});
                clear c
            else 
                reshaped_lib = interp1(full_astrotrace_lib{traceind}{abind}, linspace(1,...
                    length(full_astrotrace_lib{traceind}{abind}), length(rawsnippets_col{rawind})));
                c = abs(corrcoef(reshaped_lib,rawsnippets_col{rawind}));   % Corrcoeff solution here
                corr_coeff(abind,traceind,rawind) = c(2,1);
                MSE(abind,traceind,rawind) = immse(reshaped_lib,rawsnippets_col{rawind});
                clear c
            end 
        end
    end
end 

% Something is wrong with the above, don't think it populated MSE for the
% last traces because it is 0 very very often.

%% Plot a few surface plots

%generate random traces to plot
raw_r = randi([1 size(MSE,3)],1,10);
lib_r = randi([1 size(MSE,2)],1,10);
for i = 1:10
    figure(i)
    %lib_r = randi([1 size(MSE,2)])
    MSE_toplot = reshape(MSE(:,lib_r(i),raw_r(i)),[18,100]);
    surf(b,a,MSE_toplot)
    xlabel('Vertical scaling factor')
    ylabel('Horizontal scaling factor')
    %title(['MSE for raw trace ' num2str(raw_r(i)) ' , library trace ' num2str(lib_r)])
    clear MSE_toplot
end 

%% Get a and b back because I'm a dodo and didn't save them

for snippetind = 1:length(snippets2)
    peaks(snippetind)= max(snippets2{snippetind});
end 

fps=20;
max_event_width = 4*fps; %max event width of 4 seconds
min_event_width = 5; %minimum event width of 250ms (5 frame)

for i = 1:length(snippets2)
    tallest_peak(i) = max(peaks(i));
    shortest_peak(i) = min(peaks(i));
end 

min_event_height = min(shortest_peak);
max_event_height = max(tallest_peak);

%find range of widths and heights
range_width = linspace(min_event_width,max_event_width,20);
range_height = linspace(min_event_height,max_event_height);

%create 100 of each scaling factor
a = range_width ./ mean(range_width); %normalize the range wrt the mean
b = range_height ./ mean(range_height);
a = a(3:20);

scalingfactors{1} = a;
scalingfactors{2} = b;

save([pwd filesep 'astrotrace_scalingfactors'],'scalingfactors')

%% REDO THE MSE CALCULATIONS, WITHOUT INTERPOLATING , JUST OVERLAY RAW TRACE OF SAME LENGTH AS LIB SNIPPET

MSE = zeros(numel(full_astrotrace_lib{1}),length(full_astrotrace_lib),length(rawsnippets_col));
corr_coeff = zeros(length(full_astrotrace_lib{1}{1}),length(full_astrotrace_lib),length(rawsnippets_col));

for traceind = 1:length(full_astrotrace_lib)%loop through each lib trace
    for abind = 1:numel(full_astrotrace_lib{traceind})%loop through each of the a*b options for that trace
        for rawind = 1:length(rawsnippets_col)%loop through each raw trace
            %Get the right length of the raw snippet to compare with
            N = length(full_astrotrace_lib{traceind}{abind}); %number of elements to get from the raw trace
            midcol = ceil(length(rawsnippets_col{rawind})/2); %find middle of raw snippet (theoretically where the event is)
%             if length(full_astrotrace_lib{traceind}{abind}) == length(rawsnippets_col{rawind})
%                 raw_resized = rawsnippets_col{rawind};
            if mod(N,2) == 1 %if the length of the lib snippet is odd
                raw_resized = rawsnippets_col{rawind}((midcol - floor(N/2)):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
            else %the length of the lib snippet is even
                raw_resized = rawsnippets_col{rawind}((midcol - floor(N/2) + 1):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
            end
            %c = abs(corrcoef(raw_resized,full_astrotrace_lib{traceind}{abind}));   % Corrcoeff solution here
            %corr_coeff(abind,traceind,rawind) = c(2,1);
            %N
            %length(raw_resized)
            MSE(abind,traceind,rawind) = immse(raw_resized,full_astrotrace_lib{traceind}{abind});
            clear c N raw_resized midcol
        end 
    end
end 

%plotted the above using the plot section and looks like it worked!
%% Find global and local minima library traces
minMSE_eachtrace = zeros(length(rawsnippets_col),length(full_astrotrace_lib));
min_abind = zeros(length(rawsnippets_col),length(full_astrotrace_lib));
minMSE_alltrace = zeros(length(rawsnippets_col),1);
min_traceind = zeros(length(rawsnippets_col),1);

for rawi = 1:length(rawsnippets_col)%loop through each raw trace
    [minMSE_eachtrace(rawi,:),min_abind(rawi,:)] = min(MSE(:,:,rawi));
    [minMSE_alltrace(rawi,1),min_traceind(rawi,1)] = min(minMSE_eachtrace(rawi,:));
end 

[unique_traceinds,ia,ic] = unique(min_traceind);
unique_traceinds = min_traceind(ia);

freq = histc(min_traceind,unique_traceinds);
bar(unique_traceinds,freq,'BarWidth',1)
xlabel('Library Trace Number')
ylabel('Frequency')
title('Histogram of Astro Library Traces with Minimum MSE')
axis([0 length(full_astrotrace_lib) 0 max(freq2)+5])

repeat_traceinds = unique_traceinds(freq > 1);

%% Rerun MSE on the best-performing library traces, ranging over all values of a and b

MSE_best = zeros(numel(full_astrotrace_lib{1}),length(repeat_traceinds),length(rawsnippets_col));

for traceind = 1:length(repeat_traceinds)%loop through each lib trace
    for abind = 1:numel(full_astrotrace_lib{traceind})%loop through each of the a*b options for that trace
        for rawind = 1:length(rawsnippets_col)%loop through each raw trace
            %Get the right length of the raw snippet to compare with
            N = length(full_astrotrace_lib{repeat_traceinds(traceind)}{abind}); %number of elements to get from the raw trace
            midcol = ceil(length(rawsnippets_col{rawind})/2); %find middle of raw snippet (theoretically where the event is)
%             if length(full_astrotrace_lib{traceind}{abind}) == length(rawsnippets_col{rawind})
%                 raw_resized = rawsnippets_col{rawind};
            if mod(N,2) == 1 %if the length of the lib snippet is odd
                raw_resized = rawsnippets_col{rawind}((midcol - floor(N/2)):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
            else %the length of the lib snippet is even
                raw_resized = rawsnippets_col{rawind}((midcol - floor(N/2) + 1):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
            end
            %N
            %length(raw_resized)
            MSE_best(abind,traceind,rawind) = immse(raw_resized,full_astrotrace_lib{repeat_traceinds(traceind)}{abind});
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
    clear MSE__best_toplot
end 

%the above look reasonable.
%% Now find the "best of the best" library traces

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
title('Histogram of "Best" Astro Library Traces with Minimum MSE')
axis([0 length(full_astrotrace_lib) 0 max(freq2)+5])

freq_cutoff = floor(0.05*280); %must appear in at least 5% of the 280 raw traces
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

%The above gives us 5 best traces, each with 15+ variations in a & b (total of 130). Let's
%compare that with taking the traces that produced overall 130 lowest MSE's.

% Now figure out "who" those min 130 belong to. To sort globally we need to
% flatten the MSE from the top 40 traces
minbestMSE_flattened = reshape(minbestMSE_eachtrace,[40*280,1]);
minbest_abind_flattened = reshape(minbest_abind,[40*280,1]);
[sorted_minbestMSE_flattened,flattened_sorting_ind] = sort(minbestMSE_flattened,'ascend');

min130 = flattened_sorting_ind(1:150); %get the minimum 130 MSE traces (there will be some repeats)
min130_ab = minbest_abind_flattened(min130);%find the corresponding 

[raw,lib] = ind2sub([280,40],min130); %get the row and column (aka raw and library trace) indeces from the vectorized form
length(unique(raw)); %only 46 of the 280 raw trace represented
length(unique(lib)); %21 / 40 of the lib traces are represented
best_lib_traces_method2 = repeat_traceinds(lib); %what are the best library traces via this method
[unique_traces_method2,unique_inds2,ic3] = unique(lib); %get the unique library traces from this method
[row,col] = ind2sub([1,280*40],unique_traces_method2); %re-stretch it out
unique_stretched = min130(col);

%Let's visually compare which traces "won" btwn method 1 and method 2
freq3 = histc(best_lib_traces_method2,repeat_traceinds(unique(lib)));

%make a big matrix for comparison purposes and to help me think about what's going on: 
%first column is the index of the trace in the flattened matrix.
%second column is the ab index corresponding to that
%third column is the library trace index (in the top 40)
%fourth column is the library trace index (in the overall 217)
compare(:,1) = min130;
compare(:,2) = min130_ab;
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

%% Create comparative barplot

bar(repeat_traceinds(unique(lib)),freq3,'FaceColor','red','BarWidth',1)%,'width','1')
hold on 
bar(repeat_traceinds(unique_best_traceinds),freq2,'FaceColor','blue','BarWidth',1)%,'width','1')
legend('method2:global minimum MSE','method1: based on frequency')
axis([0 length(full_astrotrace_lib) 0 max(freq2)+5])
xlabel('Astrocyte Library Trace')
ylabel('Frequency as "Best"')

%% Collect the actual traces!
astrospikes = {};
for tindex = 1:length(best_abind) %loop through each trace
    for varindex = 1:length(best_abind{2,tindex})%loop through each variation of that trace
        astrospikes{tindex,varindex} = full_astrotrace_lib{best_abind{1,tindex}}{best_abind{2,tindex}(varindex)};
    end 
end 

astrospikes = astrospikes(~cellfun('isempty',astrospikes));
astrospikes = reshape(astrospikes,1,numel(astrospikes));

%save('astrospikes1','astrospikes')

%% Collection for method 2
astrospikes2 = {};
%collect those actual traces!
for tindex2 = 1:length(best_abind2) %loop through each trace
    for varindex2 = 1:length(best_abind2{2,tindex2})%loop through each variation of that trace
        astrospikes2{tindex2,varindex2} = full_astrotrace_lib{best_abind2{1,tindex2}}{best_abind2{2,tindex2}(varindex2)};
    end 
end 

astrospikes2 = astrospikes2(~cellfun('isempty',astrospikes2));
astrospikes2 = reshape(astrospikes2,1,numel(astrospikes2));

save('astrospikes2','astrospikes2')

%FROM THIS WE LEARN THAT MINIMUM MSE TRACES ARE ALWAYS THE SHORTEST ONES.
%WHY? Isn't MSE normalized by the number of elements?

%% Gather traces for overlay plots

%find the corresponding raw trace that matches the 
for i = 1:length(repeat_traceinds)%loop through each library trace we kept
    %make the corresponding raw trace index the third column
    [temp(rawi,1),rawind_for_overlap(i,3)] = min(minbestMSE_eachtrace(:,i));
    %first column will be lib trace index
    rawind_for_overlap(i,1) = repeat_traceinds(i);
    %second column will be corresponding variation (abind) of that trace
    rawind_for_overlap(i,2) = minbest_abind(rawind_for_overlap(i,3),i);
end 

%% Now make the plots

for i = 10:30
    N = length(full_astrotrace_lib{rawind_for_overlap(i,1)}{rawind_for_overlap(i,2)}) %number of elements to get from the raw trace
    midcol = ceil(length(rawsnippets_col{rawind_for_overlap(i,3)})/2); %find middle of raw snippet (theoretically where the event is)     
    if mod(N,2) == 1 %if the length of the lib snippet is odd
        raw_resized = rawsnippets_col{rawind_for_overlap(i,3)}((midcol - floor(N/2)):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
    else %the length of the lib snippet is even
        raw_resized = rawsnippets_col{rawind_for_overlap(i,3)}((midcol - floor(N/2) + 1):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
    end
    figure(i)
    plot([(1:N)./20],full_astrotrace_lib{rawind_for_overlap(i,1)}{rawind_for_overlap(i,2)})
    hold on
    plot([(1:N)./20],raw_resized)
    xlabel('Time (s)')
    ylabel('F/F_0')
    legend('Library','Raw')
    clear raw_resized N midcol
end 

%Overlay plots look good/make sense, except really beginning to think we
%should exclude lib traces <5 points long. Going to remove those now

%% Keep only traces longer than 5 points

for i = 1:numel(astrospikes)
    if size(astrospikes{i},2) < 5
        astrospikes{i} = [];
    end 
end

astrospikes = astrospikes(~cellfun('isempty',astrospikes));
%now we have 95!

save('astrospikes3','astrospikes')

%% Want to keep only the mins that respond to lib traces longer than 5 points

for i = 1:size(full_astrotrace_lib,1)
    for a = 1:size(full_astrotrace_lib{i},1) %loop through each a
        for b = 1:size(full_astrotrace_lib{i},2) %loop through each b
            length = numel(full_astrotrace_lib{i}{a,b});
            if length >= 5
                shortened_astrotrace_lib{i,1}{a,b} = full_astrotrace_lib{i}{a,b};
            end 
        end 
    end 
    clear length
end 

%% Now redo MSE calculations only with traces larger than 5

MSE3 = zeros(numel(shortened_astrotrace_lib),length(shortened_astrotrace_lib),length(rawsnippets_col));

for traceind = 1:length(full_astrotrace_lib)%loop through each lib trace
    for abind = 1:numel(full_astrotrace_lib{traceind})%loop through each of the a*b options for that trace
        for rawind = 1:length(rawsnippets_col)%loop through each raw trace
            %Get the right length of the raw snippet to compare with
            if isempty(shortened_astrotrace_lib{traceind}{abind})
                MSE3(abind,traceind,rawind) = NaN;
            else 
                N = length(full_astrotrace_lib{traceind}{abind}); %number of elements to get from the raw trace
                midcol = ceil(length(rawsnippets_col{rawind})/2); %find middle of raw snippet (theoretically where the event is)
    %             if length(full_astrotrace_lib{traceind}{abind}) == length(rawsnippets_col{rawind})
    %                 raw_resized = rawsnippets_col{rawind};
                if mod(N,2) == 1 %if the length of the lib snippet is odd
                    raw_resized = rawsnippets_col{rawind}((midcol - floor(N/2)):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
                else %the length of the lib snippet is even
                    raw_resized = rawsnippets_col{rawind}((midcol - floor(N/2) + 1):(midcol + floor(N/2))); %get the middle N elements from the raw trace (since traces are centered at the peak
                end
                %c = abs(corrcoef(raw_resized,full_astrotrace_lib{traceind}{abind}));   % Corrcoeff solution here
                %corr_coeff(abind,traceind,rawind) = c(2,1);
                %N
                %length(raw_resized)
                MSE3(abind,traceind,rawind) = immse(raw_resized,shortened_astrotrace_lib{traceind}{abind});
            end 
            clear c N raw_resized midcol
        end 
    end
end 

%CONTINUE TO ASTROLIBRARYPROCESSINGV3.