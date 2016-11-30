% this is the m-file from PCA tutorial, Jonathon Shlens, 2005
function [signals, PC, V] = pca2(data)
% performs PCA using covariance
% data - MxN matrix of input data (M dimensions, N trials);
% signals - MxN matrix of projected data
% PC - each column is a PC
% V - Mx1 matrix of variances

[M,N] = size(data)
% subrtract off the mean for each dimension
mn = mean(data, 2);
data = data - repmat(mn,1,N);

% this doens't work becuase of the matrix size! so we use SVD
% covariance = 1/ (N-1) * data * data';

Y = data' / sqrt(N-1);
size(Y)
[u, S, PC] = svd(Y,0); 

S = diag(S);
V = S.*S;

% project the original data set
signals = PC' * data;