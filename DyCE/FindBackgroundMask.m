function backgroundMask = FindBackgroundMask(mask)
% function backgroundMask = FindBackgroundMask(mask)
%
% Finds the appropriate 'backgroundMask' by subtracting masks of all the
% organs from initial 'backgroundMask'. In order to get as pure
% 'backgroundMask' as possible, 'maskOfAllOrgans' is being dilated as much as possible.
% 
% The stoping criteria are:
% 1) the aree of 'backgroundMask' becomes less then 10% of the initial one, or
% 2) 20 dilataions has been performed.
%
% Function also checks if 'backgroundMask' has become too small in the last
% iteration and if it has, goes one iteration back.
%
% N.Bozinovic, 08/27/08
M = size(mask);
maskOfAllOrgans = sum( mask(:,:,2:M(3)), 3) > 0;
backgroundMask = (mask(:,:,1) - maskOfAllOrgans) > 0;
backgroundMaskOld = backgroundMask;

Sinitial = sum(backgroundMask(:));
maskOfAllOrgans = DilateMask(maskOfAllOrgans,3);
backgroundMask = (mask(:,:,1) - maskOfAllOrgans) > 0;
S = sum(backgroundMask(:));

i = 1;
while (S > 0.4*Sinitial && i < 20)
    backgroundMaskOld = backgroundMask;
    maskOfAllOrgans = DilateMask(maskOfAllOrgans,3);
    backgroundMask = (mask(:,:,1) - maskOfAllOrgans) > 0;
    S = sum(backgroundMask(:));
    i = i + 1;
end

% checks if 'backgroundMask' has become too small and if it has, goes one iteration back
if S == 0
    backgroundMask = backgroundMaskOld;
end



