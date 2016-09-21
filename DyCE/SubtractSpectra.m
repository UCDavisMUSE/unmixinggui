function cube1  = SubtractSpectra(vector, image, cube)
N = size(cube);
cube1 = cube;
counter = 0;
for i = 1:N(1)
    for j = 1:N(2)
        for w = 1:N(3)
            if image(i,j) > 0
                cube1(i,j,w) = cube(i,j,w) - image(i,j)*vector(w);
                if cube1(i,j,w) < 0
                    cube1(i,j,w) = 0;
                    counter = counter + 1;
                end
            end
        end
    end
end
counter;