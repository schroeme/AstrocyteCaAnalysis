%MULTILAYER ASTRO PUBLICATTION WRAPPER SCRIPT
%Margaret Schroeder
%Last update 5/1/2021


%% Load the folders

%specify the base path for your data here
basepath = '/ssd/Dropbox/Penn/Meaney Lab Data and Code/';


allfolders={
        'MargaretFall2018/Injury_10-11-18/D01';
        'MargaretFall2018/Injury_10-11-18/D02';
        'MargaretFall2018/Injury_10-11-18/D03';
        'MargaretFall2018/Injury_10-11-18/D04';
        'MargaretFall2018/Injury_10-11-18/D05';
        'MargaretFall2018/Injury_10-11-18/D06';
        'MargaretFall2018/Injury_10-11-18/D07';
        'MargaretFall2018/Injury_10-11-18/D08';

        'MargaretFall2018/Injury_10-25-18/D01';
        'MargaretFall2018/Injury_10-25-18/D02';
        'MargaretFall2018/Injury_10-25-18/D04';

        'MargaretFall2018/Injury_11-1-18/D01';
        'MargaretFall2018/Injury_11-1-18/D02';
        'MargaretFall2018/Injury_11-1-18/D03';
        'MargaretFall2018/Injury_11-1-18/D04';
        'MargaretFall2018/Injury_11-1-18/D05';
        'MargaretFall2018/Injury_11-1-18/D06';
        'MargaretFall2018/Injury_11-1-18/D07';
        'MargaretFall2018/Injury_11-1-18/D08';

        'MargaretFall2018/Injury_11-29-18/D01';
        'MargaretFall2018/Injury_11-29-18/D02';
        'MargaretFall2018/Injury_11-29-18/D03';
        'MargaretFall2018/Injury_11-29-18/D04';

    'Margaret_Spring2019/Injury_1-24-19/D01';
    'Margaret_Spring2019/Injury_1-24-19/D02';
    'Margaret_Spring2019/Injury_1-24-19/D03';
    'Margaret_Spring2019/Injury_1-24-19/D04';
    'Margaret_Spring2019/Injury_1-24-19/D05';
    'Margaret_Spring2019/Injury_1-24-19/D07';
    'Margaret_Spring2019/Injury_1-24-19/D08';
%     
    'Margaret_Spring2019/Injury_1-31-19/D01';
    'Margaret_Spring2019/Injury_1-31-19/D02';
    'Margaret_Spring2019/Injury_1-31-19/D03';
    'Margaret_Spring2019/Injury_1-31-19/D04';
    'Margaret_Spring2019/Injury_1-31-19/D05';
    'Margaret_Spring2019/Injury_1-31-19/D06';
             }; 
         
MEM_Sham = {'MargaretFall2018/Injury_10-11-18/D02';
    'MargaretFall2018/Injury_10-11-18/D06';
    'MargaretFall2018/Injury_10-25-18/D04';
    'MargaretFall2018/Injury_11-1-18/D04';
    'MargaretFall2018/Injury_11-1-18/D08';
    'MargaretFall2018/Injury_11-29-18/D04';
    'Margaret_Spring2019/Injury_1-24-19/D04';
    'Margaret_Spring2019/Injury_1-24-19/D08';
    'Margaret_Spring2019/Injury_1-31-19/D04';
    
    };

MPEP_Sham = {'MargaretFall2018/Injury_10-11-18/D01';
    'MargaretFall2018/Injury_10-11-18/D05';
    'MargaretFall2018/Injury_11-1-18/D03';
    'MargaretFall2018/Injury_11-1-18/D07';
    'MargaretFall2018/Injury_11-29-18/D03';
    'Margaret_Spring2019/Injury_1-24-19/D03';
    'Margaret_Spring2019/Injury_1-24-19/D07';
    'Margaret_Spring2019/Injury_1-31-19/D03';
    };

MEM_Inj = {'MargaretFall2018/Injury_10-11-18/D04';
    'MargaretFall2018/Injury_10-11-18/D08';
    'MargaretFall2018/Injury_10-25-18/D02';
    'MargaretFall2018/Injury_11-1-18/D02';
    'MargaretFall2018/Injury_11-1-18/D06';
    'MargaretFall2018/Injury_11-29-18/D02';
    'Margaret_Spring2019/Injury_1-24-19/D02';
    'Margaret_Spring2019/Injury_1-31-19/D02';
    'Margaret_Spring2019/Injury_1-31-19/D06';
    };

MPEP_Inj = {'MargaretFall2018/Injury_10-11-18/D03';
    'MargaretFall2018/Injury_10-11-18/D07';
    'MargaretFall2018/Injury_10-25-18/D01';
    'MargaretFall2018/Injury_11-1-18/D01';
    'MargaretFall2018/Injury_11-1-18/D05';
    'MargaretFall2018/Injury_11-29-18/D01';
    'Margaret_Spring2019/Injury_1-24-19/D01';
    'Margaret_Spring2019/Injury_1-24-19/D05';
    'Margaret_Spring2019/Injury_1-31-19/D01';
    'Margaret_Spring2019/Injury_1-31-19/D05';
    };

