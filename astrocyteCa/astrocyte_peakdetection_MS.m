function [all_grouped_pks,all_grouped_locs] = astrocyte_peakdetection_MS(traces_lib)

timewindow = 20;%in frames per second
timebin = 1200; %in frames, length of the time bin over which to compare peaks
grouped_locs = [];
grouped_pks = [];
min_pk_distance = timebin/3;%max 3 events per time window

for i=1:length(traces_lib)%loop through all traces
    binned_time = 1:timebin:length(traces_lib{i})+1;
    for j = 1:length(binned_time)-1%loop through each time bin
        %find the local peaks in that timebin
        overall_max_pk_height(i) = max(traces_lib{i});
        if j == length(binned_time)-1
            max_pk_height(j) = max(traces_lib{i}(binned_time(j):end));
            if max_pk_height(j) >= overall_max_pk_height - .2; %if the max pk height is relatively high
                [temp_pks{j},temp_locs{j}]=findpeaks(traces_lib{i}(binned_time(j):end),'MinPeakHeight',.95*max_pk_height(j),'MinPeakDistance',min_pk_distance);
            else
                temp_locs{j} = [];
                temp_pks{j} = [];
            end 
        else 
            max_pk_height(j) = max(traces_lib{i}(binned_time(j):binned_time(j+1)));
            if max_pk_height(j) >= overall_max_pk_height - .2; %if the max pk height is relatively high
                [temp_pks{j},temp_locs{j}]=findpeaks(traces_lib{i}(binned_time(j):binned_time(j+1)),'MinPeakHeight',.97*max_pk_height(j),'MinPeakDistance',min_pk_distance);
            else
                temp_locs{j} = [];
                temp_pks{j} = [];
            end 
        end 
        grouped_locs = [grouped_locs (temp_locs{j} + binned_time(j)-1)];
        grouped_pks = [grouped_pks temp_pks{j}];
    end 
    clear max_pk_height overall_max_pk_height
    all_grouped_locs{i,1} = grouped_locs;
    all_grouped_pks{i,1} = grouped_pks;
    clear binned_time temp_locs temp_pks grouped_locs grouped_pks
    grouped_locs = [];
    grouped_pks = [];
end