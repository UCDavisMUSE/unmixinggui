function tiffStruct = LoadTiffsFromFolder(pathname, Nstart, Nlength)
% function tiffStruct = LoadTiffsFromFolder(pathname, Nstart, Nlength)
%
% Self-explanatory.
%
% N.Bozinovic 08/27/08
folderStruct = dir(pathname);
counter = HowManyTiffsInTheFolder(pathname);

if Nstart + Nlength - 1 > counter;
    msgbox(['There are only ' num2str(counter,'%03g') ' tif images in the folder.            .']);
    return;
end
index = 0;
i = 1;
tiffCounter = 0;
bool = 1;
while bool && (i <= length(folderStruct))
    if (folderStruct(i).isdir ~= 1) && strcmp(GetExtension(folderStruct(i).name),'tif')
        tiffCounter = tiffCounter + 1;
        if (tiffCounter >= Nstart)
            index = index + 1;
            tiffStruct(index) = folderStruct(i);
        end
        if index >= Nlength
            bool = 0;
        end
    end
    i = i + 1;
end