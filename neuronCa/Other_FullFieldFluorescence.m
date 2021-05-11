                                                                function Other_FullFieldFluorescence(folderpath)

% 3/21/2016: A. Adegoke using code from T. Patel's CaGUI (FluoroSNNAP)

% INPUT: folder(s) with tiff stack of recording to calculate full field fluorescence
% CODE: goes through each stack and calculates the mean intensity over the
% entire field of view at each frame; it will merge stacks belonging to the
% same recording (ie those that have -file002, -file003 in their name) with
% the parent stack
% OUTPUT: "analysis.mat", which contains the structure "analysis" with
% fields: filename (location & filename of the tiff stack); F_whole (a
% vector of N elements, where N is the number of frames in the recording);
% the analysis file has as many elements as there are unique recordings in
% the input folder. The file gets saved in the same folder as the tiff
% stacks

        
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


%Extract raw fluorescence data
clear info
analysis=struct([]);
for j=1:numel(files)  
        filename = [folderpath filesep files(j).name]
        clear info
        info=imfinfo(filename);
        num_frames(j) = numel(info);
       
        %Compute full frame, single cell and background intensities; dF/F     
        clear F_whole stats 
        F_whole = zeros(num_frames(j),1);         
        
        for k=1:num_frames(j)
            clear I
            I = imread(filename,k, 'Info', info);
            F_whole(k) = mean(mean(I));
        end
                      
        %Assemble temporary analysis output structure 
        analysis(j).filename = filename;
        analysis(j).F_whole = F_whole;        
        %save([folderpath filesep 'analysis.mat'], 'analysis');      
end


%Merge continuation files belonging to the same recording
%find out the unique filename, ie those not containing -file002.tif, etc
if isempty(analysis)
    cprintf('red','No data in folder \n');
    return
end

files = {analysis.filename};
unique_idx = find(cellfun(@(x) isempty(x),strfind(files,'file')))';
unique_files = files(unique_idx);

for j=setdiff(1:numel(files),unique_idx)    %j indexes continuation files
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
    F_whole = [];
    files_stiched = {};
   for k=1:nnz(unique_idx(j,:))
        F_whole_new = analysis(unique_idx(j,k)).F_whole;       
        F_whole = [F_whole,F_whole_new'];       
        files_stiched{k} = files{unique_idx(j,k)};
    end
    
    %Put it in a struct
    merged_analysis(j).filename = files{unique_idx(j,1)};
    merged_analysis(j).files_stiched = files_stiched; 
    merged_analysis(j).F_whole = F_whole;
   
end

    clear analysis
    analysis=merged_analysis;
    
save([folderpath filesep 'analysis.mat'],'analysis');

end

