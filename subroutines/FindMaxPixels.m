function topSpectra = FindMaxPixels(image, numberOfPixels)

N = size(image);

topSpectra.value = zeros(numberOfPixels,1);
topSpectra.location1 = ones(numberOfPixels,1);
topSpectra.location2 = ones(numberOfPixels,1);

for i= 1:N(1)
    for j = 1:N(2)
        power = image(i,j);

        temp.value = topSpectra.value(1);

        % topSpectra is sorted with the smallest power first
        if(power > temp.value)
            % remove lowest value and add in new tmp value with higher
            % power
            topSpectra.value(1) = power;
            topSpectra.location1(1) = i;
            topSpectra.location2(1) = j;
            % resort so current lowest power is first
            topSpectra = ListSort(topSpectra);
        end
    end
end
