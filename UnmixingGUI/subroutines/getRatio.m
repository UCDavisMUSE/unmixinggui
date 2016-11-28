function ratio = getRatio(image1, image2)
if sum(image2(:)) < eps
    ratio = 0;
else
    ratio = sum(image1(:)) / sum(image2(:));
end