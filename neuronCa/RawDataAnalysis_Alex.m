function RawDataAnalysis_Alex(folderpath,fps)


%Grab recording data
%get all tiff files in the folder
files = dir([folderpath filesep '*.tif']);
%exclude tiff files whose name begins with "Segmentation"
exclude_idx = [];
for j=1:numel(files)
    if(~isempty(strfind(files(j).name,'Segmentation')) || ...
            ~isempty(strfind(files(j).name, 'MAX')))
        exclude_idx = [exclude_idx j];
    end
end
files(exclude_idx) = [];
files.name

%Extract raw fluorescence data
L = cell(numel(files),1);
%info = cell(numel(files),1)
clear info
analysis=struct([]);
for j=1:numel(files)            %go through all stacks
        filename = [folderpath filesep files(j).name]
        clear info
        info=imfinfo(filename);
        num_frames(j) = numel(info);
        %info = imfinfo(filename)
        %frames(j) = size(info,1);
       
        
        %Identify continuation files
        %(** Large files are split into filename-file001.tif,
        % ** -file002.tif etc)
        idx = strfind(files(j).name,'file');
        if(idx)
            % This file is a continuation of a larger file. Use the
            % segmentation of the first file.
            stackname = files(j).name;
            stackname = [stackname(1:idx-2) '.tif'];
        else
            stackname = files(j).name;
        end
        
       
        %Load segmentation file 
        %(** Segmentation file for a stack named "filename.tif" must be
        % ** named "Segmentation-filename.tif")
        segname = [folderpath filesep 'Segmentation-' stackname(1:end-4) '.mat'];
        data=load(segname);
        L{j} = data.L;
        if(max(max(L{j})) == 1)
            L{j} = bwlabel(L{j});       %label connected components in binary file (blobs of pixels corresponding to one neuron)
        end
        toc
        
        %Compute full frame, single cell and background intensities; dF/F
        bkgpts= randi(size(L{j},1)*size(L{j},2),1,50);
        N = max(max(L{j})); % Number of cells
        clear F_whole stats F_cell F_cell_scaled F_cell_delta F_bkg
        F_bkg = zeros(num_frames(j),1);
        F_whole = zeros(num_frames(j),1);  
        F_cell = zeros(N,num_frames(j));
        F_cell_scaled = zeros(N,num_frames(j));
        F_cell_delta = zeros(N,num_frames(j));
        
        
        for k=1:num_frames(j)
            clear I
            I = imread(filename,k, 'Info', info);
            F_whole(k) = mean(mean(I));
            stats = regionprops(L{j},I,'MeanIntensity');
            F_cell(:,k) = [stats.MeanIntensity]';
            F_bkg(k)=mean(I(bkgpts));
            F_cell_scaled(:,k)=F_cell(:,k)/F_bkg(k);  
            F_cell_delta(:,k)=F_cell(:,k)-F_bkg(k);
            %toc
        end
        
        
        
        %Assemble and save analysis output structure 
        analysis(j).filename = filename;
        analysis(j).fps=fps;
        analysis(j).L = L{j};
        analysis(j).N=N;
        analysis(j).F_whole = F_whole;
        analysis(j).F_cell = F_cell;
        analysis(j).F_bkg = F_bkg;
        analysis(j).F_cell_delta = F_cell_delta;
        analysis(j).F_cell_scaled = F_cell_scaled;
        save([folderpath filesep 'analysis.mat'], 'analysis');      
toc
end



%Merge continuation files belonging to the same recording
%find out the unique filename, ie those not containing -file002.tif, etc
if isempty(analysis)
    display('No data in folder');
    return
end

files = {analysis.filename};
unique_idx = find(cellfun(@(x) isempty(x),strfind(files,'file')))';
unique_files = files(unique_idx);
%j indexes continuation files
for j=setdiff(1:numel(files),unique_idx)
    % Figure out the index of the parent file
    tmpidx = strfind(files{j},'file');
    prefix = [files{j}(1:tmpidx-2) '.tif'];
    % Now find where this parent file is
    parent_idx = find(strcmpi(unique_files,prefix));
    % Next figure out which continuation number this is, eg file002 is
    % #2, file003 is #3
    continuation_num = str2double(strtok(files{j}(tmpidx:end),['file','.tif']));
    % Finally, put this back in unique_idx
    unique_idx(parent_idx,continuation_num) = j;
end

size(unique_idx)
merged_analysis = [];
%We are ready to merge files
for j=1:size(unique_idx,1)
    F_cell = [];
    F_cell_scaled = [];
    F_cell_delta = [];
    F_whole = [];
    F_bkg= [];
    files_stiched = {};
    frames = zeros(nnz(unique_idx(j,:)),1);
   for k=1:nnz(unique_idx(j,:))
        F_cell_new = analysis(unique_idx(j,k)).F_cell;
        F_whole_new = analysis(unique_idx(j,k)).F_whole;
        F_bkg_new = analysis(unique_idx(j,k)).F_bkg;
        F_cell_scaled_new = analysis(unique_idx(j,k)).F_cell_scaled;
        F_cell_delta_new = analysis(unique_idx(j,k)).F_cell_delta;
        frames(k) = size(F_cell_new,2);
        F_whole = [F_whole,F_whole_new'];
        F_cell = [F_cell,F_cell_new];
        F_bkg = [F_bkg, F_bkg_new'];
        F_cell_delta = [F_cell_delta F_cell_delta_new];
        F_cell_scaled = [F_cell_scaled F_cell_scaled_new];
        files_stiched{k} = files{unique_idx(j,k)};
    end
    
    %Put it in a struct
    merged_analysis(j).filename = files{unique_idx(j,1)};
    merged_analysis(j).files_stiched = files_stiched;
    merged_analysis(j).frames = size(F_cell,2);
    merged_analysis(j).fps = fps;
    merged_analysis(j).L = L{j};
    merged_analysis(j).F_cell = F_cell;
    merged_analysis(j).F_whole = F_whole;
    merged_analysis(j).F_bkg = F_bkg;
    merged_analysis(j).F_cell_delta = F_cell_delta;
    merged_analysis(j).F_cell_scaled = F_cell_scaled;
end

    clear analysis
    analysis=merged_analysis;
    
save([folderpath filesep 'processed_analysis.mat'],'analysis');





end

