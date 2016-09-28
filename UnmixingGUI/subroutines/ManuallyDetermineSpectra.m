function A = ManuallyDetermineSpectra(x);
% function A = ManuallyDetermineSpectra(x);
%
% self-explanatory.
% This function is just for educative purposes, it's a wrong way of
% determining spectra.
N = size(x);
Posf(1);
imagesc( sum(x,3));
colormap(gray);
title('Click at the 3 points, then press enter');
axis image off;
[ X, Y] = ginput;
close;
numberOfDots = size( X, 1);
myDot = [X Y];
myProfile = zeros( numberOfDots, N(3));
for i = 1 : numberOfDots
    for j = 1 : N(3)
        myProfile(i,j) = x( round( myDot( i, 2)), round( myDot( i, 1)), j);
    end
end
%     pos(1);
%     plot(t,myProfile,'-.','Linewidth',4);
%     leg = (1:numberOfDots)';
%     legend(num2str(leg));
%     title('Choosen profiles');

A = myProfile';
%  A = A./(ones(size(A,1),1)*max(A,[],1));
note = 'Manualy determined spectra was used.         .';