%% Indexes in allfolders for each condition

MEM_sham_inds = [2, 6, 11, 15, 19, 23, 27, 30, 34];
MEM_inj_inds = [4
8
10
13
17
21
25
32
36];
MPEP_sham_inds = [1
5
14
18
22
26
29
33];
MPEP_inj_inds = [3
7
9
12
16
20
24
28
31
35];

%% count cells of each type

for findex = 1:length(allfolders)
    folder=[basepath allfolders{findex}];
    [nastros(findex,1),nsegments(findex,1),nneurons(findex,1)] = countcells(folder);
end

%% Static network measures - neurons/astros WEIGHTED

clearvars -except allfolders basepath MEM_inj_inds MEM_sham_inds MPEP_inj_inds MPEP_sham_inds

%network_measures_batch(folder,celltype,bin,conds,randomflag)
condfolders = allfolders(MEM_inj_inds);

for findex = 1:length(condfolders)
    folder=[basepath condfolders{findex}]
    [ER(findex,:),CC(findex,:),K(findex,:),BC(findex,:),Eff(findex,:),density(findex,:),str(findex,:)] ...
        = network_measures_batch(folder,'n',0,[1 2 4],1);
end

data_formatted = [vertcat(str(:,1),str(:,3),str(:,5)) ...
    vertcat(density(:,1),density(:,3),density(:,5)) ...
    vertcat(Eff(:,1),Eff(:,3),Eff(:,5)) ...
    vertcat(BC(:,1),BC(:,3),BC(:,5)) ...
    vertcat(CC(:,1),CC(:,3),CC(:,5)) ...
    vertcat(ER(:,1),ER(:,3),ER(:,5))];

% data_formatted = [density(:,5), ...
%     str(:,5)...
%    K(:,5) ...
%    BC(:,5)...
%     CC(:,5)...
%     Eff(:,5)];


%% Static network measures - multilayer

%data output format:
% - first column: for actual network
% - second column: for randomized control network
% inputs to function = (folder,conds,randomflag)
clearvars -except allfolders basepath MEM_inj_inds MEM_sham_inds MPEP_inj_inds MPEP_sham_inds
condfolders = allfolders(:);

for findex = 1:length(condfolders)
    folder=[basepath condfolders{findex}]
    [CC_nmulti(findex,:),CC_amulti(findex,:),CC_aa(findex,:),CC_nn(findex,:),CC_multi(findex,:),...
    K_nmulti(findex,:),K_amulti(findex,:),K_aa(findex,:),K_nn(findex,:),K_multi(findex,:),...
    BC_nmulti(findex,:),BC_amulti(findex,:),BC_aa(findex,:),BC_nn(findex,:),BC_multi(findex,:),...
    Eff_aa(findex,:),Eff_nn(findex,:),Eff_na(findex,:),Eff_na_ctrl(findex,:),...
    density_aa(findex,:),density_nn(findex,:),density_na(findex,:),density_multi(findex,:),....
    str_aa(findex,:),str_nn(findex,:),str_na(findex,:),str_multi(findex,:)] = multilayer_network_measures_batch(folder,[1 2 4],1);
end

% data_formatted = [vertcat(density_multi(:,1),density_multi(:,3),density_multi(:,5)) ...
%     vertcat(str_multi(:,1),str_multi(:,3),str_multi(:,5)) ...
%     vertcat(str_na(:,1),str_na(:,3),str_na(:,5)) ...
%     vertcat(BC_multi(:,1),BC_multi(:,3),BC_multi(:,5)) ...
%     vertcat(CC_multi(:,1),CC_multi(:,3),CC_multi(:,5)) ...
%     vertcat(Eff_na(:,1),Eff_na(:,3),Eff_na(:,5))];

data_formatted = [density_multi(:,6), ...
    str_multi(:,6)...
   K_multi(:,6) ...
   BC_multi(:,6)...
    CC_multi(:,6)...
    Eff_na(:,6)];


%% Astro community detection - baseline

for findex = 1:length(allfolders)
    folder=[basepath allfolders{findex}];
        [ncs(findex,:),ncf(findex,:),scs(findex,:),scf(findex,:),...
            AR(findex,:),Q_s(findex,:),Q_f(findex,:),AR_ag_af(findex,:),AR_ag_as(findex,:),...
            nca(findex,:),sca(findex,:)]...
        = community_measures_batch(folder,'a',0);
end

delta_n = reshape(ncf-ncs,[],1);
hist(delta_n,5)
nanmean(ncs-nca)
nanmean(delta_n)

%% Multilayer community detection - baseline

for findex = 1:length(allfolders)
    folder=[basepath allfolders{findex}]
        [ncs(findex,:),ncf(findex,:),scs(findex,:),scf(findex,:),...
        AR(findex,:),Q_s(findex,:),Q_f(findex,:),S_s{findex,1},S_f{findex,1},...
        pns(findex,:),pnf(findex,:),nsdasc(findex,:),nsdafc(findex,:),aparts(findex,:),apartf(findex,:),...
        nparts(findex,:),npartf(findex,:),AR_ag_af(findex,:),AR_ag_as(findex,:),AR_af_as(findex,:)]...
        = multilayer_community_measures_batch(folder);
