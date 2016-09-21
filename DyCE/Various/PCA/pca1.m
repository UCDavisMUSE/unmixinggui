% this is the m-file from PCA tutorial, Jonathon Shlens, 2005
function [signals, PC, V] = pca1(data)
% performs PCA using covariance
% data - MxN matrix of input data (M dimensions, N trials);
% signals - MxN matrix of projected data
% PC - each column is a PC
% V - Mx1 matrix of variances

[M,N] = size(data)
% subrtract off the mean for each dimension
mn = mean(data, 2);

% subtract the mean (repmat replicate array)
data = data - repmat(mn,1,N); 

% calculate the covariance matrix
covariance = 1/ (N-1) * data * data';

% find the eigenvectors and eigenvalues
[PC, V] = eig(covariance);

% extract diagonal of matrix as a vector
V = diag(V);

% sort the variances in decreasing order
[junk,rindices] = sort(-1*V);

V = V(rindices);
PC = PC(:,rindices);

% project the original data set
signals = PC' * data;