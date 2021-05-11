function [A,P,S,phi] = FC_phase_Mod(spikes,output,timerange,cellrange,gpu_ON)
% Define adjacency matrix using departure of pair-wise phase difference
% from resampled phase

% output(1) -- adjacency matrix
% output(2) -- pairwise synchronization values
% timerange and cellrange or indices to analyze
% spikes is matrix with cell indices in row and raster plot in y
% Also calls functions
%      1. AAFTsur_Mod
%      2. GetPhaseSpikes_Mod -- only if using Tapan's phase calculation 

% gpu_ON=1;  % if want to use gpu to calculate phase difference
% desired_time_interval=1000;  % in ms;

% Default Call: [A,P,S,phi]=FC_phase_Mod(spikes,[0 1],[],[],0)

A=[];
P=[];
S=[];
phi=[];

% Cut up phase matrix in time, analyzing 1 second (1000 samples) at a time
        %Use standard spacing in ms
% index=[1:1000:(size(spikes,2)-1) size(spikes,2)]';
index=[1 size(spikes,2)]';
% index_length=length(index{1});
%      index=[1:1000:size(phi,2) size(phi,2)]; % adds last time bin, but will not average over same # samples in last time bin
        
% Estimage largest matrix gpu can handle, 1GB of memory
%  index=round(linspace(1,size(phi,2),2+floor(numel(spikes)/8/1024/1024)));

% Downsample spike matrix
if ~isempty(timerange)
    if size(timerange,1)==1  % if it has only one column (range of times to calculate synchronization
       spikes=spikes(:,timerange{1});
%        index=[1:(floor(size(spikes,2)/floor(numel(spikes)/8/1024/1024)/1000)*1000):size(spikes,2)]';
%        index=[1:5000:(timerange{1}(end)-timerange{1}(1))];
       index=[1:1000:(size(spikes,2)-1) size(spikes,2)];
       index=mat2cell([index(1:end-1)' index(2:end)'-1],ones(size(index,2)-1,1),2); 
       index_length=size(index,1);
    else % if multiple time segments are specified to calculate
        % Build index from specified timeranges
        min_time=timerange{1}(1);
        max_time=timerange{end}(end);
        
        %Reduce spikes
        spikes=spikes(:,min_time:max_time);
        
        % Calculate Indices for Synchronization Calculation        
        index=[];  % Reconstruct index matrix
        index_length=0;
        for xx=1:size(timerange,1)
            %Make sure no index is more than 5000 steps apart -- memory
            %limit issue of GPU -- 5000 can be changed depending upon
            %available memory
            tmp_index=[timerange{xx}(1):4000:(timerange{xx}(end)-1) timerange{xx}(end)];
            index=[index;tmp_index-min_time+1]; % account for reducing spikes matrix by subtracting index
            index_length=index_length+(length(tmp_index)-1);
        end
    end
end

if ~isempty(cellrange)
    spikes=spikes(cellrange,:);
end

%% Tapans phase calculation
% tic
% phi = zeros(size(spikes));
% tfinal=size(spikes,2);
% parfor i=1:60%size(spikes,1)
%     phi(i,:) = GetPhaseSpikes_Mod(find(spikes(i,:)'),tfinal);
% end
% toc

%% My phase Calculation -- this is faster
phi=nan(size(spikes));
% phi=2.*pi.*rand(size(spikes));

hh=waitbar(0,'Calculating Phase Delays');

for xx=1:size(spikes,1)
%     if isempty(crange) || ~isempty(find(xx==crange,1)) 
        if mod(xx,25)==0
            waitbar(xx/size(spikes,1),hh);
        end
        spike_time=find(spikes(xx,:));
        for tt=1:(size(spike_time,2)-1)
            phi(xx,spike_time(tt):spike_time(tt+1))=linspace(0,2*pi,spike_time(tt+1)-spike_time(tt)+1);
        end
%     end
end
close(hh); 

% plot(0:.001:60,sin(phi(1,:)))
%% Calculate Phase Synchronization using GPU
if output(2)  
    %Calculate pairwise Synchronization
    S=zeros(size(spikes,1),size(spikes,1));
    num_cells=size(phi,1);

    phase_tmp=phi';
    gpuPhase=phase_tmp;

    PW_Phase_Diff=(zeros(size(phi,1)));
    for yy=1:(size(gpuPhase,2)-1)
       gamma=mod(abs(repmat(gpuPhase(:,yy),1,num_cells-yy)-gpuPhase(:,(yy+1):end)),2*pi);
%        gamma(isnan(gamma(:,1)),:)=[]; % Remove nan rows
       PW_tmp=[nan.*zeros(1,yy-1) 1 abs(nanmean(cos(gamma),1) + 1i.*nanmean(sin(gamma),1))];
       PW_Phase_Diff(yy,:)=PW_tmp;
    end
    S=double(PW_Phase_Diff);
    S(isnan(S))=0;
    S=S+S';
end
%% Tapans Pairwise Comparison for Functional Connectivity
if output(1)
    [M,T] = size(phi);
    A = zeros(M);
    P = zeros(M);
    Nsur = 50; % Number of times to resample  %50
    hh=waitbar(0,'Calculating Functional Connectivity');
    time_tracker=0;
    time=0;
    %c=gcp; % Start Parallel Pool
    
    %Fill in nans in phase with rand values -- For shuffling purposes must
    %not be any nans
    data_exists=zeros(size(phi,1),1);
    for xx=1:size(phi,1)
        fill_tmp=isnan(phi(xx,:));
        phi(xx,fill_tmp)=2.*pi.*rand(1,sum(fill_tmp));
        if sum(fill_tmp) < size(phi(xx,:),2)
            data_exists(xx)=1;
        end
    end
    
    for zz=1:M
        
        if data_exists(zz)   % if there is some firing for this node
            tic
            parfor jj=1:M
                if data_exists(jj) && (jj>zz)
                    psur = zeros(Nsur,1);
                    phi1 = phi(zz,:);
                    phi2 = phi(jj,:);
                    phi12 = mod((phi1-phi2),2*pi);
                    psi2 = AAFTsur(phi2,Nsur);
                    psi12 = mod((repmat(phi1,Nsur,1)-psi2'),2*pi);
                    for k=1:Nsur     
    %                     psi2 = AAFTsur_Mod(phi2,1,0);
    %                     psi12 = mod((phi1-psi2'),2*pi);

    %                     psi12 = mod((phi1-psi2(:,k)'),2*pi);
                        [~,psur(k)] = kstest2(hist(phi12,linspace(0,2*pi,100)),...
                            hist(psi12(k,:),linspace(0,2*pi,100)));
                    end
                    P(zz,jj) = mean(psur);

                    if(prctile(psur,95)<.05)
                        A(zz,jj) = 1;
                    end
                else
                    P(zz,jj)=1;
                end
            end
       
            % Track Computation Time
            time=toc;
            time_tracker=time_tracker+time;
            waitbar(zz/M,hh,{'Calculating Functional Connectivity'; [num2str(zz) ' of ' num2str(...
                M-1) ' at ' num2str(time) ' sec per row (Total=' num2str(time_tracker/60,5) ' min)']});
        else
            P(zz,:)=1;
        end
    end
    close(hh);
    
    A=A+A';
end