end

delta_n = reshape(ncf-ncs,[],1);
hist(delta_n,5)

%% Multilayer community detection - conditions

for findex = 1:length(MPEP_Inj)
    folder=[basepath MPEP_Inj{findex}];
        [ncs(findex,:),ncf(findex,:),scs(findex,:),scf(findex,:),...
        AR(findex,:),Q_s(findex,:),Q_f(findex,:),S_s{findex,1},S_f{findex,1},...
        pns(findex,:),pnf(findex,:),nsdasc(findex,:),nsdafc(findex,:),aparts(findex,:),apartf(findex,:),...
        nparts(findex,:),npartf(findex,:),AR_ag_af(findex,:),AR_ag_as(findex,:),AR_af_as(findex,:)]...
        = multilayer_community_measures_batch(folder);
end

delta_n = reshape(ncf-ncs,[],1);
hist(delta_n,5)


%% Neuron community detection

clearvars -except allfolders basepath MEM_inj_inds MEM_sham_inds MPEP_inj_inds MPEP_sham_inds

condfolders = allfolders(MPEP_inj_inds);

for findex = 1:length(condfolders)
    folder=[basepath condfolders{findex}]
        [ncs(findex,:),ncf(findex,:),scs(findex,:),scf(findex,:),...
            AR(findex,:)]...
        = community_measures_batch(folder,'n',0);
end

delta_n = ncf(:,1)-ncs(:,1);
hist(delta_n,5)

%% subsample neurons to control for differences in size 

clearvars -except allfolders basepath MEM_inj_inds MEM_sham_inds MPEP_inj_inds MPEP_sham_inds

condfolders = allfolders(:);

for findex = 1:length(condfolders)
    folder=[basepath condfolders{findex}]
    [CC_multi(findex,:),...
    K_multi(findex,:),...
    BC_multi(findex,:),...
    Eff_na(findex,:),...
    density_multi(findex,:),....
    str_aa(findex,:),str_nn(findex,:),str_na(findex,:),str_multi(findex,:)] = multilayer_network_measures_batch_subsample(folder,[1 2 4]);
end

data_formatted = [vertcat(density_multi(:,1),density_multi(:,3),density_multi(:,5)) ...
    vertcat(str_multi(:,1),str_multi(:,3),str_multi(:,5)) ...
    vertcat(str_na(:,1),str_na(:,3),str_na(:,5)) ...
    vertcat(BC_multi(:,1),BC_multi(:,3),BC_multi(:,5)) ...
    vertcat(CC_multi(:,1),CC_multi(:,3),CC_multi(:,5)) ...
    vertcat(Eff_na(:,1),Eff_na(:,3),Eff_na(:,5))];

%% calculate correlation between N-A FC and distance
n_samples = 100; %number of samples of random matrices for which to compare 2D correlation
for findex = 1:length(allfolders)
    folder = [basepath allfolders{findex}]
    [FCdistcorr_na(findex,:),FCdistcorr_nn(findex,:),FCdistcorr_aa(findex,:),...
    weights_nn{findex},weights_aa{findex},weights_na{findex}] = mln_FCdistcorr(folder,n_samples);
end

%% collapse spatial-functional correlation data for plotting
aa_weights_cond1 = [];
aa_weights_cond2 = [];
aa_weights_cond3 = [];

nn_weights_cond1 = [];
nn_weights_cond2 = [];
nn_weights_cond3 = [];

na_weights_cond1 = [];
na_weights_cond2 = [];
na_weights_cond3 = [];

%astrocytes
for ff = 1:length(MPEP_inj_inds)
    findex = MPEP_inj_inds(ff);
    aa_weights_cond1 = [aa_weights_cond1; weights_aa{findex}{1}];
    aa_weights_cond2 = [aa_weights_cond2; weights_aa{findex}{2}];
    aa_weights_cond3 = [aa_weights_cond3; weights_aa{findex}{3}];
    
    nn_weights_cond1 = [nn_weights_cond1; weights_nn{findex}{1}];
    nn_weights_cond2 = [nn_weights_cond2; weights_nn{findex}{2}];
    nn_weights_cond3 = [nn_weights_cond3; weights_nn{findex}{3}];
    
    na_weights_cond1 = [na_weights_cond1; weights_na{findex}{1}];
    na_weights_cond2 = [na_weights_cond2; weights_na{findex}{2}];
    na_weights_cond3 = [na_weights_cond3; weights_na{findex}{3}];
end

%% community subsample

for findex = 1:length(allfolders)
    folder = allfolders{findex};
   [scs(findex,:),scf(findex,:),AR(findex,:),...
    aparts(findex,:),apartf(findex,:),nparts(findex,:),npartf(findex,:)] = mln_community_subsample(folder);
end

