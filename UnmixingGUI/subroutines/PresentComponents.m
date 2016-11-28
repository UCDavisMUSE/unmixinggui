function PresentComponents(mask, position, subplotSize);
% function PresentComponents(mask, position, subplotSize);
%
% Present RCA components.
%
% N. Bozinovic, 08/26/08

Pos(position);
for i = 1 : size(mask, 3)
    subplot( subplotSize(1), subplotSize(2), i);
    PutImage(mask(:,:,i), num2str(i));
end