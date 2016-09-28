function PresentComponentsRGB(mask, position, subplotSize);
Pos(position);
for i = 1:size(mask,4)
    subplot( subplotSize(1), subplotSize(2), i);
    PutImage(mask(:,:,:,i), num2str(i));
end