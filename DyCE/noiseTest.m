 clc;
 close all;
 N = size(X);
 Y = X + 15*randn(N);
 figure;
 imagesc(Y);
 colorbar
 axis image off 
%%
%a = 2*randn(10); % produces matrix 10x10 with mean 0 and std 2