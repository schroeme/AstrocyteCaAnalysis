function [kden,N,K] = density_multi_MS(CIJ,n1,n2)
% Calculates density of inter-layer connections
%
%   kden = density_und(CIJ);
%   [kden,N,K] = density_und(CIJ,n1,n2);
%
%   Density is the fraction of present connections to possible connections.
%
%   Input:      CIJ,    undirected (weighted/binary) connection matrix
%               n1, number of nodes in first layer
%               n2, number of nodes in second layer
%
%   Output:     kden,   density of interlayer edges
%               N,      number of possible interlayer connections
%               K,      number of interlayer edges
%
%   Notes:  Assumes CIJ is undirected and has no self-connections.
%           Weight information is discarded.
%
%
%   adapted from Olaf Sporns, Indiana University, 2002/2007/2008
%   by Margaret Schroeder, 4/5/2019

N = n1*n2; %number of possible connections
K = nnz(CIJ(1:n1,n1+1:end));
kden = K/N;

