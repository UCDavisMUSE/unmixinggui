function [stripedName, extension] = ParseFilename(name)
index = strfind(name,'.');
if isempty(index)
    stripedName = name;
    extension = [];
else 
    stripedName = name(1:index-1);
    extension = name(index+1:end);
end