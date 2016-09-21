function insideContour = FindInsideContour(mask);
% function insideContour = FindInsideContour(mask);
% Erodes 'mask' until it finds small contour inside the organ.
% There are two stoping criteria:
% 1) when contour becomes 2 times smaller then the initial one (compares sums), or
% 2) when 20 erodes has been performed.
% Function also checks if the contour becomes too small in the last iteration and if it does,
% goes one iteration back (purpose of 'insideContourOld').
%
% N. Bozinovic 08/26/08

N = size(mask);
temp1 = mask;

% this is not working i.e. function FILL is not filling properly
% [X,Y] = ConvertContourToVector(mask);
% Pos(1);
% h = fill(X,Y,[1 1 1]);
% X = get(h,'XData');
% Y = get(h,'YData');
% close;
% temp1 = ConvertVectorToMask(X,Y,N);

% filles temp1 in case it has holes
% temp2 = ErodeMask( temp1, 3);    
% insideContour = temp1 - temp2 == 1;
% [X,Y] = ConvertContourToVector(insideContour);
% xx = 1:N(1);
% yy = 1:N(2);
% [XX,YY] = meshgrid(xx,yy);
% temp1 = inpolygon(XX',YY',X,Y);
% ----------------

% PutImageAt(temp1,'',1);
% close

temp2 = ErodeMask( temp1, 3);    
insideContour = temp1 - temp2 == 1;
Sinitial = sum(insideContour(:));
S = Sinitial;
i = 1;
while S > 0.3*Sinitial && i < 20
%     PutImageAt(insideContour,'',1);
%     close;
    insideContourOld = insideContour;
    temp1 = ErodeMask( temp1, 3);
    temp2 = ErodeMask( temp1, 3);    
    insideContour = temp1 - temp2 == 1;
    S = sum(insideContour(:));
    i = i + 1;
end

% checks if the 'insideContour' has become too small in the last iteration if it has,
% goes one iteration back

if S == 0
    insideContour = insideContourOld;
end