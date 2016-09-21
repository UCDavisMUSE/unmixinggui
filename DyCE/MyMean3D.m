function num = MyMean3D(cube, mask)
if sum(mask(:)) ~= 0
    for k = 1:size(cube,3)
        num(k) = sum(sum( cube(:,:,k).* mask)) / sum(mask(:));
    end
else
    num = zeros(1,size(cube,3));
end