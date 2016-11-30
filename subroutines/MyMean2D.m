function num = MyMean2D(image, mask)
if sum(mask(:)) ~= 0
    num = sum(sum( image .* mask)) / sum(mask(:));
else
    num = 0;
end
