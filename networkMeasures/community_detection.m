function [ncs,ncf,scs,scf,AR,Q_s,Q_f,S_s,S_f,AR_ag_af,AR_ag_as]=community_detection(A_spat,A_fxn,gamma_s,gamma_f,its,agroups)

%ncs - number of communities predicted by spatial
%ncf - number of communities predicted by functional
%scs - size of community predicted by spatial
%scf - size of community predicted by functional
%AR - adjusted rand index btwn spatial and functional
%Q_s - quality of spatial modularity
%Q_f - quality of functional modularity
%S_s - 

%%
%A is weighted or unweighted matrix
%bin = 1 if functional matrix is binary
%spatial matrices are always weighted and full

%Newman-Girvan null model for spatial
str_spat = strengths_und(A_spat);
P_spat_num = str_spat'*str_spat;
m_spat = .5*sum(sum(A_spat));
P_spat = P_spat_num/(2*m_spat); %NG null!

%Newman-Girvan null model for functional
str_fxn = strengths_und(A_fxn);
P_fxn_num = str_fxn'*str_fxn;
m_fxn = .5*sum(sum(A_fxn));
P_fxn = P_fxn_num/(2*m_fxn); %NG null!

B_spat = A_spat - gamma_s*P_spat;
B_fxn = A_fxn - gamma_f*P_fxn;

for ii = 1:its
    [S_spat(ii,:),Q_spat(ii,1),n_it_spat(ii,1)]=iterated_genlouvain(B_spat,1000,0);
    [S_fxn(ii,:),Q_fxn(ii,1),n_it_fxn(ii,1)]=iterated_genlouvain(B_fxn,1000,0);
end
        
S_s = mode(S_spat,1);
S_f = mode(S_fxn,1);
Q_s = mean(Q_spat);
Q_f = mean(Q_fxn);

[~,~,Ic]=unique(S_s);
S_s=Ic;
[~,~,Ic2]=unique(S_f);
S_f=Ic2;

%disp('number of communities predicted from spatial graph = ')
ncs = max(S_s);
%disp('number of communities predicted from functional graph = ')
ncf = max(S_f);

counts_s=histc(S_s,unique(S_s));
counts_f=histc(S_f,unique(S_f));
scs = mean(counts_s); %mean community size, spatial
scf = mean(counts_f);

AR = RandIndex(S_s,S_f);
if nargin >  5
    AR_ag_af = RandIndex(S_f,agroups);
    AR_ag_as = RandIndex(S_s,agroups);
end

