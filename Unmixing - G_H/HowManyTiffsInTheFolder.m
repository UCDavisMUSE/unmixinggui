function counter = HowManyTiffsInTheFolder(pathname)
folderStruct = dir(pathname);
% count how many tiffs are in the folder
counter = 0;
for i = 1:length(folderStruct)
    if (folderStruct(i).isdir ~= 1) && strcmp(GetExtension(folderStruct(i).name),'tif')
        counter = counter + 1;
    end
end