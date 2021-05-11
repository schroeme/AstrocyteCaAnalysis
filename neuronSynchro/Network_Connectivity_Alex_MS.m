function Network_Connectivity_Alex_MS(folderpath,parindex)

%% Initialiaze 

SourceFolder = [folderpath];
TargetFolder = [folderpath filesep 'networkdata'];

if ~exist(TargetFolder, 'dir')
 mkdir(TargetFolder);
end

%get & load .mat processed_analysis file in the folder
afile = dir([SourceFolder filesep 'processed_analysis_spikech.mat']);
load([SourceFolder filesep afile.name])

%load([SourceFolder filesep 'processed_analysis_reg.mat']);
initanalysisdata=analysis;

%% Compute functional connectivity based on phase method - adapted by A. Adegoke from T. Patel's code
 
for cindex=1:numel(analysis)             %for all conditions
%for cindex=2
     
    %Extract phase
    phi = zeros(size(analysis(cindex).spikedata.F_cell'));
    %phi = zeros(50,size(analysis(cindex).spikedata.F_cell',2));
     
    if(parindex==1)
       parfor i=1:size(analysis(cindex).spikedata.F_cell,2)   %for all cells
       %parfor i=1:50
           phi(i,:) = GetPhaseSpikes(analysis(cindex).spikedata.baseline_locs{i},size(analysis(cindex).spikedata.F_cell,1));
       end
    else
       for i=1:size(analysis(cindex).spikedata.F_cell,2)      %for all cells
           phi(i,:) = GetPhaseSpikes(analysis(cindex).spikedata.baseline_locs{i},size(analysis(cindex).spikedata.F_cell,1));
       end
    end
    analysis(cindex).FC.phase=phi;


    %Surrogate analysis
    Nsur = 50;                  % Number of times to resample
    params.FC.phase.alpha=0.001; % Significance level for surrogate testing
    
    s.phase=phi;
    [M,T] = size(s.phase);

    A = zeros(M);
    P = zeros(M);

    hh=waitbar(0,'Functional connectivity: phase');
    
    for i=1:M
        waitbar(i/M,hh);
        if(parindex==1)
            parfor j=i+1:M

                    psur = zeros(Nsur,1);
                    phi1 = s.phase(i,:);
                    phi2 = s.phase(j,:);
                    phi12 = mod((phi1-phi2),2*pi);
                    for k=1:Nsur

                        psi2 = AAFTsur(phi2,1);

                        psi12 = mod((phi1-psi2'),2*pi);
                        [~,p] = kstest2(hist(phi12,linspace(0,2*pi,100)),...
                            hist(psi12,linspace(0,2*pi,100)));
                        psur(k) = p;
                    end

                    P(i,j) = mean(psur);

                    if(prctile(psur,95)<params.FC.phase.alpha)
                        A(i,j) = 1;
                    end

            end
        else
            for j=i+1:M

                    psur = zeros(Nsur,1);
                    phi1 = s.phase(i,:);
                    phi2 = s.phase(j,:);
                    phi12 = mod((phi1-phi2),2*pi);
                    for k=1:Nsur

                        psi2 = AAFTsur(phi2,1);

                        psi12 = mod((phi1-psi2'),2*pi);
                        [~,p] = kstest2(hist(phi12,linspace(0,2*pi,100)),...
                            hist(psi12,linspace(0,2*pi,100)));
                        psur(k) = p;
                    end

                    P(i,j) = mean(psur);

                    if(prctile(psur,95)<params.FC.phase.alpha)
                        A(i,j) = 1;
                    end

            end
        end
    end

    %make symmetric adjancency matrix from upper triangular one, to
    %eliminate the possibility that neuron i is connected to neuron j, but
    %neuron j is not connected to neuron i that could arise since code goes
    %through all possible connections (ij and ji pair), generates surrogates, and decide if i is
    %connected to j based on statistical significance, so borderline
    %p-values could give conflicting results
    datactrilow=triu(A)';
    A=datactrilow+triu(A);

    
    %update fields in analysis file   
    analysis(cindex).FC.A=A;
    analysis(cindex).FC.P=P;
    

    close all
    
    % Save new analysis file with network data
    %save([TargetFolder filesep 'processed_analysis_reg_netw.mat'],'analysis');
    save([TargetFolder filesep afile.name(1:end-4) '_netw.mat'],'analysis');
end

% Save new analysis file with connectivity data
%save([TargetFolder filesep 'processed_analysis_reg_netw.mat'],'analysis');
save([TargetFolder filesep afile.name(1:end-4) '_netw.mat'],'analysis');

