function PresentOrganList(organList, myTitleList)
% function presentOrganList(organList)
%
% Presents organs in a nice way. Meant to be used in the rolling RCA.
%
% N.Bozinovic, 08/22/08

M = size(organList,3);
Posf(2);
if M < 5
    for i = 1 : M
        subplot(1,M,i);
        PutImage(organList(:,:,i), myTitleList(i,:));
    end
elseif M < 9
    for i = 1 : M
        subplot(2,4,i);
        PutImage(organList(:,:,i),myTitleList(i,:));
    end
elseif M < 17
    for i = 1 : 8
        subplot(2,4,i);
        PutImage(organList(:,:,i),myTitleList(i,:));
    end
    Posf(2);
    for i = 9 : M
        subplot(2,4,i-8);
        PutImage(organList(:,:,i),myTitleList(i,:));
    end 
end